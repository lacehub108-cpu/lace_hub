class LaceModel {
  final String id;
  final String name;
  final String material;
  final double price;
  final String designNumber;
  final double pricePerRoll;
  final String imagePath;

  LaceModel({
    required this.id,
    required this.name,
    required this.material,
    required this.price,
    required this.designNumber,
    required this.pricePerRoll,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'material': material,
        'price': price,
        'designNumber': designNumber,
        'pricePerRoll': pricePerRoll,
        'imagePath': imagePath,
      };

  factory LaceModel.fromJson(Map<String, dynamic> json) => LaceModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        material: json['material'] ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        designNumber: json['designNumber'] ?? '',
        pricePerRoll: (json['pricePerRoll'] as num?)?.toDouble() ?? 0.0,
        imagePath: json['imagePath'] ?? '',
      );
}