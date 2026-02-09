/// 演讲学习页面
library;

import 'package:flutter/material.dart';
import '../../models/speech_learning.dart';
import '../../data/german_speeches.dart';
import '../../services/speech_learning_service.dart';

class SpeechLearningScreen extends StatefulWidget {
  const SpeechLearningScreen({super.key});

  @override
  State<SpeechLearningScreen> createState() => _SpeechLearningScreenState();
}

class _SpeechLearningScreenState extends State<SpeechLearningScreen> {
  final SpeechLearningService _service = SpeechLearningService();

  SpeechDifficulty? _selectedDifficulty;
  SpeechTopic? _selectedTopic;
  String? _selectedGender;

  Speech? _selectedSpeech;
  List<Speech> _filteredSpeeches = [];
  List<Speech> _favoriteSpeeches = [];

  // 播放状态
  bool _isPlaying = false;
  double _playbackPosition = 0.0;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _service.initialize();
    _updateSpeeches();
    _updateFavorites();
  }

  void _updateSpeeches() {
    final allSpeeches = getAllSpeeches();

    setState(() {
      _filteredSpeeches = allSpeeches.where((speech) {
        if (_selectedDifficulty != null &&
            speech.difficulty != _selectedDifficulty) {
          return false;
        }
        if (_selectedTopic != null &&
            !speech.topics.contains(_selectedTopic)) {
          return false;
        }
        if (_selectedGender != null &&
            speech.speaker.gender != _selectedGender) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  Future<void> _updateFavorites() async {
    final favoriteIds = _service.getFavorites();
    setState(() {
      _favoriteSpeeches = favoriteIds
          .map((id) => getSpeechById(id))
          .whereType<Speech>()
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('演讲学习'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: _showFavorites,
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _showStatistics,
          ),
        ],
      ),
      body: Row(
        children: [
          // 左侧：筛选和列表
          SizedBox(
            width: 320,
            child: _buildSidebar(),
          ),
          // 右侧：主要内容
          Expanded(
            child: _selectedSpeech != null
                ? _buildSpeechContent()
                : _buildWelcomeScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        children: [
          // 筛选区域
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '筛选',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 12),

                // 难度筛选
                Text(
                  '难度',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildDifficultyChip(null, '全部'),
                    ...SpeechDifficulty.values.map((difficulty) {
                      return _buildDifficultyChip(
                        difficulty,
                        _getDifficultyName(difficulty),
                      );
                    }),
                  ],
                ),

                const SizedBox(height: 12),

                // 性别筛选
                Text(
                  '演讲者性别',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildGenderChip(null, '全部'),
                    _buildGenderChip('male', '男性'),
                    _buildGenderChip('female', '女性'),
                  ],
                ),

                const SizedBox(height: 12),

                // 主题筛选
                Text(
                  '主题',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                DropdownButton<SpeechTopic>(
                  isExpanded: true,
                  hint: const Text('选择主题'),
                  value: _selectedTopic,
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('全部主题'),
                    ),
                    ...SpeechTopic.values.map((topic) {
                      return DropdownMenuItem(
                        value: topic,
                        child: Text(_getTopicName(topic)),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedTopic = value;
                      _updateSpeeches();
                    });
                  },
                ),
              ],
            ),
          ),

          // 演讲列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _filteredSpeeches.length,
              itemBuilder: (context, index) {
                final speech = _filteredSpeeches[index];
                final isSelected = _selectedSpeech?.id == speech.id;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: speech.speaker.imageUrl != null
                        ? NetworkImage(speech.speaker.imageUrl!)
                        : null,
                    child: speech.speaker.imageUrl == null
                        ? Text(speech.speaker.name[0])
                        : null,
                  ),
                  title: Text(
                    speech.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.blue : Colors.black87,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(speech.speaker.name),
                      Row(
                        children: [
                          Chip(
                            label: Text(
                              _getDifficultyName(speech.difficulty),
                              style: TextStyle(fontSize: 10),
                            ),
                            backgroundColor: _getDifficultyColor(speech.difficulty),
                          ),
                          const SizedBox(width: 4),
                          Text('${speech.minutes} 分钟',
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  selected: isSelected,
                  selectedTileColor: Colors.blue.shade50,
                  onTap: () {
                    setState(() {
                      _selectedSpeech = speech;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.record_voice_over,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 24),
          Text(
            '学习德国最优秀演讲者的德语',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '共 ${_filteredSpeeches.length} 个演讲可选',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // 显示推荐演讲
              _showRecommended();
            },
            icon: const Icon(Icons.recommend),
            label: const Text('查看推荐'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeechContent() {
    if (_selectedSpeech == null) return const SizedBox();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 演讲信息
          _buildSpeechHeader(),

          const SizedBox(height: 24),

          // 音频播放器
          _buildAudioPlayer(),

          const SizedBox(height: 24),

          // 学习工具
          _buildLearningTools(),

          const SizedBox(height: 24),

          // 转录文本
          _buildTranscript(),

          const SizedBox(height: 24),

          // 学习建议
          _buildLearningTips(),
        ],
      ),
    );
  }

  Widget _buildSpeechHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: _selectedSpeech!.speaker.imageUrl != null
                    ? NetworkImage(_selectedSpeech!.speaker.imageUrl!)
                    : null,
                child: _selectedSpeech!.speaker.imageUrl == null
                    ? Text(_selectedSpeech!.speaker.name[0],
                        style: TextStyle(fontSize: 24))
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedSpeech!.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedSpeech!.speaker.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (_selectedSpeech!.speaker.title != null)
                          Chip(
                            label: Text(_selectedSpeech!.speaker.title!,
                                style: TextStyle(fontSize: 11)),
                            backgroundColor: Colors.purple.shade100,
                          ),
                        if (_selectedSpeech!.speaker.organization != null)
                          Chip(
                            label: Text(_selectedSpeech!.speaker.organization!,
                                style: TextStyle(fontSize: 11)),
                            backgroundColor: Colors.blue.shade100,
                          ),
                        Chip(
                          label: Text(
                            _getDifficultyName(_selectedSpeech!.difficulty),
                            style: TextStyle(fontSize: 11),
                          ),
                          backgroundColor:
                              _getDifficultyColor(_selectedSpeech!.difficulty),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  _service.isFavorited(_selectedSpeech!.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: _service.isFavorited(_selectedSpeech!.id)
                      ? Colors.red
                      : Colors.grey,
                ),
                onPressed: () {
                  _toggleFavorite(_selectedSpeech!.id);
                },
              ),
            ],
          ),
          if (_selectedSpeech!.event != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.event, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(_selectedSpeech!.event!,
                    style: TextStyle(color: Colors.grey.shade700)),
                if (_selectedSpeech!.location != null) ...[
                  const SizedBox(width: 16),
                  Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(_selectedSpeech!.location!,
                      style: TextStyle(color: Colors.grey.shade700)),
                ],
                if (_selectedSpeech!.speechDate != null) ...[
                  const SizedBox(width: 16),
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedSpeech!.speechDate!.year}/${_selectedSpeech!.speechDate!.month}/${_selectedSpeech!.speechDate!.day}',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ],
            ),
          ],
          if (_selectedSpeech!.summary != null) ...[
            const SizedBox(height: 12),
            Text(_selectedSpeech!.summary!,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
          ],
        ],
      ),
    );
  }

  Widget _buildAudioPlayer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // 进度条
          Slider(
            value: _playbackPosition,
            max: _selectedSpeech!.duration.toDouble(),
            onChanged: (value) {
              setState(() {
                _playbackPosition = value;
              });
            },
          ),
          // 时间显示
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_playbackPosition.toInt())),
                Text(_formatDuration(_selectedSpeech!.duration)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 播放控制
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10),
                onPressed: () {
                  setState(() {
                    _playbackPosition =
                        (_playbackPosition - 10).clamp(0, _selectedSpeech!.duration.toDouble());
                  });
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 48,
                color: Colors.purple.shade600,
                onPressed: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                  // TODO: 实际播放音频
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.forward_10),
                onPressed: () {
                  setState(() {
                    _playbackPosition =
                        (_playbackPosition + 10).clamp(0, _selectedSpeech!.duration.toDouble());
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 播放速度
          Wrap(
            spacing: 8,
            children: [0.5, 0.75, 1.0, 1.25, 1.5].map((speed) {
              return ChoiceChip(
                label: Text('${speed}x'),
                selected: _playbackSpeed == speed,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _playbackSpeed = speed;
                    });
                  }
                },
                selectedColor: Colors.purple.shade600,
                labelStyle: TextStyle(
                  color: _playbackSpeed == speed ? Colors.white : Colors.grey.shade700,
                  fontSize: 12,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningTools() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '学习工具',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: 显示词汇表
                  },
                  icon: const Icon(Icons.menu_book),
                  label: const Text('词汇表'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: 显示语法笔记
                  },
                  icon: const Icon(Icons.school),
                  label: const Text('语法笔记'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: 显示文化背景
                  },
                  icon: const Icon(Icons.public),
                  label: const Text('文化背景'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTranscript() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '转录文本',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          // 如果有分段，显示分段；否则显示全文
          if (_selectedSpeech!.segments.isNotEmpty)
            ...(_selectedSpeech!.segments.map((segment) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${_formatDuration(segment.startTime)} - ${_formatDuration(segment.endTime)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.bookmark_add, size: 16),
                              onPressed: () {
                                // TODO: 收藏片段
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(segment.germanText,
                            style: TextStyle(fontSize: 16, height: 1.6)),
                        if (segment.translation != null) ...[
                          const SizedBox(height: 8),
                          Text(segment.translation!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
                              )),
                        ],
                        if (segment.keyVocabulary != null &&
                            segment.keyVocabulary!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: segment.keyVocabulary!.map((vocab) {
                              return Chip(
                                label: Text(vocab, style: TextStyle(fontSize: 12)),
                                backgroundColor: Colors.blue.shade50,
                              );
                            }).toList(),
                          ),
                        ],
                        if (segment.grammarNote != null ||
                            segment.culturalNote != null) ...[
                          const SizedBox(height: 12),
                          if (segment.grammarNote != null)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.school, size: 16, color: Colors.green),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(segment.grammarNote!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade700,
                                      )),
                                ),
                              ],
                            ),
                          if (segment.culturalNote != null)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.public, size: 16, color: Colors.orange),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(segment.culturalNote!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade700,
                                      )),
                                ),
                              ],
                            ),
                        ],
                      ],
                    ),
                  ),
                )))
          else
            Text(_selectedSpeech!.transcript,
                style: TextStyle(fontSize: 16, height: 1.8)),
        ],
      ),
    );
  }

  Widget _buildLearningTips() {
    final tips = _service.getLearningTips(_selectedSpeech!);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber.shade700),
              const SizedBox(width: 12),
              Text(
                '学习建议',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: Colors.amber.shade700)),
                Expanded(child: Text(tip)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(SpeechDifficulty? difficulty, String label) {
    final isSelected = _selectedDifficulty == difficulty;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 12)),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedDifficulty = difficulty;
            _updateSpeeches();
          });
        }
      },
      selectedColor: Colors.purple.shade600,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey.shade700,
      ),
    );
  }

  Widget _buildGenderChip(String? gender, String label) {
    final isSelected = _selectedGender == gender;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 12)),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedGender = gender;
            _updateSpeeches();
          });
        }
      },
      selectedColor: Colors.blue.shade600,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey.shade700,
      ),
    );
  }

  void _toggleFavorite(String speechId) async {
    if (_service.isFavorited(speechId)) {
      await _service.unfavoriteSpeech(speechId);
    } else {
      await _service.favoriteSpeech(speechId);
    }
    await _updateFavorites();
    setState(() {});
  }

  void _showFavorites() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('我的收藏'),
        content: _favoriteSpeeches.isEmpty
            ? const Center(child: Text('还没有收藏任何演讲'))
            : SizedBox(
                width: 500,
                height: 400,
                child: ListView.builder(
                  itemCount: _favoriteSpeeches.length,
                  itemBuilder: (context, index) {
                    final speech = _favoriteSpeeches[index];
                    return ListTile(
                      title: Text(speech.title),
                      subtitle: Text(speech.speaker.name),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _selectedSpeech = speech;
                        });
                      },
                    );
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showStatistics() async {
    final stats = await _service.getStatistics();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('学习统计'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatItem('听过的演讲', '${stats.totalSpeechesListened}'),
            _buildStatItem('总听力时长', '${stats.totalListeningMinutes} 分钟'),
            _buildStatItem('完成的片段', '${stats.totalSegmentsCompleted}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade700,
            ),
          ),
        ],
      ),
    );
  }

  void _showRecommended() async {
    final recommended = await _service.getRecommendedSpeeches();

    if (!mounted) return;

    setState(() {
      _filteredSpeeches = recommended;
    });
  }

  String _getDifficultyName(SpeechDifficulty difficulty) {
    return switch (difficulty) {
      SpeechDifficulty.beginner => '初级',
      SpeechDifficulty.intermediate => '中级',
      SpeechDifficulty.advanced => '高级',
      SpeechDifficulty.expert => '专家',
    };
  }

  Color _getDifficultyColor(SpeechDifficulty difficulty) {
    return switch (difficulty) {
      SpeechDifficulty.beginner => Colors.green.shade100,
      SpeechDifficulty.intermediate => Colors.blue.shade100,
      SpeechDifficulty.advanced => Colors.orange.shade100,
      SpeechDifficulty.expert => Colors.red.shade100,
    };
  }

  String _getTopicName(SpeechTopic topic) {
    return switch (topic) {
      SpeechTopic.leadership => '领导力',
      SpeechTopic.technology => '科技',
      SpeechTopic.science => '科学',
      SpeechTopic.environment => '环境',
      SpeechTopic.education => '教育',
      SpeechTopic.society => '社会',
      SpeechTopic.politics => '政治',
      SpeechTopic.economy => '经济',
      SpeechTopic.culture => '文化',
      SpeechTopic.history => '历史',
      SpeechTopic.innovation => '创新',
      SpeechTopic.philosophy => '哲学',
    };
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
