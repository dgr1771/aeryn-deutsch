/// 收藏和笔记页面
library;

import 'package:flutter/material.dart';
import '../../models/user_bookmark.dart';
import '../../services/bookmark_service.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final BookmarkService _bookmarkService = BookmarkService.instance;

  List<Bookmark> _bookmarks = [];
  List<Note> _allNotes = [];
  List<String> _tags = [];
  BookmarkType? _selectedType;
  String? _selectedTag;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _bookmarkService.initialize();
      const userId = 'current_user'; // TODO: 从认证系统获取

      final bookmarks = _bookmarkService.getUserBookmarks(userId);
      final notes = bookmarks.expand((b) => b.notes ?? []).toList();
      final tags = _bookmarkService.getAllTags();

      setState(() {
        _bookmarks = bookmarks;
        _allNotes = notes;
        _tags = tags;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('加载失败：$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('我的收藏'),
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(text: '收藏'),
              Tab(text: '笔记'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildBookmarksTab(),
                  _buildNotesTab(),
                ],
              ),
      ),
    );
  }

  Widget _buildBookmarksTab() {
    final filteredBookmarks = _selectedType == null
        ? _bookmarks
        : _bookmarks.where((b) => b.type == _selectedType).toList();

    return Column(
      children: [
        // 类型过滤
        _buildTypeFilter(),

        // 收藏列表
        Expanded(
          child: filteredBookmarks.isEmpty
              ? _buildEmptyContent('还没有收藏，快去添加吧！')
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredBookmarks.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final bookmark = filteredBookmarks[index];
                    return _buildBookmarkItem(bookmark);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildNotesTab() {
    final filteredNotes = _selectedTag == null
        ? _allNotes
        : _allNotes.where((n) => n.tags?.contains(_selectedTag) ?? false).toList();

    return Column(
      children: [
        // 标签过滤
        if (_tags.isNotEmpty) _buildTagFilter(),

        // 笔记列表
        Expanded(
          child: filteredNotes.isEmpty
              ? _buildEmptyContent('还没有笔记，快去添加吧！')
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredNotes.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final note = filteredNotes[index];
                    return _buildNoteItem(note);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTypeFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTypeChip('全部', null),
            const SizedBox(width: 8),
            _buildTypeChip('词汇', BookmarkType.vocabulary),
            const SizedBox(width: 8),
            _buildTypeChip('语法', BookmarkType.grammar),
            const SizedBox(width: 8),
            _buildTypeChip('阅读', BookmarkType.reading),
            const SizedBox(width: 8),
            _buildTypeChip('题目', BookmarkType.question),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, BookmarkType? type) {
    final isSelected = _selectedType == type;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedType = selected ? type : null;
        });
      },
      selectedColor: Colors.blue.shade600,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey.shade700,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }

  Widget _buildTagFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTagChip('全部', null),
            const SizedBox(width: 8),
            ..._tags.take(5).map((tag) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildTagChip(tag, tag),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(String label, String? tag) {
    final isSelected = _selectedTag == tag;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedTag = selected ? tag : null;
        });
      },
      selectedColor: Colors.blue.shade600,
      checkmarkColor: Colors.white,
      avatar: isSelected ? null : Icon(Icons.label, size: 16),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey.shade700,
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }

  Widget _buildBookmarkItem(Bookmark bookmark) {
    return InkWell(
      onTap: () => _openBookmark(bookmark),
      onLongPress: () => _showBookmarkOptions(bookmark),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 类型图标
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getTypeColor(bookmark.type).shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getTypeIcon(bookmark.type),
                color: _getTypeColor(bookmark.type),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            // 内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookmark.title ?? '无标题',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bookmark.description ?? '无描述',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(bookmark.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (bookmark.notes != null && bookmark.notes!.isNotEmpty)
                        Icon(Icons.note, size: 12, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      if (bookmark.notes != null && bookmark.notes!.isNotEmpty)
                        Text(
                          '${bookmark.notes!.length} 笔记',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // 删除按钮
            IconButton(
              icon: Icon(Icons.bookmark, color: Colors.orange.shade600),
              onPressed: () => _removeBookmark(bookmark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteItem(Note note) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.yellow.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.yellow.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 笔记内容
          Text(
            note.content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),

          // 高亮文本
          if (note.highlight != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.format_quote, color: Colors.orange.shade600, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      note.highlight!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange.shade800,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 标签
          if (note.tags != null && note.tags!.isNotEmpty)
            Wrap(
              spacing: 8,
              children: note.tags!.take(3).map((tag) {
                return Chip(
                  label: Text(
                    tag,
                    style: TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.blue.shade50,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                );
              }).toList(),
            ),

          const SizedBox(height: 8),

          // 时间
          Row(
            children: [
              Icon(Icons.access_time, size: 12, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text(
                _formatDate(note.updatedAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyContent(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(BookmarkType type) {
    return switch (type) {
      BookmarkType.vocabulary => Colors.orange,
      BookmarkType.grammar => Colors.purple,
      BookmarkType.reading => Colors.blue,
      BookmarkType.question => Colors.green,
    };
  }

  IconData _getTypeIcon(BookmarkType type) {
    return switch (type) {
      BookmarkType.vocabulary => Icons.text_fields,
      BookmarkType.grammar => Icons.library_books,
      BookmarkType.reading => Icons.menu_book,
      BookmarkType.question => Icons.help,
    };
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}分钟前';
      }
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }

  void _openBookmark(Bookmark bookmark) {
    // TODO: 打开对应项的详情页
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('打开 ${bookmark.title}'),
      ),
    );
  }

  void _showBookmarkOptions(Bookmark bookmark) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.note_add),
                title: const Text('添加笔记'),
                onTap: () {
                  Navigator.pop(context);
                  _addNote(bookmark);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: const Text('删除收藏'),
                onTap: () {
                  Navigator.pop(context);
                  _removeBookmark(bookmark);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addNote(Bookmark bookmark) async {
    final controller = TextEditingController();
    final tagsController = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加笔记'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: '笔记内容',
                hintText: '输入笔记...',
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: tagsController,
              decoration: const InputDecoration(
                labelText: '标签（可选，用逗号分隔）',
                hintText: '例: 重要, 复习',
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
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );

    if (result != null) {
      try {
        final tags = tagsController.text
            .split(',')
            .map((t) => t.trim())
            .where((t) => t.isNotEmpty)
            .toList();

        await _bookmarkService.addNote(
          bookmarkId: bookmark.id,
          content: result,
          tags: tags.isNotEmpty ? tags : null,
        );

        await _loadData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('笔记已添加'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('添加失败：$e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _removeBookmark(Bookmark bookmark) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除"${bookmark.title}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _bookmarkService.removeBookmark(bookmark.id);
        await _loadData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('已删除'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('删除失败：$e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
