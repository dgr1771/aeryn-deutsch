/// 搜索页面
library;

import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../services/search_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchService _searchService = SearchService.instance;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<SearchResult> _results = [];
  List<String> _suggestions = [];
  List<String> _recentSearches = [];
  bool _isSearching = false;
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadRecentSearches() async {
    final recent = await _searchService.getRecentSearches();
    setState(() {
      _recentSearches = recent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _results = [];
                  _suggestions = [];
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // 类型过滤
          if (_selectedType != null || _results.isNotEmpty)
            _buildFilterBar(),

          // 搜索内容
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        autofocus: true,
        decoration: InputDecoration(
          hintText: '搜询单词、语法、阅读...',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            _performSearch(value);
          }
        },
        onChanged: (value) {
          if (value.isEmpty) {
            setState(() {
              _results = [];
              _suggestions = [];
            });
          } else {
            _loadSuggestions(value);
          }
        },
      ),
    );
  }

  Widget _buildFilterBar() {
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
            _buildFilterChip('全部', null),
            const SizedBox(width: 8),
            _buildFilterChip('词汇', SearchResultType.vocabulary),
            const SizedBox(width: 8),
            _buildFilterChip('语法', SearchResultType.grammar),
            const SizedBox(width: 8),
            _buildFilterChip('阅读', SearchResultType.reading),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, SearchResultType? type) {
    final isSelected = _selectedType == type;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedType = selected ? type : null;
        });
        if (_searchController.text.isNotEmpty) {
          _performSearch(_searchController.text);
        }
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

  Widget _buildContent() {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_searchController.text.isEmpty) {
      return _buildInitialContent();
    }

    if (_results.isEmpty) {
      return _buildEmptyContent();
    }

    return _buildResults();
  }

  Widget _buildInitialContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '最近搜索',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await _searchService.clearSearchHistory();
                    setState(() {
                      _recentSearches = [];
                    });
                  },
                  child: const Text('清除'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches.map((query) {
                return _buildSuggestionChip(query);
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
          Text(
            '热门搜索',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _searchService.getPopularSearches().map((query) {
              return _buildSuggestionChip(query);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String query) {
    return ActionChip(
      label: Text(query),
      onPressed: () {
        _searchController.text = query;
        _performSearch(query);
      },
      backgroundColor: Colors.grey.shade100,
      labelStyle: TextStyle(
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget _buildEmptyContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            '未找到相关内容',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '试试其他关键词',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final result = _results[index];
        return _buildResultItem(result);
      },
    );
  }

  Widget _buildResultItem(SearchResult result) {
    return InkWell(
      onTap: () => _openResult(result),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 类型图标
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getTypeColor(result.type).shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getTypeIcon(result.type),
                color: _getTypeColor(result.type),
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
                    result.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  if (result.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      result.subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    result.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // 相关度指示器
            if (result.relevance >= 0.9)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '精确',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(SearchResultType type) {
    return switch (type) {
      SearchResultType.vocabulary => Colors.orange,
      SearchResultType.grammar => Colors.purple,
      SearchResultType.reading => Colors.blue,
    };
  }

  IconData _getTypeIcon(SearchResultType type) {
    return switch (type) {
      SearchResultType.vocabulary => Icons.text_fields,
      SearchResultType.grammar => Icons.library_books,
      SearchResultType.reading => Icons.menu_book,
    };
  }

  Future<void> _loadSuggestions(String query) async {
    final suggestions = await _searchService.getSuggestions(query);
    setState(() {
      _suggestions = suggestions;
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isSearching = true;
    });

    try {
      final filter = SearchFilter(
        types: _selectedType != null ? [_selectedType!] : null,
      );

      final results = await _searchService.search(query, filter: filter);

      // 保存搜索历史
      await _searchService.saveSearchHistory(query);

      setState(() {
        _results = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('搜索失败：$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _openResult(SearchResult result) {
    switch (result.type) {
      case SearchResultType.vocabulary:
        // 打开词汇详情
        Navigator.pushNamed(context, '/vocabulary/detail',
            arguments: result.data);
        break;
      case SearchResultType.grammar:
        // 打开语法详情
        Navigator.pushNamed(context, '/grammar/detail',
            arguments: result.data);
        break;
      case SearchResultType.reading:
        // 打开阅读材料
        Navigator.pushNamed(context, '/reading/detail',
            arguments: result.data);
        break;
    }
  }
}
