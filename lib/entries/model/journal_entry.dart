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
  final Product product;
  final List<Feeling> feelings;

  JournalEntry({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.product,
    required this.feelings,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      type: EntryType.values.firstWhere(
        (element) => element.toString() == 'EntryType.${json['type']}',
      ),
      product: Product.fromJson(json['product']),
      feelings: (json['feelings'] as List<dynamic>)
          .map((feeling) => Feeling.values.firstWhere(
                (element) => element.toString() == 'Feeling.$feeling',
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'type': type.toString().split('.').last,
      'product': product.toJson(),
      'feelings': feelings
          .map((feeling) => feeling.toString().split('.').last)
          .toList(),
    };
  }

  @override
  String toString() {
    return 'JournalEntry{id: $id, createdAt: $createdAt, type: $type, product: $product, feelings: $feelings}';
  }
}
