class LabReport {
  String? productName;
  double? servingSize;
  Map<String, dynamic>? cannabinoids;
  Map<String, dynamic>? potencySummary;
  Map<String, dynamic>? terpenes;

  LabReport({
    this.productName,
    this.servingSize,
    this.cannabinoids,
    this.potencySummary,
    this.terpenes,
  });

  // From JSON with snake_case keys
  factory LabReport.fromJson(Map<String, dynamic> json) {
    return LabReport(
      productName: json['product_name'],
      servingSize: json['serving_size'],
      cannabinoids: json['cannabinoids'] != null
          ? Map<String, dynamic>.from(json['cannabinoids'])
          : null,
      potencySummary: json['potency_summary'] != null
          ? Map<String, dynamic>.from(json['potency_summary'])
          : null,
      terpenes: json['terpenes'] != null
          ? Map<String, dynamic>.from(json['terpenes'])
          : null,
    );
  }

  // To JSON with snake_case keys
  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'serving_size': servingSize,
      'cannabinoids': cannabinoids,
      'potency_summary': potencySummary,
      'terpenes': terpenes,
    };
  }

  // toString method for a readable representation of the object
  @override
  String toString() {
    return 'LabReport('
        'productName: $productName, '
        'servingSize: $servingSize, '
        'cannabinoids: $cannabinoids, '
        'potencySummary: $potencySummary, '
        'terpenes: $terpenes, '
        ')';
  }
}
