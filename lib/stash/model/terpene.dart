import 'package:flutter/material.dart';

class Terpene {
  final String? id;
  final String? name;
  final String? icon;
  final Color? color;
  final String? description;
  final String? effects;
  final String? medical;
  final String? flavor;
  final String? aroma;
  final String? image;
  final double? amount;

  Terpene({
    this.id,
    this.name,
    this.icon,
    this.color,
    this.description,
    this.effects,
    this.medical,
    this.flavor,
    this.aroma,
    this.image,
    this.amount,
  });

  factory Terpene.fromJson(Map<String, dynamic> json) {
    return Terpene(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      color: json['color'],
      description: json['description'],
      effects: json['effects'],
      medical: json['medical'],
      flavor: json['flavor'],
      aroma: json['aroma'],
      image: json['image'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'description': description,
      'effects': effects,
      'medical': medical,
      'flavor': flavor,
      'aroma': aroma,
      'image': image,
      'amount': amount,
    };
  }

  Terpene copyWith({
    String? id,
    String? name,
    String? icon,
    Color? color,
    String? description,
    String? effects,
    String? medical,
    String? flavor,
    String? aroma,
    String? image,
    double? amount,
  }) {
    return Terpene(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      description: description ?? this.description,
      effects: effects ?? this.effects,
      medical: medical ?? this.medical,
      flavor: flavor ?? this.flavor,
      aroma: aroma ?? this.aroma,
      image: image ?? this.image,
      amount: amount ?? this.amount,
    );
  }

  @override
  String toString() {
    return 'Terpene{id: $id, name: $name, icon: $icon, color: $color, description: $description, effects: $effects, medical: $medical, flavor: $flavor, aroma: $aroma, image: $image, amount: $amount}';
  }
}
