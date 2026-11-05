class MissingReportModel {
  final String id;
  final String? userId;
  final String orderCode;
  final String productName;
  final String partName;
  final int quantity;
  final String note;
  final String photoUrl;
  final String status; // 'PENDING' (Chờ duyệt), 'APPROVED' (Đã duyệt bù), 'DELIVERING' (Đang gửi bù), 'COMPLETED' (Đã nhận)
  final String createdAt;
  final String? adminNote;

  MissingReportModel({
    required this.id,
    this.userId,
    required this.orderCode,
    required this.productName,
    required this.partName,
    required this.quantity,
    required this.note,
    required this.photoUrl,
    this.status = 'PENDING',
    required this.createdAt,
    this.adminNote,
  });

  MissingReportModel copyWith({
    String? id,
    String? userId,
    String? orderCode,
    String? productName,
    String? partName,
    int? quantity,
    String? note,
    String? photoUrl,
    String? status,
    String? createdAt,
    String? adminNote,
  }) {
    return MissingReportModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      orderCode: orderCode ?? this.orderCode,
      productName: productName ?? this.productName,
      partName: partName ?? this.partName,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      photoUrl: photoUrl ?? this.photoUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      adminNote: adminNote ?? this.adminNote,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'orderCode': orderCode,
        'productName': productName,
        'partName': partName,
        'quantity': quantity,
        'note': note,
        'photoUrl': photoUrl,
        'status': status,
        'createdAt': createdAt,
        'adminNote': adminNote,
      };

  factory MissingReportModel.fromJson(Map<String, dynamic> json) => MissingReportModel(
        id: json['id'] ?? '',
        userId: json['userId'],
        orderCode: json['orderCode'] ?? '',
        productName: json['productName'] ?? '',
        partName: json['partName'] ?? '',
        quantity: json['quantity'] ?? 1,
        note: json['note'] ?? '',
        photoUrl: json['photoUrl'] ?? '',
        status: json['status'] ?? 'PENDING',
        createdAt: json['createdAt'] ?? '',
        adminNote: json['adminNote'],
      );
}
