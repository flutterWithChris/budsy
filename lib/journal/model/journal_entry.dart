import 'package:canjo/journal/model/feeling.dart';
import 'package:canjo/stash/model/product.dart';

enum EntryType {
  feeling,
  session,
}

class JournalEntry {
  final String? id;
  final DateTime? createdAt;
  final EntryType? type;
  final List<Product>? products;
  final List<Feeling>? feelings;
  final int? intensity;
  final String? notes;

  JournalEntry({
    this.id,
    this.createdAt,
    this.type,
    this.products,
    this.feelings,
    this.intensity,
    this.notes,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      type: EntryType.values.firstWhere(
        (element) => element.toString() == 'EntryType.${json['type']}',
      ),
      intensity: json['intensity'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson({required String userId}) {
    return {
      'type': type.toString().split('.').last,
      'intensity': intensity,
      'user_id': userId,
      'notes': notes,
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
    String? notes,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      products: products ?? this.products,
      feelings: feelings ?? this.feelings,
      intensity: intensity ?? this.intensity,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'JournalEntry{id: $id, createdAt: $createdAt, type: $type, products: $products, feelings: $feelings, intensity: $intensity, notes: $notes}';
  }
}
