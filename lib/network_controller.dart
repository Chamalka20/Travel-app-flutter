
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

 @override
Future<void> onInit() async {
  super.onInit();
  initConnectivity();
  _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
}

Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Couldn\'t check connectivity status, error:${e}' );
      }
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult connectivityResult) async {
      
      if (connectivityResult == ConnectivityResult.none) {
        await Future.delayed(const Duration(milliseconds: 100));
        Get.rawSnackbar(
          messageText: const Text(
            'PLEASE CONNECT TO THE INTERNET',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14
            )
          ),
          isDismissible: false,
          duration: const Duration(days: 1),
          backgroundColor: Color.fromARGB(255, 97, 97, 97),
          icon : Icon(Icons.wifi_off, color: Colors.white, size: 35,),
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED
        );
        
      } else {
        
        if (Get.isSnackbarOpen) {
            Get.closeCurrentSnackbar();
        }

        
      }
  }
}