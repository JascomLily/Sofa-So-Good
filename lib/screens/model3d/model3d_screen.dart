import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';

import '../../data/mock_data.dart';
import '../../models/product_model.dart';
import '../main_navigation_screen.dart';

class Model3DScreen extends StatefulWidget {
  final ProductModel? initialProduct;

  const Model3DScreen({super.key, this.initialProduct});

  static Map<String, List<String>> get officialAssemblySteps => _Model3DScreenState.officialAssemblySteps;

  @override
  State<Model3DScreen> createState() => _Model3DScreenState();
}

class _Model3DScreenState extends State<Model3DScreen> {
  late final ProductModel _product;
  int _currentStep = 1;
  late int _totalSteps;

  static const List<String> _officialUnityIds = [
    'Chair01',
    'Chair18',
    'Chair34',
    'Closet01',
    'Closet23',
    'Drawer30',
    'Drawer31',
    'Drawer50',
    'BedFrame26',
    'BedFrame35',
    'Sofa36',
    'Sofa49',
    'Table08',
    'Table09',
    'Table26',
    'Table33',
    'Table43',
    'Table48',
    'BathroomVanity04',
  ];

  static const Map<String, List<String>> officialAssemblySteps = {
    'Chair01': [
      'Lắp ráp khung chân uốn nhiệt bằng gỗ bạch dương.',
      'Bắt vít liên kết giằng chịu lực hai bên hông ghế.',
      'Cố định khung đỡ lưng và mặt ngồi vào khung chân.',
      'Lắp đệm mút cao cấp và siết chặt ốc khóa an toàn.',
    ],
    'Chair18': [
      'Lắp 4 chân gỗ sồi tiện tròn có đệm chống trầy vào đáy thân ghế.',
      'Cân chỉnh độ cao và siết ốc ren hoa mai chống rung.',
      'Đặt đệm ngồi bọc vải nỉ cao cấp vào vị trí lòng ghế.',
    ],
    'Chair34': [
      'Lắp chân cong chữ L thứ nhất vào mặt ghế tròn bằng vít lục giác.',
      'Lắp chân cong thứ hai và thứ ba đối xứng.',
      'Lắp chân cong thứ tư và siết chặt toàn bộ 4 chân.',
      'Dán nút đệm nỉ chống ồn đáy chân ghế.',
    ],
    'Closet01': [
      'Ghép khung đáy và 2 vách hông bằng mộng âm dương và chốt cam.',
      'Lắp nóc tủ và đóng tấm lưng ván ép cố định khung tủ.',
      'Gắn thanh treo quần áo chịu lực và các đợt ngăn kệ.',
      'Bắt bản lề giảm chấn và gắn 2 cánh cửa tủ.',
      'Căn chỉnh bản lề cánh cửa và lắp tay nắm kim loại.',
    ],
    'Closet23': [
      'Ráp khung hộp tủ âm tường và cố định bas chống lật tường.',
      'Lắp các đợt chia ngăn và thanh ray trượt ray bi.',
      'Luồn dây và gắn dải đèn LED cảm ứng âm nóc tủ.',
      'Lắp hệ cánh cửa mở lùa và căn chỉnh giảm chấn cánh tủ.',
      'Kiểm tra ray trượt và hoàn thiện tay nắm âm.',
    ],
    'Drawer30': [
      'Lắp ráp khung chính: đáy, 2 vách hông và nóc tủ bằng chốt cam.',
      'Bắt ray trượt bi 3 tầng vào hai bên thành tủ.',
      'Lắp ráp 3 hộc ngăn kéo từ ván hông, ván đáy và mặt trước.',
      'Lồng 3 ngăn kéo vào thanh ray trượt và kiểm tra êm ái.',
    ],
    'Drawer31': [
      'Ghép khung tủ gỗ óc chó với liên kết chốt gỗ sồi và chốt cam.',
      'Cố định tấm hậu chống ẩm và lắp chân đế chịu lực.',
      'Lắp hệ ray trượt giảm chấn cho các ngăn kéo.',
      'Ráp hộc ngăn kéo và gắn tay nắm đồng thau cổ điển.',
      'Trượt hộc ngăn kéo vào ray và kiểm tra độ khít.',
    ],
    'Drawer50': [
      'Lắp hệ chân bệ mở rộng và khung đáy gia cường.',
      'Ghép các vách chia khoang đôi và nóc tủ lớn.',
      'Bắt cụm ray trượt cho 6 ngăn kéo khoang đôi.',
      'Lắp ráp các hộc kéo và căn chỉnh khoảng cách mặt hộc.',
      'Khóa chốt an toàn chống lật của tủ ngăn kéo.',
    ],
    'BedFrame26': [
      'Lắp thành đầu giường với 2 thanh hồi giường bằng bu-lông ren.',
      'Ghép đuôi giường và siết chặt các góc ke gia cường.',
      'Lắp thanh đòn dầm thép chịu lực chạy dọc giữa giường.',
      'Rải giát giường nan gỗ thông cong chịu lực đàn hồi.',
      'Căn chỉnh và siết khóa toàn bộ bu-lông liên kết.',
    ],
    'BedFrame35': [
      'Lắp bảng đầu giường cỡ lớn King 1m8 với cột chân trụ gỗ thông.',
      'Bắt hồi giường hai bên vào đầu giường và đuôi giường.',
      'Lắp 2 thanh dầm đỡ phụ và dầm thép trung tâm Skorva.',
      'Lắp hệ thống ray đỡ nan giát giường hai bên thành.',
      'Rải giát giường Lönset và cố định chốt chống trượt nệm.',
      'Kiểm tra độ ổn định và hoàn thiện kết cấu giường.',
    ],
    'Sofa36': [
      'Lắp khung ghế ngồi vào khung tựa lưng bằng bu-lông thép M8.',
      'Bắt 2 tay vịn đệm bản to vào hai bên hông ghế.',
      'Vặn 4 chân gỗ tự nhiên vào 4 góc đáy sofa.',
      'Trùm áo bọc vải dệt nỉ Scandinavia vào khung và đệm.',
      'Đặt đệm ngồi bọt biển và đệm tựa lưng hoàn thiện.',
    ],
    'Sofa49': [
      'Lắp khung mô-đun 2 chỗ chính với bu-lông ren mạ crom.',
      'Ghép mô-đun góc chữ L (Chaise lounge) vào ghế chính.',
      'Lắp hệ chân kim loại sáng bóng chịu tải trọng lớn.',
      'Khóa ngàm liên kết giữa 2 khối góc sofa.',
      'Đặt các khối đệm da thật cao cấp và cân chỉnh phẳng mặt.',
    ],
    'Table08': [
      'Lắp cụm chân chữ X kim loại sơn tĩnh điện hai bên.',
      'Bắt thanh giằng ngang kết nối 2 khung chân bàn.',
      'Đặt mặt bàn gỗ sồi lên khung chân và siết ốc ren định vị.',
      'Lắp nẹp luồn dây cáp âm bàn và hoàn thiện đế tăng chỉnh.',
    ],
    'Table09': [
      'Lắp 4 chân bàn tiện tròn cổ điển vào khung đỡ mặt bàn.',
      'Bắt hệ cơ cấu ray trượt mở rộng cánh gập ở giữa.',
      'Lắp cánh mở rộng dự phòng xếp gọn dưới gầm bàn.',
      'Khóa chốt cố định mặt bàn và kiểm tra cơ chế kéo trượt.',
    ],
    'Table26': [
      'Lật úp mặt bàn dáng lá bằng gỗ tần bì lên mặt mềm.',
      'Vặn xoắn 3 chân gỗ có bịt đồng trang trí vào 3 đế ren mặt đáy.',
      'Dán đệm chống trượt đáy chân và kiểm tra độ cân bằng bàn.',
    ],
    'Table33': [
      'Định vị 4 chốt mộng nêm gỗ âm dương vào 4 góc mặt bàn.',
      'Đẩy từng chân bàn khớp chặt vào rãnh mộng âm dương.',
      'Khóa chốt an toàn dưới gầm chân mà không cần dùng vít.',
      'Lật bàn đứng thẳng và kiểm tra độ vững chãi của liên kết nêm.',
    ],
    'Table43': [
      'Mở rộng khung chân kim loại gấp tròn chữ X.',
      'Gắn thanh giằng tròn đáy vào các ngàm giữ khung chân.',
      'Đặt khay kim loại rời lên trên khung làm mặt bàn cafe.',
    ],
    'Table48': [
      'Lắp ráp khung kim loại mạ vàng PVD hình học chịu lực.',
      'Dán nút silicon đệm chống trượt lên các điểm tiếp xúc khung.',
      'Đặt mặt đá cẩm thạch nguyên khối lên khung và căn chuẩn mép.',
    ],
    'BathroomVanity04': [
      'Ghép khung tủ lavabo chống ẩm và gia cố góc treo tường.',
      'Lắp ray trượt giảm chấn đặc biệt chừa khe thoát ống siphon.',
      'Lắp ráp 2 ngăn kéo có vách ngăn phụ kiện thông minh.',
      'Khoan bắt bas treo chịu lực vào tường nhà tắm.',
      'Treo tủ lên tường, căn chỉnh mặt phẳng và lắp mặt lavabo sứ.',
    ],
  };

