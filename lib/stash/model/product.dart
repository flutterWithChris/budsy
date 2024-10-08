import 'package:animated_custom_dropdown/custom_dropdown.dart';

import 'package:canjo/stash/model/cannabinoid.dart';
import 'package:canjo/stash/model/terpene.dart';

import 'package:list_ext/list_ext.dart';

enum ProductCategory { flower, concentrate, edible, topical, cartridge, other }

enum FlowerType { sativa, indica, hybrid }

enum FlowerUnit { gram, eighth, quarter, half, ounce, per }

class Product with CustomDropdownListFilter {
  final String? id;
  final String? name;
  final List<String>? images;
  final String? description;
  final ProductCategory? category;
  final FlowerType? type;
  final double? price;
  final double? weight;
  final FlowerUnit? unit;
  final String? dispensary;
  final String? brand;
  final List<Cannabinoid>? cannabinoids;
  final List<Terpene>? terpenes;
  final int? rating;
  final bool? archived;
  final DateTime? createdAt;

  Product(
      {this.id,
      this.name,
      this.images,
      this.description,
      this.category,
      this.type,
      this.price,
      this.weight,
      this.unit,
      this.dispensary,
      this.brand,
      this.cannabinoids,
      this.terpenes,
      this.rating,
      this.archived,
      this.createdAt});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      // images: json['images'] != null ? List<String>.from(json['images']) : null,
      description: json['description'],
      category: json['category'] != null
          ? ProductCategory.values.firstWhere(
              (e) => e.toString() == 'ProductCategory.${json['category']}')
          : null,
      type: json['type'] != null
          ? FlowerType.values
              .firstWhere((e) => e.toString() == 'FlowerType.${json['type']}')
          : null,
      price: json['price'],
      unit: json['unit'] != null
          ? FlowerUnit.values.firstWhereOrNull(
              (e) => e.toString() == 'FlowerUnit.${json['unit']}')
          : null,
      dispensary: json['dispensary'],
      brand: json['brand'],

      rating: json['rating'],
      archived: json['archived'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'name': name,
      // 'images': images,
      'description': description,
      'category': category?.toString().split('.').last,
      'type': type?.toString().split('.').last,
      'price': price,
      // 'weight': weight,
      'unit': unit?.toString().split('.').last,
      'dispensary': dispensary,
      'brand': brand,
      // 'cannabinoids': cannabinoids,
      // 'terpenes': terpenes,
      'rating': rating,
      'archived': archived,
    };
  }

  // copyWith method
  Product copyWith({
    String? id,
    String? name,
    List<String>? images,
    String? description,
    ProductCategory? category,
    FlowerType? type,
    double? price,
    double? weight,
    FlowerUnit? unit,
    String? dispensary,
    String? brand,
    List<Cannabinoid>? cannabinoids,
    List<Terpene>? terpenes,
    int? rating,
    bool? archived,
  }) {
    return Product(
        id: id ?? this.id,
        name: name ?? this.name,
        images: images ?? this.images,
        description: description ?? this.description,
        category: category ?? this.category,
        type: type ?? this.type,
        price: price ?? this.price,
        weight: weight ?? this.weight,
        unit: unit ?? this.unit,
        dispensary: dispensary ?? this.dispensary,
        brand: brand ?? this.brand,
        cannabinoids: cannabinoids ?? this.cannabinoids,
        terpenes: terpenes ?? this.terpenes,
        rating: rating ?? this.rating,
        archived: archived ?? this.archived);
  }

  // toString
  @override
  String toString() {
    return 'Product{id: $id, name: $name, images: $images, description: $description, category: $category, type: $type, price: $price, weight: $weight, unit: $unit, dispensary: $dispensary, brand: $brand, cannabinoids: $cannabinoids, terpenes: $terpenes, rating: $rating, archived: $archived}';
  }

  @override
  bool filter(String query) {
    return name!.toLowerCase().contains(query.toLowerCase());
  }
}
