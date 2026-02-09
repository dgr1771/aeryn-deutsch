import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../core/grammar_engine.dart';

/// 颜色编码文本组件 - Color Coded Text
///
/// 德语名词自动根据性别着色
/// - der (阳性): 蓝色
/// - die (阴性): 红色
/// - das (中性): 绿色
class ColorCodedText extends StatefulWidget {
  final String text;
  final TextStyle? baseStyle;
  final void Function(String word, GermanGender gender)? onWordTap;
  final bool showGenderIndicators;

  const ColorCodedText({
    Key? key,
    required this.text,
    this.baseStyle,
    this.onWordTap,
    this.showGenderIndicators = true,
  }) : super(key: key);

  @override
  State<ColorCodedText> createState() => _ColorCodedTextState();
}

class _ColorCodedTextState extends State<ColorCodedText> {
  final Set<String> _selectedWords = {};

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: _buildSpans(),
      ),
    );
  }

  List<InlineSpan> _buildSpans() {
    final spans = <InlineSpan>[];
    final words = widget.text.split(RegExp(r'(\s+)'));

    for (final word in words) {
      if (word.trim().isEmpty) {
        // 保留空格
        spans.add(TextSpan(text: word, style: widget.baseStyle));
        continue;
      }

      // 检查是否为名词
      if (GrammarEngine.isNoun(word)) {
        final gender = GrammarEngine.predictGender(word);
        final color = GrammarEngine.getColor(gender);

        // 检查是否选中
        final isSelected = _selectedWords.contains(word);

        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: () => _onWordTap(word, gender),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withValues(alpha: 0.3)
                        : color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: color.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.showGenderIndicators && gender != GermanGender.none)
                        Container(
                          margin: const EdgeInsets.only(right: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            _getGenderArticle(gender),
                            style: TextStyle(
                              fontSize: (widget.baseStyle?.fontSize ?? 14) * 0.7,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Text(
                        word,
                        style: (widget.baseStyle ?? const TextStyle()).copyWith(
                          color: isSelected ? color : color.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600,
                          decoration: isSelected
                              ? TextDecoration.underline
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        // 非名词
        spans.add(
          TextSpan(
            text: word,
            style: widget.baseStyle,
          ),
        );
      }
    }

    return spans;
  }

  String _getGenderArticle(GermanGender gender) {
    switch (gender) {
      case GermanGender.der:
        return 'der';
      case GermanGender.die:
        return 'die';
      case GermanGender.das:
        return 'das';
      default:
        return '';
    }
  }

  void _onWordTap(String word, GermanGender gender) {
    setState(() {
      if (_selectedWords.contains(word)) {
        _selectedWords.remove(word);
      } else {
        _selectedWords.add(word);
      }
    });

    widget.onWordTap?.call(word, gender);
  }
}

/// 交互式文本阅读器
///
/// 集成单词点击、释义弹窗、添加到生词本等功能
class InteractiveTextReader extends StatefulWidget {
  final String text;
  final Function(String)? onWordLongPress;

  const InteractiveTextReader({
    Key? key,
    required this.text,
    this.onWordLongPress,
  }) : super(key: key);

  @override
  State<InteractiveTextReader> createState() => _InteractiveTextReaderState();
}

class _InteractiveTextReaderState extends State<InteractiveTextReader> {
  String? _selectedWord;
  GermanGender? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ColorCodedText(
          text: widget.text,
          baseStyle: const TextStyle(
            fontSize: 18,
            height: 1.6,
            color: Colors.black87,
          ),
          showGenderIndicators: true,
          onWordTap: (word, gender) {
            _showWordBottomSheet(context, word, gender);
          },
        ),
      ],
    );
  }

  void _showWordBottomSheet(
    BuildContext context,
    String word,
    GermanGender gender,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 拖动指示器
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // 单词信息
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 词性和性别
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: GrammarEngine.getColor(gender),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getGenderArticle(gender),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          word,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 操作按钮
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // 添加到生词本
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('已将 "$word" 添加到生词本'),
                                  backgroundColor: GrammarEngine.genderColors['das'],
                                ),
                              );
                            },
                            icon: const Icon(Icons.bookmark_add),
                            label: const Text('加入生词本'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: GrammarEngine.genderColors['der'],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // AI 深度解析
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.auto_awesome),
                            label: const Text('AI 解析'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: GrammarEngine.genderColors['die'],
                              side: BorderSide(
                                color: GrammarEngine.genderColors['die']!,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getGenderArticle(GermanGender gender) {
    switch (gender) {
      case GermanGender.der:
        return 'der';
      case GermanGender.die:
        return 'die';
      case GermanGender.das:
        return 'das';
      default:
        return '?';
    }
  }
}
