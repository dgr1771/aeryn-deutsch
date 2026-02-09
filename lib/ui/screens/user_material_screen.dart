/// 用户材料管理页面
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';
import '../../models/user_material.dart';
import '../../services/user_material_service.dart';

class UserMaterialScreen extends StatefulWidget {
  const UserMaterialScreen({super.key});

  @override
  State<UserMaterialScreen> createState() => _UserMaterialScreenState();
}

class _UserMaterialScreenState extends State<UserMaterialScreen> {
  final UserMaterialService _service = UserMaterialService();

  List<MaterialFolder> _folders = [];
  List<UserMaterial> _materials = [];
  List<MaterialTag> _tags = [];
  String? _selectedFolderId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _service.initialize();
    await _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _folders = _service.getAllFolders();
      _materials = _service.getAllMaterials();
      _tags = _service.getAllTags();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的知识库'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearch,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Row(
        children: [
          // 左侧：文件夹导航
          SizedBox(
            width: 250,
            child: _buildFolderSidebar(),
          ),
          // 右侧：材料列表
          Expanded(
            child: _buildMaterialList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMenu,
        icon: const Icon(Icons.add),
        label: const Text('添加'),
        backgroundColor: Colors.green.shade600,
      ),
    );
  }

  Widget _buildFolderSidebar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        children: [
          // 统计信息
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Column(
              children: [
                _buildStatItem('材料', _materials.length),
                const SizedBox(height: 8),
                _buildStatItem('文件夹', _folders.length),
                const SizedBox(height: 8),
                _buildStatItem('标签', _tags.length),
              ],
            ),
          ),
          // 文件夹列表
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // 全部材料
                ListTile(
                  leading: Icon(
                    Icons.folder_open,
                    color: _selectedFolderId == null ? Colors.blue : Colors.grey,
                  ),
                  title: const Text('全部材料'),
                  selected: _selectedFolderId == null,
                  selectedTileColor: Colors.blue.shade50,
                  onTap: () {
                    setState(() {
                      _selectedFolderId = null;
                    });
                  },
                ),
                const Divider(),
                // 自定义文件夹
                ...(_folders.map((folder) {
                  final isSelected = _selectedFolderId == folder.id;
                  return ListTile(
                    leading: Icon(
                      Icons.folder,
                      color: isSelected ? Colors.blue : Colors.grey.shade700,
                    ),
                    title: Text(folder.name),
                    trailing: Text(
                      _service.getMaterialsInFolder(folder.id).length.toString(),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: Colors.blue.shade50,
                    onTap: () {
                      setState(() {
                        _selectedFolderId = folder.id;
                      });
                    },
                  );
                }).toList()),
              ],
            ),
          ),
          // 创建文件夹按钮
          ListTile(
            leading: const Icon(Icons.create_new_folder),
            title: const Text('新建文件夹'),
            onTap: _showCreateFolderDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade700)),
        Text(
          value.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialList() {
    final filteredMaterials = _selectedFolderId == null
        ? _materials.where((m) => m.folderId == null).toList()
        : _materials.where((m) => m.folderId == _selectedFolderId).toList();

    if (filteredMaterials.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              '还没有材料',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '点击下方"+"号添加',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: filteredMaterials.length,
      itemBuilder: (context, index) {
        final material = filteredMaterials[index];
        return _buildMaterialCard(material);
      },
    );
  }

  Widget _buildMaterialCard(UserMaterial material) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _openMaterial(material),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getMaterialIcon(material.type),
                    color: Colors.blue.shade600,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          material.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey.shade800,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (material.description != null)
                          Text(
                            material.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  if (material.vocabulary != null)
                    Chip(
                      label: '${material.vocabulary!.length} 词',
                      backgroundColor: Colors.blue.shade50,
                      labelStyle: TextStyle(fontSize: 11),
                    ),
                  if (material.tags != null && material.tags!.isNotEmpty)
                    Chip(
                      label: '${material.tags!.length} 标签',
                      backgroundColor: Colors.green.shade50,
                      labelStyle: TextStyle(fontSize: 11),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _formatDate(material.createdAt),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getMaterialIcon(UserMaterialType type) {
    return switch (type) {
      UserMaterialType.vocabulary => Icons.menu_book,
      UserMaterialType.grammarNote => Icons.description,
      UserMaterialType.reading => Icons.article,
      UserMaterialType.audio => Icons.headphones,
      UserMaterialType.video => Icons.play_circle,
      UserMaterialType.flashcard => Icons.style,
      UserMaterialType.exercise => Icons.assignment,
      UserMaterialType.other => Icons.insert_drive_file,
    };
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} 分钟前';
      }
      return '${difference.inHours} 小时前';
    } else if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} 天前';
    } else {
      return '${date.month}/${date.day}';
    }
  }

  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('导入词汇 (CSV)'),
              onTap: () {
                Navigator.pop(context);
                _importVocabularyCSV();
              },
            ),
            ListTile(
              leading: const Icon(Icons.note_add),
              title: const Text('创建语法笔记'),
              onTap: () {
                Navigator.pop(context);
                _showCreateGrammarNote();
              },
            ),
            ListTile(
              leading: const Icon(Icons.style),
              title: const Text('创建抽认卡'),
              onTap: () {
                Navigator.pop(context);
                _showCreateFlashcard();
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('添加单词'),
              onTap: () {
                Navigator.pop(context);
                _showAddSingleWord();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _importVocabularyCSV() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        // 显示对话框选择文件夹
        if (!mounted) return;

        String? selectedFolderId = _selectedFolderId;

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('导入词汇'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('文件: ${file.name}'),
                const SizedBox(height: 16),
                const Text('选择目标文件夹:'),
                const SizedBox(height: 8),
                DropdownButton<String?>(
                  hint: const Text('选择文件夹'),
                  value: selectedFolderId,
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('根目录'),
                    ),
                    ...(_folders.map((folder) => DropdownMenuItem(
                      value: folder.id,
                      child: Text(folder.name),
                    ))),
                  ],
                  onChanged: (value) {
                    selectedFolderId = value;
                    // TODO: 更新UI状态
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);

                  try {
                    await _service.importVocabularyFromCSV(
                      filePath: file.path!,
                      folderId: selectedFolderId,
                    );

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('词汇导入成功'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      await _refreshData();
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('导入失败: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text('导入'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('选择文件失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showCreateGrammarNote() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final categoryController = TextEditingController();
    final levelController = TextEditingController();
    String? selectedLevel;
    List<String> tags = [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('创建语法笔记'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: '标题',
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: '内容 (支持Markdown)',
                  prefixIcon: Icon(Icons.notes),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: '分类 (可选)',
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: '难度等级',
                  prefixIcon: Icon(Icons.school),
                ),
                items: const [
                  DropdownMenuItem(value: 'A1', child: Text('A1')),
                  DropdownMenuItem(value: 'A2', child: Text('A2')),
                  DropdownMenuItem(value: 'B1', child: Text('B1')),
                  DropdownMenuItem(value: 'B2', child: Text('B2')),
                ],
                onChanged: (value) {
                  selectedLevel = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isEmpty ||
                  contentController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('请填写标题和内容'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              try {
                await _service.createGrammarNote(
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                  folderId: _selectedFolderId,
                  category: categoryController.text.trim().isEmpty
                      ? null
                      : categoryController.text.trim(),
                  level: selectedLevel,
                );

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('语法笔记创建成功'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  await _refreshData();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('创建失败: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }

  void _showCreateFlashcard() {
    final frontController = TextEditingController();
    final backController = TextEditingController();
    final hintController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('创建抽认卡'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: frontController,
              decoration: const InputDecoration(
                labelText: '正面 (问题)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: backController,
              decoration: const InputDecoration(
                labelText: '背面 (答案)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: hintController,
              decoration: const InputDecoration(
                labelText: '提示 (可选)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 实现抽认卡创建
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('抽认卡功能即将推出'),
                ),
              );
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }

  void _showAddSingleWord() {
    final wordController = TextEditingController();
    final articleController = TextEditingController();
    final meaningController = TextEditingController();
    final exampleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加单词'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: articleController,
                decoration: const InputDecoration(
                  labelText: '冠词 (der/die/das)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: wordController,
                decoration: const InputDecoration(
                  labelText: '单词 *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: meaningController,
                decoration: const InputDecoration(
                  labelText: '中文释义 *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: exampleController,
                decoration: const InputDecoration(
                  labelText: '例句 (可选)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (wordController.text.trim().isEmpty ||
                  meaningController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('请填写单词和释义'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              try {
                await _service.addVocabulary(
                  word: wordController.text.trim(),
                  article: articleController.text.trim().isEmpty
                      ? null
                      : articleController.text.trim(),
                  meaning: meaningController.text.trim(),
                  example: exampleController.text.trim().isEmpty
                      ? null
                      : exampleController.text.trim(),
                  folderId: _selectedFolderId,
                );

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('单词添加成功'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  await _refreshData();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('添加失败: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  void _showSearch() {
    final queryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('搜索材料'),
        content: TextField(
          controller: queryController,
          decoration: const InputDecoration(
            labelText: '搜索关键词',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (queryController.text.trim().isEmpty) return;

              Navigator.pop(context);

              final results = await _service.searchMaterials(
                query: queryController.text.trim(),
              );

              if (mounted) {
                _showSearchResults(queryController.text.trim(), results);
              }
            },
            child: const Text('搜索'),
          ),
        ],
      ),
    );
  }

  void _showSearchResults(String query, List<MaterialSearchResult> results) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('搜索结果: "$query"'),
        content: SizedBox(
          width: 500,
          height: 400,
          child: results.isEmpty
              ? const Center(child: Text('没有找到匹配的材料'))
              : ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final result = results[index];
                    return ListTile(
                      leading: Icon(
                        _getMaterialIcon(result.material.type),
                        color: Colors.blue.shade600,
                      ),
                      title: Text(result.material.title),
                      subtitle: result.matchedText != null
                          ? Text('匹配: ${result.matchedText}')
                          : null,
                      trailing: Text(
                        '${(result.relevance * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _openMaterial(result.material);
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

  void _showCreateFolderDialog() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新建文件夹'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: '文件夹名称',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('请输入文件夹名称'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              try {
                await _service.createFolder(
                  name: nameController.text.trim(),
                  parentId: _selectedFolderId,
                );

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('文件夹创建成功'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  await _refreshData();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('创建失败: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }

  void _openMaterial(UserMaterial material) {
    // 更新访问记录
    _service.updateAccess(material.id);

    // 根据材料类型打开不同的详情页面
    switch (material.type) {
      case UserMaterialType.vocabulary:
        _showVocabularyDetail(material);
        break;
      case UserMaterialType.grammarNote:
        _showGrammarNoteDetail(material);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('该功能即将推出'),
          ),
        );
    }
  }

  void _showVocabularyDetail(UserMaterial material) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(material.title),
        content: SizedBox(
          width: 500,
          height: 400,
          child: material.vocabulary != null && material.vocabulary!.isNotEmpty
              ? ListView.builder(
                  itemCount: material.vocabulary!.length,
                  itemBuilder: (context, index) {
                    final entry = material.vocabulary![index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (entry.article != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      entry.article!,
                                      style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                Text(
                                  entry.word,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              entry.meaning,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            if (entry.example != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                entry.example!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                )
              : const Center(child: Text('暂无词汇数据')),
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

  void _showGrammarNoteDetail(UserMaterial material) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(material.title),
        content: SizedBox(
          width: 600,
          height: 500,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                material.textContent ?? '',
                style: TextStyle(fontSize: 14, height: 1.6),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('编辑'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}
