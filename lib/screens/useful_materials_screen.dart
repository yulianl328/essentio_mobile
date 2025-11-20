import 'package:flutter/material.dart';

import '../models/article.dart';
import '../screens/article_editor_screen.dart';
import '../screens/article_view_screen.dart';

class UsefulMaterialsScreen extends StatefulWidget {
  const UsefulMaterialsScreen({super.key});

  @override
  State<UsefulMaterialsScreen> createState() => _UsefulMaterialsScreenState();
}

class _UsefulMaterialsScreenState extends State<UsefulMaterialsScreen> {
  final List<Article> _articles = [
    Article(
      id: 'energy_set',
      title: 'Енергія: як будувати чайний ритуал',
      content:
          'Почніть з легкого зеленого чи улуну з мʼякою стимуляцією.\n'
          'Додавайте більш насичені чаї (приклад — Да Хун Пао) ближче до обіду.\n'
          'Уникайте важких вечірніх стимуляторів, якщо чутливі до кофеїну.',
      created: DateTime.now().subtract(const Duration(hours: 3)),
      comments: [
        Comment(
          'Марко',
          'Пʼю матчу зранку, але хочу перейти на щось мʼякше. Ця схема виглядає ок 👍',
          DateTime.now().subtract(const Duration(hours: 5)),
        ),
      ],
    ),
    Article(
      id: 'relax_set',
      title: 'Релакс: вечірній чай без перевантаження',
      content:
          'Шу пуер, мʼякі улуни та білі чаї — чудова база для вечірнього ритуалу.\n'
          'Слідкуйте за кількістю заварювань, щоб не перегнати себе кофеїном.\n'
          'Слухайте тіло — якщо є напруга, спробуйте щось тепле, землисте й заспокійливе.',
      created: DateTime.now().subtract(const Duration(days: 1)),
      comments: [],
    ),
  ];

  String _formatDate(DateTime date) {
    final String year = date.year.toString();
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '$day.$month.$year';
  }

  Future<void> _createArticle() async {
    final Article? result = await Navigator.push<Article?>(
      context,
      MaterialPageRoute(
        builder: (_) => const ArticleEditorScreen(),
      ),
    );
    if (result != null) {
      setState(() => _articles.insert(0, result));
    }
  }

  Future<void> _editArticle(Article article) async {
    final Article? result = await Navigator.push<Article?>(
      context,
      MaterialPageRoute(
        builder: (_) => ArticleEditorScreen(article: article),
      ),
    );
    if (result != null) {
      setState(() {
        final index = _articles.indexWhere((a) => a.id == result.id);
        if (index != -1) {
          _articles[index] = result;
        }
      });
    }
  }

  void _deleteArticle(Article article) {
    setState(() {
      _articles.removeWhere((a) => a.id == article.id);
    });
  }

  Future<void> _openArticle(Article article) async {
    final updated = await Navigator.push<Article?>(
      context,
      MaterialPageRoute(
        builder: (_) => ArticleViewScreen(article: article),
      ),
    );

    if (updated != null) {
      setState(() {
        final index = _articles.indexWhere((a) => a.id == updated.id);
        if (index != -1) {
          _articles[index] = updated;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корисні матеріали'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createArticle,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          final article = _articles[index];
          return _ArticleCard(
            article: article,
            dateText: _formatDate(article.created),
            onTap: () => _openArticle(article),
            onEdit: () => _editArticle(article),
            onDelete: () => _deleteArticle(article),
          );
        },
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final Article article;
  final String dateText;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ArticleCard({
    required this.article,
    required this.dateText,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final String preview = article.content.length > 140
        ? '${article.content.substring(0, 140)}...'
        : article.content;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      preview,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dateText,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Редагувати'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Видалити'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
