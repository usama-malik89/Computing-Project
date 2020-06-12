import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';

//This class contains the code to open the QR scanner and some camera permission handling
class BarcodeScanner {

  //function to open the camera for the QR code scanner
  Future openQRScanner() async {
    String barcode = await scanner.scan();

    //returns the String of the QR code result
    return barcode;
  }

  //Function to check the camera permission status
  Future checkCamPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      //returns false if permission is denied
      return false;
    } else if (status.isGranted) {
      //returns true if permission is granted
      return true;
    }
  }

  //Function to ask the user for the camera permission again if they have previously denied it
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
