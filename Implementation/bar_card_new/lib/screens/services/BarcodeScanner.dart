import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';

class BarcodeScanner {
  Future open() async {

    String barcode = await scanner.scan();
    return barcode;
  }

  Future checkCamPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      return false;
    } else if (status.isGranted) {
      return true;
    }
  }

  Future askCamPermission() async {
    if (await Permission.camera.request().isGranted) {
    } else {
      if (await Permission.camera.isPermanentlyDenied) {
        // The user opted to never again see the permission request dialog for this
        // app. The only way to change the permission's status now is to let the
        // user manually enable it in the system settings.
        openAppSettings();
      }
    }
  }
}
