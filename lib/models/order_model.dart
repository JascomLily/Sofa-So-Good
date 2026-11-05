enum OrderStatus {
  choDuyet, // Chờ duyệt
  daDuyet, // Đã duyệt
  choGiao, // Chờ giao
  dangGiao, // Đang giao
  giaoThanhCong, // Giao thành công
  daTuChoi, // Đã từ chối (Admin từ chối ở bước Chờ duyệt)
  daHuy, // Đã hủy (Khách tự hủy ở bước Chờ duyệt)
}

extension OrderStatusExtension on OrderStatus {
  String get code {
    switch (this) {
      case OrderStatus.choDuyet:
        return 'CHO_DUYET';
      case OrderStatus.daDuyet:
        return 'DA_DUYET';
      case OrderStatus.choGiao:
        return 'CHO_GIAO';
      case OrderStatus.dangGiao:
        return 'DANG_GIAO';
      case OrderStatus.giaoThanhCong:
        return 'GIAO_THANH_CONG';
      case OrderStatus.daTuChoi:
        return 'DA_TU_CHOI';
      case OrderStatus.daHuy:
        return 'DA_HUY';
    }
  }

  String get label {
    switch (this) {
      case OrderStatus.choDuyet:
        return 'Chờ duyệt';
      case OrderStatus.daDuyet:
        return 'Đã duyệt';
      case OrderStatus.choGiao:
        return 'Chờ giao';
      case OrderStatus.dangGiao:
        return 'Đang giao';
      case OrderStatus.giaoThanhCong:
        return 'Giao thành công';
      case OrderStatus.daTuChoi:
        return 'Đã từ chối';
      case OrderStatus.daHuy:
        return 'Đã hủy';
    }
  }

  static OrderStatus fromString(String? val) {
    if (val == null) return OrderStatus.choDuyet;
    final upper = val.toUpperCase().trim();
    if (upper == 'CHO_DUYET' || upper == 'PENDING') return OrderStatus.choDuyet;
    if (upper == 'DA_DUYET' || upper == 'APPROVED') return OrderStatus.daDuyet;
    if (upper == 'CHO_GIAO' || upper == 'PREPARING' || upper == 'READY_TO_SHIP') return OrderStatus.choGiao;
    if (upper == 'DANG_GIAO' || upper == 'SHIPPING') return OrderStatus.dangGiao;
    if (upper == 'GIAO_THANH_CONG' || upper == 'COMPLETED' || upper == 'DELIVERED') return OrderStatus.giaoThanhCong;
    if (upper == 'DA_TU_CHOI' || upper == 'REJECTED') return OrderStatus.daTuChoi;
    if (upper == 'DA_HUY' || upper == 'CANCELLED') return OrderStatus.daHuy;
    return OrderStatus.choDuyet;
  }
}

class OrderItemModel {
  final String productId;
  final String name;
  final int price;
  final int quantity;
  final String image;
  final String? variant;

  OrderItemModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    this.variant,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'price': price,
        'quantity': quantity,
        'image': image,
        'variant': variant,
      };

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
        productId: json['productId'] ?? '',
        name: json['name'] ?? '',
        price: json['price'] ?? 0,
        quantity: json['quantity'] ?? 1,
        image: json['image'] ?? '',
        variant: json['variant'],
      );
}

class TimelineStepModel {
  final int id;
  final String title;
  final String time;
  final String description;
  final String status; // 'completed', 'current', 'upcoming'

  TimelineStepModel({
    required this.id,
    required this.title,
    required this.time,
    required this.description,
    required this.status,
  });
}

class DriverModel {
  final String name;
  final String licensePlate;
  final String phone;
  final double distanceKm;
  final String avatar;

  DriverModel({
    required this.name,
    required this.licensePlate,
    required this.phone,
    required this.distanceKm,
    required this.avatar,
  });
}

