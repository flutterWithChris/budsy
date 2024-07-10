import 'package:budsy/entries/model/product.dart';
import 'package:googleapis/bigquery/v2.dart';

enum Feeling {
  happy,
  creative,
  sleepy,
  anxious,
  hungry,
  energetic,
  focus,
  social,
  calm,
}

enum EntryType {
  feeling,
  session,
}

class JournalEntry {
  final String id;
  final DateTime createdAt;
  final EntryType type;
  final List<Product>? products;
  final List<Feeling>? feelings;
  final int? intensity;

  JournalEntry({
    required this.id,
    required this.createdAt,
    required this.type,
    this.products,
    this.feelings,
    this.intensity,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      type: EntryType.values.firstWhere(
        (element) => element.toString() == 'EntryType.${json['type']}',
      ),
      products: json['products'] != null
          ? (json['products'] as List<dynamic>)
              .map((product) => Product.fromJson(product))
              .toList()
          : null,
      feelings: (json['feelings'] as List<dynamic>)
          .map((feeling) => Feeling.values.firstWhere(
                (element) => element.toString() == 'Feeling.$feeling',
              ))
          .toList(),
      intensity: json['intensity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'type': type.toString().split('.').last,
      'products': products?.map((product) => product.toJson()).toList(),
      'feelings': feelings
          ?.map((feeling) => feeling.toString().split('.').last)
          .toList(),
      'intensity': intensity,
    };
  }

  @override
  String toString() {
    return 'JournalEntry{id: $id, createdAt: $createdAt, type: $type, products: $products, feelings: $feelings, intensity: $intensity}';
  }
}
