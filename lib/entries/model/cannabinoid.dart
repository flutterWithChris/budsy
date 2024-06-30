import 'package:flutter/material.dart';

class Cannabinoid {
  final String? id;
  final String? name;
  final String? icon;
  final double? amount;
  final Color? color;

  Cannabinoid({
    this.id,
    this.name,
    this.icon,
    this.amount,
    this.color,
  });

  factory Cannabinoid.fromJson(Map<String, dynamic> json) {
    return Cannabinoid(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      amount: json['amount'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'amount': amount,
      'color': color,
    };
  }

// copyWith
  Cannabinoid copyWith({
    String? id,
    String? name,
    String? icon,
    double? amount,
    Color? color,
  }) {
    return Cannabinoid(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      amount: amount ?? this.amount,
      color: color ?? this.color,
    );
  }

// toString
  @override
  String toString() {
    return 'Cannabinoid{id: $id, name: $name, icon: $icon, amount: $amount, color: $color}';
  }
}
