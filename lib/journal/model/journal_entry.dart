import 'package:budsy/journal/model/feeling.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:googleapis/bigquery/v2.dart';

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
      createdAt: DateTime.parse(json['created_at']),
      type: EntryType.values.firstWhere(
        (element) => element.toString() == 'EntryType.${json['type']}',
      ),
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

  // copyWith method
  JournalEntry copyWith({
    String? id,
    DateTime? createdAt,
    EntryType? type,
    List<Product>? products,
    List<Feeling>? feelings,
    int? intensity,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      products: products ?? this.products,
      feelings: feelings ?? this.feelings,
      intensity: intensity ?? this.intensity,
    );
  }

  @override
  String toString() {
    return 'JournalEntry{id: $id, createdAt: $createdAt, type: $type, products: $products, feelings: $feelings, intensity: $intensity}';
  }
}
