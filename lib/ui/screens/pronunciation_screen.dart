/// 发音练习页面
///
/// 提供词汇和句子的朗读、跟读、录音对比功能
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/tts_service.dart';

/// 发音练习状态
class PronunciationState {
  final bool isSpeaking;
  final bool isRecording;
  final String? currentText;
  final String? feedback;
  final double pronunciationScore; // 0-100

  const PronunciationState({
    this.isSpeaking = false,
    this.isRecording = false,
    this.currentText,
    this.feedback,
    this.pronunciationScore = 0.0,
  });

  const PronunciationState.initial() : this();

  PronunciationState copyWith({
    bool? isSpeaking,
    bool? isRecording,
    String? currentText,
    String? feedback,
    double? pronunciationScore,
  }) {
    return PronunciationState(
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isRecording: isRecording ?? this.isRecording,
      currentText: currentText ?? this.currentText,
      feedback: feedback ?? this.feedback,
      pronunciationScore: pronunciationScore ?? this.pronunciationScore,
    );
  }
}

/// 发音练习Notifier
class PronunciationNotifier extends StateNotifier<PronunciationState> {
  final TTSService _ttsService = TTSService.instance;

  PronunciationNotifier() : super(const PronunciationState.initial()) {
    _init();
  }

  Future<void> _init() async {
    await _ttsService.initialize();
  }

  /// 朗读文本
  Future<void> speak(String text) async {
    state = state.copyWith(
      currentText: text,
      isSpeaking: true,
      feedback: null,
    );

    final success = await _ttsService.speak(text);

    if (!success) {
      state = state.copyWith(
        isSpeaking: false,
        feedback: '朗读失败',
      );
    }
  }

  /// 慢速朗读
  Future<void> speakSlow(String text) async {
    state = state.copyWith(
      currentText: text,
      isSpeaking: true,
    );

    await _ttsService.speakSlow(text);
  }

  /// 停止朗读
  Future<void> stop() async {
    await _ttsService.stop();
    state = state.copyWith(
      isSpeaking: false,
      isRecording: false,
    );
  }

  /// 设置语速
  Future<void> setSpeechRate(double rate) async {
    await _ttsService.setSpeechRate(rate);
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }
}

/// 发音练习页面
class PronunciationScreen extends ConsumerStatefulWidget {
  const PronunciationScreen({super.key});

  @override
  ConsumerState<PronunciationScreen> createState() => _PronunciationScreenState();
}

