class ProductCategory {
  int? id;
  String? name;
  String? icon;
  String? color;

  ProductCategory({
    this.id,
    this.name,
    this.icon,
    this.color,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  ProductCategory copyWith({
    int? id,
    String? name,
    String? icon,
    String? color,
  }) {
    return ProductCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  @override
  String toString() {
    return 'ProductCategory{id: $id, name $name, icon: $icon, color: $color}';
  }
}
