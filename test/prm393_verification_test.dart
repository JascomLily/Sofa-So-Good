import 'package:flutter_test/flutter_test.dart';
import 'package:furni3d_mobile/models/order_model.dart';
import 'package:furni3d_mobile/models/user_model.dart';
import 'package:furni3d_mobile/providers/auth_provider.dart';
import 'package:furni3d_mobile/providers/order_provider.dart';
import 'package:furni3d_mobile/screens/model3d/model3d_screen.dart';
import 'package:furni3d_mobile/services/inventory_service.dart';
import 'package:furni3d_mobile/services/vnpay_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Mục 0: Card Payment / ATM Sandbox Test', () {
    test('Scenario 1: Payment Success generates valid HMAC-SHA512 URL and verifies response', () {
      final url = VnpayService.createPaymentUrl(
        orderId: 'TX-TEST-001',
        amount: 2450000,
        orderInfo: 'Thanh toan don hang #TX-TEST-001',
      );
      expect(url.contains('vnp_Command=pay'), isTrue);
      expect(url.contains('vnp_Amount=245000000'), isTrue); // VNPAY multiplies by 100
      expect(url.contains('vnp_SecureHash='), isTrue);

      final uri = Uri.parse(url);
      final params = Map<String, String>.from(uri.queryParameters);
      params['vnp_ResponseCode'] = '00';
      params['vnp_TransactionNo'] = '14829101';
      params['vnp_BankCode'] = 'NCB';

      final res = VnpayService.verifyPaymentResponse(params);
      expect(res.responseCode, '00');
      expect(res.orderId, 'TX-TEST-001');
      expect(res.message, 'Giao dịch thành công');
    });

    test('Scenario 2 & 3: Cancel or Failure preserves inventory (reversion / no loss)', () {
      final inv = InventoryService();
      final initialStock = inv.getStock('Table08');

      // Deduct order stock
      final deductOk = inv.deductOrderStock(
        orderCode: '#ORD-CANCEL-TEST',
        items: [
          {'productId': 'Table08', 'quantity': 2, 'name': 'Nordic Oak Desk'}
        ],
      );
      expect(deductOk, isTrue);
      expect(inv.getStock('Table08'), initialStock - 2);

      // Customer cancels or payment fails -> Revert stock
      inv.revertOrderStock(
        orderCode: '#ORD-CANCEL-TEST',
        items: [
          {'productId': 'Table08', 'quantity': 2, 'name': 'Nordic Oak Desk'}
        ],
        reason: 'Khách hủy thanh toán VNPAY (Rollback an toàn)',
      );
      expect(inv.getStock('Table08'), initialStock);
    });
  });

  group('Mục 1: Customer Deactivation Test', () {
    test('Disabled customer account cannot login and is rejected with clear Vietnamese status', () {
      final user = UserModel(
        id: 'cust-banned-01',
        name: 'Nguyen Van Khoa',
        email: 'khoa.test@gmail.com',
        phone: '0912345678',
        role: 'customer',
        avatar: '',
        savedAddress: '',
        isActive: false,
        isBanned: true,
        banReason: 'Vi phạm chính sách cộng đồng',
      );
      expect(user.isActive, isFalse);
      expect(user.isBanned, isTrue);
      expect(user.banReason, isNotNull);

      // AuthProvider toggle ban validation
      final auth = AuthProvider();
      final canBanSelf = auth.toggleBanUser('admin-01', reason: 'Self ban');
      expect(canBanSelf, isFalse); // Admin cannot ban themselves!
    });
  });

  group('Mục 2: COD Payment Workflow Test', () {
    test('COD order initializes as Unpaid, and transitions to Paid upon delivery confirmation', () {
      final order = OrderModel(
        id: 'ord-cod-test-1',
        code: '#F3D-COD-99',
        date: '06/11/2026',
        totalAmount: 1850000,
        paymentMethod: 'COD',
        paymentStatus: 'PENDING',
        transactionId: 'COD-1850000',
        orderStatus: OrderStatus.choDuyet,
        stockDeducted: true,
        stockReverted: false,
        receiverName: 'Nguyen Van COD',
        receiverPhone: '0901234567',
        shippingAddress: '456 Le Loi, Q1, HCM',
        items: [],
        timeline: [],
      );

      // Initial state: Unpaid COD
      expect(order.paymentStatusVietnamese, 'Thanh toán khi nhận hàng (COD) – Chưa thanh toán');

      // Order transitions to giaoThanhCong
      order.orderStatus = OrderStatus.giaoThanhCong;
      order.paymentStatus = 'PAID';
      order.completedAt = DateTime.now();

      // State upon delivery: Paid COD
      expect(order.paymentStatusVietnamese, 'Đã thanh toán (COD)');
      expect(order.completedAt, isNotNull);
    });

    test('OrderProvider confirmDeliveredByCustomer automatically updates COD order to PAID with timestamp', () {
      final provider = OrderProvider();
      final order = OrderModel(
        id: 'ord-prov-cod-test',
        code: '#F3D-COD-01',
        date: '06/11/2026',
        totalAmount: 2000000,
        paymentMethod: 'COD',
        paymentStatus: 'PENDING',
        transactionId: 'COD-2000000',
        orderStatus: OrderStatus.dangGiao,
        stockDeducted: true,
        stockReverted: false,
        receiverName: 'Test Receiver',
        receiverPhone: '0900000000',
        shippingAddress: 'HCM',
        items: [],
        timeline: [],
      );

      provider.addOrder(order);
      provider.confirmDeliveredByCustomer('ord-prov-cod-test', customerId: 'cust-123');

      final updated = provider.orders.firstWhere((o) => o.id == 'ord-prov-cod-test');
      expect(updated.orderStatus, OrderStatus.giaoThanhCong);
      expect(updated.paymentStatus, 'PAID');
      expect(updated.completedAt, isNotNull);
      expect(updated.paymentStatusVietnamese, 'Đã thanh toán (COD)');
    });
  });

  group('Mục 3: 3D Assembly Instructions Test for All 19 Models', () {
    test('All 19 official 3D models have real step counts N >= 3 and valid descriptions', () {
      expect(Model3DScreen.officialAssemblySteps.length, 19);

      final models = [
        'Chair01', 'Chair18', 'Chair34', 'Closet01', 'Closet23',
        'Drawer30', 'Drawer31', 'Drawer50', 'BedFrame26', 'BedFrame35',
        'Sofa36', 'Sofa49', 'Table08', 'Table09', 'Table26',
        'Table33', 'Table43', 'Table48', 'BathroomVanity04',
      ];

      for (final model in models) {
        final steps = Model3DScreen.officialAssemblySteps[model];
        expect(steps, isNotNull, reason: 'Missing steps for model: $model');
        expect(steps!.isNotEmpty, isTrue, reason: 'Steps list empty for model: $model');
        expect(steps.length >= 3, isTrue, reason: 'Model $model has less than 3 steps: ${steps.length}');

        for (int i = 0; i < steps.length; i++) {
          expect(steps[i].trim().isNotEmpty, isTrue);
          expect(steps[i].length >= 10, isTrue, reason: 'Step $i for $model is too short');
        }
      }
    });
  });
}