class OrderModel {
  final String id;
  final String? userId;
  final String code;
  final String date;
  final String estimatedDelivery;
  final int totalAmount;
  final String paymentMethod; // 'VNPAY_QR', 'VNPAY_ATM', 'COD'
  String paymentStatus; // 'PAID', 'PENDING'
  final String transactionId;
  OrderStatus orderStatus;
  final String receiverName;
  final String receiverPhone;
  final String shippingAddress;
  final String? orderNote;
  final List<OrderItemModel> items; // Snapshot of items at time of purchase
  final DriverModel? driver;
  final List<TimelineStepModel> timeline;
  int? reviewStars;
  String? reviewComment;
  List<String>? reviewMedia;
  String? rejectReason;
  DateTime? shippedAt;
  DateTime? completedAt;
  bool stockDeducted;
  bool stockReverted;
  bool isReplacementOrder; // Đơn gửi linh kiện thiếu 0đ
  String? linkedReturnRequestId;
  final List<Map<String, dynamic>> statusHistory;

  OrderModel({
    required this.id,
    this.userId,
    required this.code,
    required this.date,
    this.estimatedDelivery = 'Hôm nay, 16:30 - 18:30',
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.transactionId,
    OrderStatus? orderStatus,
    String? status,
    required this.receiverName,
    required this.receiverPhone,
    required this.shippingAddress,
    this.orderNote,
    required this.items,
    this.driver,
    required this.timeline,
    this.reviewStars,
    this.reviewComment,
    this.reviewMedia,
    this.rejectReason,
    this.shippedAt,
    this.completedAt,
    this.stockDeducted = true,
    this.stockReverted = false,
    this.isReplacementOrder = false,
    this.linkedReturnRequestId,
    List<Map<String, dynamic>>? statusHistory,
  })  : orderStatus = orderStatus ?? OrderStatusExtension.fromString(status),
        statusHistory = statusHistory ?? [];

  // Backward compatible getter & setter for string status
  String get orderCode => code;
  String get status => orderStatus.code.toLowerCase();
  set status(String val) {
    orderStatus = OrderStatusExtension.fromString(val);
  }

  bool get isCompleted => orderStatus == OrderStatus.giaoThanhCong;
  bool get isCancelled => orderStatus == OrderStatus.daHuy;
  bool get isRejected => orderStatus == OrderStatus.daTuChoi;
  bool get canCustomerCancel => orderStatus == OrderStatus.choDuyet;

  String get displayCode => code.startsWith('#') ? code : '#$code';