class _PronunciationScreenState extends ConsumerState<PronunciationScreen> {
  final PronunciationNotifier _notifier = PronunciationNotifier();
  double _speechRate = 0.5;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发音练习'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: StateNotifierProvider<PronunciationNotifier>(
        create: (_) => _notifier,
        builder: (context, ref, child) {
          final state = ref.watch(_notifier);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 当前文本显示
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '当前文本',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            state.currentText ?? '请选择要练习的文本',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 控制按钮
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: state.isSpeaking
                            ? null
                            : () => _notifier.speak(state.currentText ?? ''),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('朗读'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: state.isSpeaking
                            ? () => _notifier.stop()
                            : null,
                        icon: const Icon(Icons.stop),
                        label: const Text('停止'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: state.isSpeaking
                            ? null
                            : () => _notifier.speakSlow(state.currentText ?? ''),
                        icon: const Icon(Icons.speed),
                        label: const Text('慢速'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 语速控制
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '语速调节',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Slider(
                          value: _speechRate,
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                          label: '语速',
                          onChanged: (value) async {
                            setState(() {
                              _speechRate = value;
                            });
                            await _notifier.setSpeechRate(value);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('慢'),
                              Text(
                                '${(_speechRate * 100).toInt()}%',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const Text('快'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 练习模式
                Text(
                  '练习模式',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.text_fields, color: Colors.blue),
                        title: const Text('单词练习'),
                        subtitle: const Text('学习单词的正确发音'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WordPronunciationScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.format_quote, color: Colors.green),
                        title: const Text('句子练习'),
                        subtitle: const Text('练习整句的朗读'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SentencePronunciationScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.record_voice_over, color: Colors.orange),
                        title: const Text('跟读练习'),
                        subtitle: const Text('听后跟读，纠正发音'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShadowingScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 单词发音练习页面
class WordPronunciationScreen extends StatefulWidget {
  const WordPronunciationScreen({super.key});

  @override
  State<WordPronunciationScreen> createState() => _WordPronunciationScreenState();
}

class _WordPronunciationScreenState extends State<WordPronunciationScreen> {
  final TTSService _ttsService = TTSService.instance;
  final List<Map<String, dynamic>> _words = [
    {
      'word': 'Hallo',
      'article': null,
      'meaning': '你好',
      'example': 'Hallo, wie geht es dir?',
    },
    {
      'word': 'Danke',
      'article': null,
      'meaning': '谢谢',
      'example': 'Vielen Dank für Ihre Hilfe.',
    },
    {
      'word': 'der Hund',
      'article': 'der',
      'meaning': '狗',
      'example': 'Der Hund spielt im Garten.',
    },
    {
      'word': 'sprechen',
      'article': null,
      'meaning': '说',
      'example': 'Ich spreche Deutsch.',
    },
    {
      'word': 'verstehen',
      'article': null,
      'meaning': '理解',
      'example': 'Ich verstehe dich nicht.',
    },
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentWord = _words[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('单词发音练习'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 进度指示
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / _words.length,
                  ),
                ),
                const SizedBox(width: 8),
                Text('${_currentIndex + 1}/${_words.length}'),
              ],
            ),
            const SizedBox(height: 24),

            // 当前单词
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      currentWord['article'] != null
                          ? '${currentWord['article']} ${currentWord['word']}'
                          : currentWord['word'],
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentWord['meaning'],
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        currentWord['example'],
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 控制按钮
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await _ttsService.speakWord(
                        word: currentWord['word'],
                        article: currentWord['article'] ?? '',
                        example: currentWord['example'],
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('朗读'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await _ttsService.speakSlow(currentWord['word']);
                    },
                    icon: const Icon(Icons.speed),
                    label: const Text('慢速'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 下一个按钮
            ElevatedButton.icon(
              onPressed: () {
                if (_currentIndex < _words.length - 1) {
                  setState(() {
                    _currentIndex++;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.arrow_forward),
              label: Text(_currentIndex < _words.length - 1 ? '下一个' : '完成'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 句子发音练习页面
class SentencePronunciationScreen extends StatefulWidget {
  const SentencePronunciationScreen({super.key});

  @override
  State<SentencePronunciationScreen> createState() => _SentencePronunciationScreenState();
}

class _SentencePronunciationScreenState extends State<SentencePronunciationScreen> {
  final TTSService _ttsService = TTSService.instance;
  final List<String> _sentences = [
    'Guten Tag! Wie geht es Ihnen heute?',
    'Ich heiße Müller und komme aus Deutschland.',
    'Das Wetter ist heute sehr schön.',
    'Ich lerne Deutsch seit drei Monaten.',
    'Können Sie das bitte wiederholen?',
    'Ich möchte einen Termin für morgen machen.',
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('句子发音练习'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 进度
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / _sentences.length,
                  ),
                ),
                const SizedBox(width: 8),
                Text('${_currentIndex + 1}/${_sentences.length}'),
              ],
            ),
            const SizedBox(height: 24),

            // 当前句子
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Text(
                _sentences[_currentIndex],
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.blue[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // 按钮
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await _ttsService.speakSentence(
                        sentence: _sentences[_currentIndex],
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('朗读'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await _ttsService.speakSlow(_sentences[_currentIndex]);
                    },
                    icon: const Icon(Icons.speed),
                    label: const Text('慢速'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await _ttsService.speakRepeated(
                        text: _sentences[_currentIndex],
                        repetitions: 3,
                      );
                    },
                    icon: const Icon(Icons.repeat),
                    label: const Text('重复'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
                if (_currentIndex < _sentences.length - 1) {
                  setState(() {
                    _currentIndex++;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.arrow_forward),
              label: Text(_currentIndex < _sentences.length - 1 ? '下一个' : '完成'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 跟读练习页面
class ShadowingScreen extends StatefulWidget {
  const ShadowingScreen({super.key});

  @override
  State<ShadowingScreen> createState() => _ShadowingScreenState();
}

class _ShadowingScreenState extends State<ShadowingScreen> {
  final TTSService _ttsService = TTSService.instance;
  bool _isListening = false;
  int _repetition = 0;

  final String _text = 'Die deutsche Sprache ist sehr interessant, aber nicht einfach zu lernen.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('跟读练习'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _text,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              '步骤',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text('$_repetition'),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    title: Text(_getStepTitle()),
                    subtitle: Text(_getStepDescription()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () async {
                setState(() {
                  _isListening = true;
                });

                // 先听
                await _ttsService.speakNormal(_text);
                await Future.delayed(const Duration(seconds: 1));

                // 慢速跟读
                if (_repetition < 3) {
                  await _ttsService.speakSlow(_text);
                  setState(() {
                    _repetition++;
                  });
                }

                setState(() {
                  _isListening = false;
                });
              },
              icon: const Icon(Icons.hearing),
              label: const Text('开始跟读'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle() {
    switch (_repetition) {
      case 0:
        return '听一遍';
      case 1:
        return '跟读第2遍';
      case 2:
        return '跟读第3遍';
      case 3:
        return '练习完成！';
      default:
        return '';
    }
  }

  String _getStepDescription() {
    switch (_repetition) {
      case 0:
        return '仔细听原文的发音和语调';
      case 1:
        return '跟着朗读，尽量模仿';
      case 2:
        return '再练习一遍，加深印象';
      case 3:
        return '你已经完成了3遍练习';
      default:
        return '';
    }
  }
}
