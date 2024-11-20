import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner_platform_interface.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';


// Clase Mock para el plugin
class MockFlutterBarcodeScannerPlatform
    with MockPlatformInterfaceMixin
    implements FlutterBarcodeScannerPlatform {
  @override
  Future<String?> scanBarcode(String overlayColor, String cancelButtonText, bool isShowFlashIcon, ScanMode mode) {
    return Future.value('123456789'); // Simula un código de barras escaneado
  }
  
  @override
  Future<String?> getPlatformVersion() {
    // TODO: implement getPlatformVersion
    throw UnimplementedError();
  }
}

void main() {
  // Asegura que el entorno de pruebas de integración esté inicializado
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  test('$MethodChannelFlutterBarcodeScanner is the default instance', () {
    // Obtiene la instancia inicial del plugin
    final FlutterBarcodeScannerPlatform initialPlatform = FlutterBarcodeScannerPlatform.instance;

    // Verifica que la instancia inicial sea del tipo esperado
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterBarcodeScanner>());
  });

  test('scanBarcode returns a valid barcode', () async {
    // Crea una instancia del plugin
    final FlutterBarcodeScanner flutterBarcodeScannerPlugin = FlutterBarcodeScanner();

    // Reemplaza la instancia de plataforma por el mock
    final MockFlutterBarcodeScannerPlatform fakePlatform = MockFlutterBarcodeScannerPlatform();
    FlutterBarcodeScannerPlatform.instance = fakePlatform;

    // Verifica que el método scanBarcode() devuelva un valor simulado
    final String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color de la barra de escaneo
      'Cancelar', // Texto del botón de cancelar
      true, // Activar linterna
      ScanMode.BARCODE, // Modo de escaneo para códigos de barras
    );

    expect(barcodeResult, '123456789'); // Verifica que el resultado simulado sea el esperado
  });
}

class IntegrationTestWidgetsFlutterBinding {
  static void ensureInitialized() {}
}
