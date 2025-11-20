import 'dart:convert';

class AddOnProduct {
  final String id;
  final String name;
  final String description;
  final int price; // stored in грн
  final bool recommended;

  const AddOnProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.recommended = false,
  });

  factory AddOnProduct.fromJson(Map<String, dynamic> json) {
    return AddOnProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      recommended: (json['recommended'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'recommended': recommended,
    };
  }

  /// Convenience for serializing to a JSON string.
  String toJsonString() => jsonEncode(toJson());
}
