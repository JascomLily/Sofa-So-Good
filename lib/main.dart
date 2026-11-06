import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/missing_report_provider.dart';
import 'services/inventory_service.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/admin/admin_screen.dart';
import 'services/supabase_service.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();

  // Bat che do SystemUiMode.manual voi ca hai thanh status bar (tren) va navigation bar (duoi)
  // giup he thong Android luon danh rieng khoang trong hien thi gio/song/wifi va 3 nut dieu huong
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Color(0xFFE8DFD5),
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => MissingReportProvider()),
        ChangeNotifierProvider.value(value: InventoryService()),
      ],
      child: const SofaSoGoodApp(),
    ),
  );
}

class SofaSoGoodApp extends StatelessWidget {
  const SofaSoGoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOFA SO GOOD',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppRootGate(),
    );
  }
}

class AppRootGate extends StatelessWidget {
  const AppRootGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    // Mục 5: Bắt buộc đăng nhập mới xem được sản phẩm
    // Nếu chưa đăng nhập hoặc bị vô hiệu hóa -> mở thẳng LoginScreen gốc (không back, pop thoát app)
    if (!auth.isLoggedIn || auth.currentUser == null) {
      return const LoginScreen(isRootScreen: true);
    }

    // Phân quyền theo vai trò chuẩn:
    // Admin -> Kênh quản trị riêng biệt
    // Khách hàng -> Trang chủ & Mua sắm
    if (auth.isAdmin) {
      return const AdminScreen();
    }

    return const MainNavigationScreen();
  }
}
