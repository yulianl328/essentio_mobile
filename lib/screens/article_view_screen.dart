import 'package:flutter/material.dart';

import '../models/article.dart';

class ArticleViewScreen extends StatefulWidget {
  final Article article;

  const ArticleViewScreen({super.key, required this.article});

  @override
  State<ArticleViewScreen> createState() => _ArticleViewScreenState();
}

class _ArticleViewScreenState extends State<ArticleViewScreen> {
  late Article _currentArticle;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentArticle = widget.article;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final String year = date.year.toString();
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '$day.$month.$year';
  }

  String _formatCommentDate(DateTime date) {
    final String year = date.year.toString();
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    final String hours = date.hour.toString().padLeft(2, '0');
    final String minutes = date.minute.toString().padLeft(2, '0');
    return '$day.$month.$year $hours:$minutes';
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final newComment = Comment(
      'Користувач',
      text,
      DateTime.now(),
    );

    setState(() {
      final updatedComments = List<Comment>.from(_currentArticle.comments)
        ..add(newComment);

      _currentArticle = Article(
        id: _currentArticle.id,
        title: _currentArticle.title,
        content: _currentArticle.content,
        created: _currentArticle.created,
        comments: updatedComments,
      );
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final article = _currentArticle;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Стаття'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Заголовок + дата
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _formatDate(article.created),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Основний контент + коментарі в Scroll
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.content,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Коментарі',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (article.comments.isEmpty)
                      const Text(
                        'Поки що немає коментарів. Будьте першим!',
                        style: TextStyle(fontSize: 13),
                      )
                    else
                      Column(
                        children: article.comments
                            .map(
                              (c) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  c.user,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(c.text),
                                trailing: Text(
                                  _formatCommentDate(c.date),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text(
                      'Додати коментар',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: const InputDecoration(
                              hintText: 'Напишіть свій коментар...',
                              border: OutlineInputBorder(),
                            ),
                            // НІЯКИХ обмежень → кирилиця працює
                            maxLines: null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _addComment,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