  String _resolveUnityModelId(ProductModel product) {
    final rawCandidates = [
      product.id,
      product.modelCode,
      product.id.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''),
      product.modelCode.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''),
    ];

    for (final candidate in rawCandidates) {
      final candLower = candidate.toLowerCase();
      if (candLower == 'bed26' || candLower == 'bedframe26') return 'BedFrame26';
      if (candLower == 'bed35' || candLower == 'bedframe35') return 'BedFrame35';
      for (final unityId in _officialUnityIds) {
        if (candLower == unityId.toLowerCase()) {
          return unityId;
        }
      }
    }

    final name = product.name.toLowerCase();
    if (name.contains('sofa')) return 'Sofa36';
    if (name.contains('hemnes king') || name.contains('bed 35') || name.contains('bedframe 35')) return 'BedFrame35';
    if (name.contains('giường') || name.contains('bed')) return 'BedFrame26';
    if (name.contains('lavabo') || name.contains('vanity')) return 'BathroomVanity04';
    if (name.contains('pax')) return 'Closet23';
    if (name.contains('tủ áo') || name.contains('wardrobe') || name.contains('closet')) return 'Closet01';
    if (name.contains('koppang')) return 'Drawer31';
    if (name.contains('nordli')) return 'Drawer50';
    if (name.contains('ngăn kéo') || name.contains('drawer') || name.contains('chest')) return 'Drawer30';
    if (name.contains('ingatorp')) return 'Table09';
    if (name.contains('lövbacken') || name.contains('lovbacken')) return 'Table26';
    if (name.contains('lisabo')) return 'Table33';
    if (name.contains('gladom')) return 'Table43';
    if (name.contains('marble')) return 'Table48';
    if (name.contains('bàn') || name.contains('table') || name.contains('desk')) return 'Table08';
    if (name.contains('frosta')) return 'Chair34';
    if (name.contains('strandmon')) return 'Chair18';
    if (name.contains('ghế') || name.contains('chair') || name.contains('stool')) return 'Chair01';

    return product.id;
  }

  @override
  void initState() {
    super.initState();
    _product = widget.initialProduct ?? getMockProducts().first;

    final unityId = _resolveUnityModelId(_product);
    final stepsList = officialAssemblySteps[unityId];
    if (stepsList != null && stepsList.isNotEmpty) {
      _totalSteps = stepsList.length;
    } else {
      _totalSteps = 1;
    }

    if (_product.is3dReady) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        resumeUnity();
        sendToUnity('AssemblyManager', 'SetId', unityId);
      });
    }
  }

  void _restoreSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
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
  }

  @override
  void dispose() {
    if (_product.is3dReady) {
      pauseUnity();
    }
    _restoreSystemUI();
    super.dispose();
  }

  void _sendUnityCommand(String methodName) {
    if (_product.is3dReady) {
      sendToUnity('AssemblyManager', methodName, '');
    }
  }

  void _onMessageFromUnity(String data) {
    final msg = data.trim();
    if (msg.contains('COMPLETED') || msg.contains('DONE') || msg.contains('END')) {
      setState(() {
        _currentStep = _totalSteps;
      });
    } else if (msg.contains(':')) {
      final parts = msg.split(':');
      if (parts.length >= 2) {
        final s = int.tryParse(parts[parts.length - 2]);
        final t = int.tryParse(parts[parts.length - 1]);
        if (s != null && s > 0) _currentStep = s;
        if (t != null && t > 0) _totalSteps = t;
        setState(() {});
      }
    }
  }

  void _onPrevClicked() {
    _sendUnityCommand('OnBackClicked');
    setState(() {
      if (_currentStep > 1) {
        _currentStep--;
      }
    });
  }

  void _onNextClicked() {
    _sendUnityCommand('OnNextClicked');
    setState(() {
      if (_currentStep < _totalSteps) {
        _currentStep++;
      }
    });
  }

  void _returnToHome() {
    if (_product.is3dReady) {
      pauseUnity();
    }
    _restoreSystemUI();
    // Quay ve Menu chinh, don sach stack dieu huong de Back khong quay lai 3D (Muc 3 & Muc 7)
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavigationScreen(initialIndex: 0)),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final unityId = _resolveUnityModelId(_product);
    final stepsList = officialAssemblySteps[unityId];
    final isLastStep = _currentStep >= _totalSteps || _totalSteps <= 1;

    // San pham chua co du lieu huong dan 3D -> Hien thong bao ro rang, tranh man hinh trang hoac crash (Muc 3)
    if (!_product.is3dReady) {
      return Scaffold(
        backgroundColor: const Color(0xFFFBF8F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2C1810),
          foregroundColor: Colors.white,
          title: Text(
            'Hướng dẫn 3D: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8DFD5).withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.view_in_ar_outlined,
                      size: 56,
                      color: Color(0xFF805528),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Chưa có mô hình 3D cho "',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C1810),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Đội ngũ kỹ thuật SOFA SO GOOD đang quét và dựng mô hình lắp ráp chi tiết cho sản phẩm này. Bạn vui lòng tham khảo tài liệu giấy đi kèm kiện hàng.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF666666),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C1810),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Quay lại danh mục sản phẩm'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final currentStepDescription = (stepsList != null && _currentStep <= stepsList.length)
        ? stepsList[_currentStep - 1]
        : (isLastStep ? 'Đã hoàn thành toàn bộ các bước lắp ráp.' : 'Đang lắp mộng âm dương chi tiết.');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white, size: 24),
        actionsIconTheme: const IconThemeData(color: Colors.white, size: 24),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          tooltip: 'Quay lại',
          onPressed: _returnToHome,
        ),
        title: Text(
          'Hướng dẫn lắp ráp: ',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.home_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            tooltip: 'Trang chủ',
            onPressed: _returnToHome,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            Expanded(
              child: EmbedUnity(
                onMessageFromUnity: _onMessageFromUnity,
              ),
            ),

            // Step Progress & Assembly Controls
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2)),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step Indicator and Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isLastStep ? const Color(0xFFE8F5E9) : const Color(0xFFFBF8F5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isLastStep ? const Color(0xFF81C784) : const Color(0xFFDCD2C6),
                          ),
                        ),
                        child: Text(
                          'Bước  / ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isLastStep ? const Color(0xFF2E7D32) : const Color(0xFF2C1810),
                          ),
                        ),
                      ),
                      Text(
                        isLastStep ? 'Đã hoàn thành' : 'Đang tiến hành',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isLastStep ? const Color(0xFF2E7D32) : const Color(0xFF805528),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Real Step Description Text
                  Text(
                    currentStepDescription,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF161B28),
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _totalSteps > 0 ? (_currentStep / _totalSteps).clamp(0.0, 1.0) : 1.0,
                    backgroundColor: const Color(0xFFE8DFD5),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isLastStep ? const Color(0xFF2E7D32) : const Color(0xFF805528),
                    ),
                    minHeight: 5,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 12),

                  // Action Buttons: [Trước], [Tiếp theo] or [Hoàn thành]
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _currentStep > 1 ? _onPrevClicked : null,
                          icon: const Icon(Icons.arrow_back, size: 16),
                          label: const Text('Trước', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(
                              color: _currentStep > 1 ? const Color(0xFF2C1810) : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: isLastStep
                            ? ElevatedButton.icon(
                                onPressed: _returnToHome,
                                icon: const Icon(Icons.check_circle_outline, size: 18),
                                label: const Text(
                                  'Hoàn thành',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2E7D32),
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              )
                            : ElevatedButton.icon(
                                onPressed: _onNextClicked,
                                icon: const Icon(Icons.arrow_forward, size: 16),
                                label: const Text('Tiếp theo', style: TextStyle(fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2C1810),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
