import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _barcode = 'No barcode scanned yet';

  @override
  void initState() {
    super.initState();
  }

  // Método para escanear un código de barras
  Future<void> scanBarcode() async {
    String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color del escáner
      'Cancelar', // Texto para el botón de cancelar
      true, // Activar linterna
      ScanMode.BARCODE, // Modo de escaneo de códigos de barras
    );

    // Si el escaneo fue exitoso (el resultado no es un string vacío)
    if (barcodeResult != '-1') {
      setState(() {
        _barcode = barcodeResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Barcode Scanner Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Escaneado: $_barcode'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: scanBarcode,
                child: const Text('Escanear Código de Barras'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
