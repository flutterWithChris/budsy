import 'package:budsy/entries/model/product.dart';

enum Feeling {
  happy,
  creative,
  relaxed,
  sleepy,
  anxious,
  hungry,
  energetic,
  focus,
  social,
  calm,
}

class JournalEntry {
  final String id;
  final DateTime createdAt;
  final Product product;
  final Feeling feeling;

  JournalEntry({
    required this.id,
    required this.createdAt,
    required this.product,
    required this.feeling,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      product: Product.fromJson(json['product']),
      feeling: Feeling.values
          .firstWhere((element) => element.toString() == json['feeling']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'product': product.toJson(),
      'feeling': feeling.toString(),
    };
  }

  @override
  String toString() {
    return 'JournalEntry{id: $id, createdAt: $createdAt, product: $product, feeling: $feeling}';
  }
}
