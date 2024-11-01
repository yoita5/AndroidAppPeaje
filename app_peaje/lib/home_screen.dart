import 'package:app_peaje/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  bool _isUserButtonPressed = false;
  bool _isHistoryButtonPressed = false;
  bool _isQrButtonPressed = false;
  bool _isRechargeButtonPressed = false;
  bool _isVehiclesButtonPressed = false;
  bool _isScanQrButtonPressed = false;

  final String _username = 'Juan Pérez';
  String _qrImageUrl = ''; // Variable to store the QR code image URL

  void _toggleUserButtonState() {
    setState(() {
      _isUserButtonPressed = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    ).then((_) {
      setState(() {
        _isUserButtonPressed = false;
      });
    });
  }

  void _toggleHistoryButtonState() {
    setState(() {
      _isHistoryButtonPressed = true;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isHistoryButtonPressed = false;
      });
    });
  }

  void _toggleQrButtonState() async {
    setState(() {
      _isQrButtonPressed = true;
    });
    String uniqueQrData = 'usuario:$_username';
    
    String qrCodeImageUrl = await _generateQrCodeImage(uniqueQrData);
    
    setState(() {
      _qrImageUrl = qrCodeImageUrl;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isQrButtonPressed = false;
      });
    });

    _showQrDialog();
  }

  Future<String> _generateQrCodeImage(String data) async {
    final String qrCodeApiUrl = 'https://api.qrserver.com/v1/create-qr-code/?data=$data&size=200x200';
    return qrCodeApiUrl;
  }

  void _showQrDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tu Código QR'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (_qrImageUrl.isNotEmpty)
                Image.network(
                  _qrImageUrl,
                  height: 200.0,
                  width: 200.0,
                  fit: BoxFit.cover,
                )
              else
                const Text('Generando código QR...'),
              const SizedBox(height: 20),
              const Text('Escanea este código QR para usarlo.'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleRechargeButtonState() {
    setState(() {
      _isRechargeButtonPressed = true;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isRechargeButtonPressed = false;
      });
    });
  }

  void _toggleVehiclesButtonState() {
    setState(() {
      _isVehiclesButtonPressed = true;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isVehiclesButtonPressed = false;
      });
    });
  }

  void _toggleScanQrButtonState() async {
    setState(() {
      _isScanQrButtonPressed = true;
    });
    try {
      String scannedData = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancelar",
        true,
        ScanMode.QR,
      );

      if (scannedData != '-1') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Escaneado: $scannedData')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al escanear: $e')),
      );
    } finally {
      setState(() {
        _isScanQrButtonPressed = false;
      });
    }
  }

  Widget _buildButton({
    required bool isPressed,
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isPressed ? Colors.white.withOpacity(0.7) : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF751aff),
                  Color(0xFFff80ff),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Bienvenido',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: _toggleUserButtonState,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: _isUserButtonPressed
                                  ? Colors.white.withOpacity(0.7)
                                  : Colors.transparent,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _username,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Saldo Actual',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '\$1847.56',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Asegúrate de mantener suficiente saldo para tus peajes.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildButton(
                          isPressed: _isHistoryButtonPressed,
                          text: 'Ver Historial',
                          icon: Icons.article,
                          onTap: _toggleHistoryButtonState,
                        ),
                        const SizedBox(width: 16),
                        _buildButton(
                          isPressed: _isQrButtonPressed,
                          text: 'Ver QR',
                          icon: Icons.qr_code,
                          onTap: _toggleQrButtonState,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildButton(
                          isPressed: _isVehiclesButtonPressed,
                          text: 'Ver Vehículos',
                          icon: Icons.directions_car,
                          onTap: _toggleVehiclesButtonState,
                        ),
                        const SizedBox(width: 16),
                        _buildButton(
                          isPressed: _isRechargeButtonPressed,
                          text: 'Recargar Saldo',
                          icon: Icons.attach_money,
                          onTap: _toggleRechargeButtonState,
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 50, // Adjust height to match other buttons
                      child: _buildButton(
                        isPressed: _isScanQrButtonPressed,
                        text: 'Escanear QR',
                        icon: Icons.qr_code_scanner,
                        onTap: _toggleScanQrButtonState,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
