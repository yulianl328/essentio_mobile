class Comment {
  final String user;
  final String text;
  final DateTime date;

  Comment(this.user, this.text, this.date);

  Map<String, dynamic> toJson() => {
        'user': user,
        'text': text,
        'date': date.toIso8601String(),
      };

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        json['user'] as String,
        json['text'] as String,
        DateTime.parse(json['date'] as String),
      );
}

class Article {
  final String id;
  final String title;
  final String content;
  final DateTime created;
  final List<Comment> comments;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.created,
    this.comments = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'created': created.toIso8601String(),
        'comments': comments.map((c) => c.toJson()).toList(),
      };

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json['id'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
        created: DateTime.parse(json['created'] as String),
        comments: (json['comments'] as List<dynamic>? ?? [])
            .map((c) => Comment.fromJson(c as Map<String, dynamic>))
            .toList(),
      );
}
