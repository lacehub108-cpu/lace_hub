class InquiryModel {
  final String id;
  final String customerId;
  final String laceId;
  final String designNumber;
  final String laceName;
  final String imagePath;
  final String customerName;
  final String phone;
  final String address;
  final String status;
  final bool isRead;
  final DateTime createdAt;

  InquiryModel({
    required this.id,
    required this.customerId,
    required this.laceId,
    required this.designNumber,
    required this.laceName,
    required this.imagePath,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.status,
    required this.isRead,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerId': customerId,
        'laceId': laceId,
        'designNumber': designNumber,
        'laceName': laceName,
        'imagePath': imagePath,
        'customerName': customerName,
        'phone': phone,
        'address': address,
        'status': status,
        'isRead': isRead,
        'createdAt': createdAt.toIso8601String(),
      };

  factory InquiryModel.fromJson(Map<String, dynamic> json) => InquiryModel(
        id: json['id'] ?? '',
        customerId: json['customerId'] ?? '',
        laceId: json['laceId'] ?? '',
        designNumber: json['designNumber'] ?? '',
        laceName: json['laceName'] ?? '',
        imagePath: json['imagePath'] ?? '',
        customerName: json['customerName'] ?? '',
        phone: json['phone'] ?? '',
        address: json['address'] ?? '',
        status: json['status'] ?? 'pending',
        isRead: json['isRead'] ?? false,
        createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      );

  InquiryModel copyWith({String? status, bool? isRead}) => InquiryModel(
        id: id,
        customerId: customerId,
        laceId: laceId,
        designNumber: designNumber,
        laceName: laceName,
        imagePath: imagePath,
        customerName: customerName,
        phone: phone,
        address: address,
        status: status ?? this.status,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt,
      );
}