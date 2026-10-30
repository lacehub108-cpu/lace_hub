class OrderModel {
  final String id;
  final String customerId; // <-- નવું
  final String laceId;
  final String designNumber;
  final String laceName;
  final String imagePath;
  final String customerName;
  final String phone;
  final String address;
  final int quantity;
  final String status;
  final bool isRead;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.customerId, // <-- નવું
    required this.laceId,
    required this.designNumber,
    required this.laceName,
    required this.imagePath,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.quantity,
    required this.status,
    required this.isRead,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerId': customerId, // <-- નવું
        'laceId': laceId,
        'designNumber': designNumber,
        'laceName': laceName,
        'imagePath': imagePath,
        'customerName': customerName,
        'phone': phone,
        'address': address,
        'quantity': quantity,
        'status': status,
        'isRead': isRead,
        'createdAt': createdAt.toIso8601String(),
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] ?? '',
        customerId: json['customerId'] ?? '', // <-- નવું
        laceId: json['laceId'] ?? '',
        designNumber: json['designNumber'] ?? '',
        laceName: json['laceName'] ?? '',
        imagePath: json['imagePath'] ?? '',
        customerName: json['customerName'] ?? '',
        phone: json['phone'] ?? '',
        address: json['address'] ?? '',
        quantity: json['quantity'] ?? 1,
        status: json['status'] ?? 'pending',
        isRead: json['isRead'] ?? false,
        createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      );

  OrderModel copyWith({String? status, bool? isRead}) => OrderModel(
        id: id,
        customerId: customerId,
        laceId: laceId,
        designNumber: designNumber,
        laceName: laceName,
        imagePath: imagePath,
        customerName: customerName,
        phone: phone,
        address: address,
        quantity: quantity,
        status: status ?? this.status,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt,
      );
}