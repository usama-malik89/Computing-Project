import 'package:qrscan/qrscan.dart' as scanner;

class BarcodeScanner {
  Future open() async {
    String barcode = await scanner.scan();
    return barcode;
  }

}