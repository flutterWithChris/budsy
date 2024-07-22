import 'dart:async';

import 'package:canjo/consts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen>
    with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController();
  StreamSubscription? _subscription;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        _subscription = controller.barcodes.listen((barcodes) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Detected: ${barcodes.barcodes.first}'),
            ),
          );
          context.pop();
        });

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetect: (barcodes) async {
        try {
          context.pop();
          // final directory = await getApplicationDocumentsDirectory();
          // final filePath = '${directory.path}/lab_report.pdf';

          // Dio dio = Dio();

          // Response<dynamic> response =
          //     await dio.download(barcodes.barcodes.first.toString(), filePath);
          // print(response.data);
        } catch (e) {
          print(e);
        }
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
}
