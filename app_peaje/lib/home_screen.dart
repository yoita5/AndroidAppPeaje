import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:app_peaje/profile_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  bool _isUserButtonPressed = false;
  bool _isHistoryButtonPressed = false;
  bool _isQrButtonPressed = false;
  bool _isRechargeButtonPressed = false;
  bool _isVehiclesButtonPressed = false;
  bool _isScanQrButtonPressed = false;

  final String _username = 'Juan Pérez';
  double _balance = 1847.56;
  String _qrImageUrl = '';
  List<Vehicle> _registeredVehicles = [];
  double? _rechargeAmount;

  bool _hasRegisteredVehicles() {
    return _registeredVehicles.isNotEmpty;
  }

  void _addNewVehicle() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddVehicleScreen(
          onVehicleAdded: (vehicle) {
            setState(() {
              _registeredVehicles.add(vehicle);
            });
          },
        ),
      ),
    );
  }

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
            children: [
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
    _showRechargeDialog();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isRechargeButtonPressed = false;
      });
    });
  }

bool _hasPaymentMethodRegistered = false; // Simularemos que el usuario no tiene un método de pago registrado

Future<void> _showRechargeDialog() async {
  final amount = await showDialog<double>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Recargar Saldo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_hasPaymentMethodRegistered)
            const Text('Debes registrar un método de pago para poder recargar tu saldo.'),
          if (_hasPaymentMethodRegistered)
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'Ingresa el monto a recargar',
              ),
              onChanged: (value) {
                // Validar y parsear el valor ingresado
                try {
                  _rechargeAmount = double.parse(value);
                } catch (e) {
                  _rechargeAmount = null;
                }
              },
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        if (_hasPaymentMethodRegistered && _rechargeAmount != null && _rechargeAmount! >= 5.0)
          ElevatedButton(
            onPressed: () {
              _rechargeBalance(_rechargeAmount!);
              Navigator.of(context).pop(_rechargeAmount);
            },
            child: const Text('Recargar'),
          ),
      ],
    ),
  );

  if (amount != null) {
    // Actualizar el saldo del usuario
    setState(() {
      _balance += amount;
    });
  }
}

Future<void> _rechargeBalance(double amount) async {
  try {
    final response = await http.post(
      Uri.parse('/api/recharge/'),
      body: {'amount': amount.toString()},
    );

    if (response.statusCode == 200) {
      final newBalance = double.parse(jsonDecode(response.body)['new_balance']);
      setState(() {
        _balance = newBalance;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saldo recargado exitosamente. Nuevo saldo: \$${_balance.toStringAsFixed(2)}'),
        ),
      );
    } else {
      // Manejar el error de la solicitud
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al recargar el saldo. Inténtalo de nuevo.')),
      );
    }
  } catch (e) {
    // Manejar cualquier otro tipo de error
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ocurrió un error. Inténtalo de nuevo más tarde.')),
    );
  }
}

  void _toggleVehiclesButtonState() {
    setState(() {
      _isVehiclesButtonPressed = true;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Vehículos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_hasRegisteredVehicles())
                const Text('Tus vehículos registrados:'),
              if (_hasRegisteredVehicles())
                Expanded(
                  child: ListView.builder(
                    itemCount: _registeredVehicles.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_registeredVehicles[index].modelo),
                        subtitle: Text(_registeredVehicles[index].placa),
                      );
                    },
                  ),
                ),
              if (!_hasRegisteredVehicles())
                const Text('No tienes vehículos registrados.'),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _addNewVehicle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_circle_outline),
                    SizedBox(width: 8),
                    Text('Agregar Vehículo'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isVehiclesButtonPressed = false;
                });
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
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
    } on PlatformException catch (e) {
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
                    Text(
                      '\$${_balance.toStringAsFixed(2)}',
                      style: const TextStyle(
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
                      height: 50,
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

class Vehicle {
  final String modelo;
  final String placa;

  Vehicle({required this.modelo, required this.placa});
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: const Center(
        child: Text('Pantalla de Perfil'),
      ),
    );
  }
}

class AddVehicleScreen extends StatefulWidget {
  final void Function(Vehicle) onVehicleAdded;

  const AddVehicleScreen({super.key, required this.onVehicleAdded});

  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();

  void _addVehicle() {
    final modelo = _modelController.text.trim();
    final placa = _plateController.text.trim();

    if (modelo.isNotEmpty && placa.isNotEmpty) {
      final newVehicle = Vehicle(modelo: modelo, placa: placa);
      widget.onVehicleAdded(newVehicle);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa el modelo y la placa del vehículo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Vehículo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingresa los detalles del vehículo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(
                labelText: 'Marca',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _plateController,
              decoration: const InputDecoration(
                labelText: 'Placa',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _addVehicle,
              child: const Text('Agregar Vehículo'),
            ),
          ],
        ),
      ),
    );
  }
}