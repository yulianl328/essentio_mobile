import 'package:flutter/material.dart';
import '../models/article.dart';

class ArticleEditorScreen extends StatefulWidget {
  final Article? article;

  const ArticleEditorScreen({super.key, this.article});

  @override
  State<ArticleEditorScreen> createState() => _ArticleEditorScreenState();
}

class _ArticleEditorScreenState extends State<ArticleEditorScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.article != null) {
      titleController.text = widget.article!.title;
      contentController.text = widget.article!.content;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _save() {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заповніть заголовок і контент')),
      );
      return;
    }

    final Article article = Article(
      id: widget.article?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      content: content,
      created: widget.article?.created ?? DateTime.now(),
      comments: widget.article?.comments ?? [],
    );

    Navigator.pop(context, article);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.article != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Редагувати статтю' : 'Нова стаття'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Заголовок',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Контент',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