  String get paymentStatusVietnamese {
    final methodUpper = paymentMethod.toUpperCase();
    final isPaid = paymentStatus.toUpperCase() == 'PAID' || orderStatus == OrderStatus.giaoThanhCong;
    if (methodUpper.contains('COD')) {
      return isPaid ? 'Thanh toán khi nhận hàng (COD) – Đã thu tiền' : 'Thanh toán khi nhận hàng (COD) – Chưa thanh toán';
    } else if (methodUpper.contains('VNPAY')) {
      return isPaid ? 'Đã thanh toán (Cổng VNPAY)' : 'Chờ thanh toán (VNPAY)';
    }
    return isPaid ? 'Đã thanh toán' : 'Chưa thanh toán';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'code': code,
        'date': date,
        'estimatedDelivery': estimatedDelivery,
        'totalAmount': totalAmount,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'transactionId': transactionId,
        'status': orderStatus.code,
        'receiverName': receiverName,
        'receiverPhone': receiverPhone,
        'shippingAddress': shippingAddress,
        'orderNote': orderNote,
        'items': items.map((i) => i.toJson()).toList(),
        'reviewStars': reviewStars,
        'reviewComment': reviewComment,
        'reviewMedia': reviewMedia,
        'rejectReason': rejectReason,
        'shippedAt': shippedAt?.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'stockDeducted': stockDeducted,
        'stockReverted': stockReverted,
        'isReplacementOrder': isReplacementOrder,
        'linkedReturnRequestId': linkedReturnRequestId,
        'statusHistory': statusHistory,
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      userId: json['userId'],
      code: json['code'] ?? '',
      date: json['date'] ?? '',
      estimatedDelivery: json['estimatedDelivery'] ?? 'Hôm nay, 16:30 - 18:30',
      totalAmount: (json['totalAmount'] as num?)?.toInt() ?? 0,
      paymentMethod: json['paymentMethod'] ?? 'COD',
      paymentStatus: json['paymentStatus'] ?? 'PENDING',
      transactionId: json['transactionId'] ?? '',
      status: json['status'],
      receiverName: json['receiverName'] ?? '',
      receiverPhone: json['receiverPhone'] ?? '',
      shippingAddress: json['shippingAddress'] ?? '',
      orderNote: json['orderNote'],
      items: (json['items'] as List<dynamic>? ?? [])
          .map((i) => OrderItemModel.fromJson(Map<String, dynamic>.from(i)))
          .toList(),
      timeline: (json['timeline'] as List<dynamic>? ?? [])
          .map((t) => TimelineStepModel(
                id: t['id'] ?? 1,
                title: t['title'] ?? '',
                time: t['time'] ?? '',
                description: t['description'] ?? '',
                status: t['status'] ?? 'completed',
              ))
          .toList(),
      reviewStars: json['reviewStars'],
      reviewComment: json['reviewComment'],
      reviewMedia: (json['reviewMedia'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      rejectReason: json['rejectReason'],
      shippedAt: json['shippedAt'] != null ? DateTime.tryParse(json['shippedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.tryParse(json['completedAt']) : null,
      stockDeducted: json['stockDeducted'] ?? true,
      stockReverted: json['stockReverted'] ?? false,
      isReplacementOrder: json['isReplacementOrder'] ?? false,
      linkedReturnRequestId: json['linkedReturnRequestId'],
      statusHistory: (json['statusHistory'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [],
    );
  }


  OrderModel copyWith({
    String? id,
    String? userId,
    String? code,
    String? date,
    String? estimatedDelivery,
    int? totalAmount,
    String? paymentMethod,
    String? paymentStatus,
    String? transactionId,
    dynamic status,
    String? receiverName,
    String? receiverPhone,
    String? shippingAddress,
    String? orderNote,
    List<OrderItemModel>? items,
    List<TimelineStepModel>? timeline,
    DriverModel? driver,
    int? reviewStars,
    String? reviewComment,
    List<String>? reviewMedia,
    String? rejectReason,
    DateTime? shippedAt,
    DateTime? completedAt,
    bool? stockDeducted,
    bool? stockReverted,
    bool? isReplacementOrder,
    String? linkedReturnRequestId,
    List<Map<String, dynamic>>? statusHistory,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      code: code ?? this.code,
      date: date ?? this.date,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      transactionId: transactionId ?? this.transactionId,
      status: status ?? this.orderStatus,
      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      orderNote: orderNote ?? this.orderNote,
      items: items ?? this.items,
      timeline: timeline ?? this.timeline,
      driver: driver ?? this.driver,
      reviewStars: reviewStars ?? this.reviewStars,
      reviewComment: reviewComment ?? this.reviewComment,
      reviewMedia: reviewMedia ?? this.reviewMedia,
      rejectReason: rejectReason ?? this.rejectReason,
      shippedAt: shippedAt ?? this.shippedAt,
      completedAt: completedAt ?? this.completedAt,
      stockDeducted: stockDeducted ?? this.stockDeducted,
      stockReverted: stockReverted ?? this.stockReverted,
      isReplacementOrder: isReplacementOrder ?? this.isReplacementOrder,
      linkedReturnRequestId: linkedReturnRequestId ?? this.linkedReturnRequestId,
      statusHistory: statusHistory ?? this.statusHistory,
    );
  }

}
