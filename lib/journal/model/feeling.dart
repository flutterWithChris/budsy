class Feeling {
  final String? id;
  final String? name;
  final String? icon;
  final String? color;

  Feeling({
    this.id,
    this.name,
    this.icon,
    this.color,
  });

  factory Feeling.fromJson(Map<String, dynamic> json) {
    return Feeling(
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

  @override
  String toString() {
    return 'Feeling{id: $id, name: $name, icon: $icon, color: $color}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Feeling &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          icon == other.icon &&
          color == other.color;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ icon.hashCode ^ color.hashCode;
}
