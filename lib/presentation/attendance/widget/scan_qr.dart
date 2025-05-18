import 'package:etms/app/utils/custom_snackbar.dart';
import 'package:etms/presentation/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRView extends StatefulWidget {
  const ScanQRView({super.key});

  @override
  State<ScanQRView> createState() => _ScanQRViewState();
}

class _ScanQRViewState extends State<ScanQRView> with WidgetsBindingObserver {
  MobileScannerController cameraController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      cameraController.stop();
    } else if (state == AppLifecycleState.resumed) {
      cameraController.start();
    }
  }

  void _onDetect(BarcodeCapture capture) {
    final barcode = capture.barcodes.first;
    final scannedCode = barcode.rawValue ?? '';
    final expectedValue = Get.arguments.toString();

    if (expectedValue.isNotEmpty && scannedCode.contains(expectedValue)) {
      cameraController.stop();
      Get.back(result: true);
    }else{
      'There is something wrong with QR/Bar code.'.error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: 'QR Scan'),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: MobileScanner(
                controller: cameraController,
                onDetect: _onDetect,
                errorBuilder: (context, error, _) => Center(
                  child: Text('Camera error: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
