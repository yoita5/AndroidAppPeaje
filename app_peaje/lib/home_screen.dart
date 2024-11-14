import 'package:app_peaje/profile_screen.dart';
import 'package:app_peaje/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:app_peaje/VehicleListScreen.dart';
import 'paymentmethodscreen.dart';
class MainHomeScreen extends StatefulWidget {
  final User user;

  const MainHomeScreen({super.key, required this.user});

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
  final bool _isAddPaymentMethodButtonPressed = false;
  bool _isAddVehicleButtonPressed = false;

  static const double _minRechargeAmount = 5.0;
  static const String _qrCodeApiBaseUrl = 'https://api.qrserver.com/v1/create-qr-code/';
  static const Color _qrCodeBorderColor = Color(0xFFff6666);

  String _qrImageUrl = ''; // Variable to store the QR code image URL

  void _toggleUserButtonState() {
    setState(() {
      _isUserButtonPressed = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(user: widget.user)),
    ).then((_) {
      setState(() {
        _isUserButtonPressed = false;
      });
    });
  }

  void _toggleHistoryButtonState() async {
  setState(() {
    _isHistoryButtonPressed = true;
  });

  // Mostrar el historial en un diálogo
  await _showTransactionHistoryDialog();

  setState(() {
    _isHistoryButtonPressed = false;
  });
}

Future<void> _showTransactionHistoryDialog() async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Historial de Transacciones'),
        content: SizedBox(
          width: 300, // Puedes ajustar el ancho
          height: 400, // Puedes ajustar la altura
          child: ListView.builder(
            itemCount: widget.user.transactions.length,
            itemBuilder: (context, index) {
              final transaction = widget.user.transactions[index];
              return ListTile(
                title: Text('Transacción: \$${transaction.amount.toStringAsFixed(2)}'),
                subtitle: Text('${transaction.dateTime.toLocal()}'),
              );
            },
          ),
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

  void _toggleQrButtonState() async {
    setState(() {
      _isQrButtonPressed = true;
    });
    String uniqueQrData = 'usuario:${widget.user.name}';
    
    String qrCodeImageUrl = await _generateQrCodeImage(uniqueQrData);
    
    setState(() {
      _qrImageUrl = qrCodeImageUrl;
    });
    setState(() {
      _isQrButtonPressed = false;
    });

    _showQrDialog();
  }

  Future<String> _generateQrCodeImage(String data) async {
    return '$_qrCodeApiBaseUrl?data=$data&size=200x200';
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

  void _toggleRechargeButtonState() async {
  setState(() {
    _isRechargeButtonPressed = true;
  });

  // Verifica si el usuario tiene al menos un método de pago
  if (widget.user.getPaymentMethods().isEmpty) {
    // Muestra un diálogo que indica que se requiere un método de pago
    await _showAddPaymentMethodRequiredDialog();
  } else {
    await _showRechargeDialog();
  }

  setState(() {
    _isRechargeButtonPressed = false;
  });
}

Future<void> _showAddPaymentMethodRequiredDialog() async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Método de Pago Requerido'),
        content: const Text('Para recargar saldo, primero debe agregar un método de pago.'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Agregar Método de Pago'),
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
              _navigateToAddPaymentMethodScreen(); // Navega a la pantalla para agregar método de pago
            },
          ),
        ],
      );
    },
  );
}

void _navigateToAddPaymentMethodScreen() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PaymentMethodScreen(user: widget.user)), // Navega a la pantalla para agregar método de pago
  );
}

Future<void> _showRechargeDialog() async {
  double rechargeAmount = 0.0;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Recargar Saldo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ingrese el monto a recargar:'),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                rechargeAmount = double.tryParse(value) ?? 0.0;
              },
              decoration: const InputDecoration(
                hintText: 'Monto (mínimo \$$_minRechargeAmount)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Recargar'),
            onPressed: () {
              if (rechargeAmount >= _minRechargeAmount) {
                setState(() {
                  widget.user.balance += rechargeAmount; // Actualiza el saldo
                  widget.user.addTransaction(rechargeAmount, DateTime.now(), 'Recharge'); // Agrega la transacción
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Recarga de \$${rechargeAmount.toStringAsFixed(2)} realizada. Saldo actual: \$${widget.user.balance.toStringAsFixed(2)}')),
                );
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('El monto mínimo de recarga es \$$_minRechargeAmount')),
                );
              }
            },
          ),
        ],
      );
    },
  );
}

void _toggleVehiclesButtonState() {
  setState(() {
    _isVehiclesButtonPressed = true;
  });

  if (widget.user.vehicles.isEmpty) {
    _showAddVehicleDialog();
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleListScreen(
          vehicles: widget.user.vehicles,
          onAddVehicle: (licensePlate, make) {
            widget.user.addVehicle(licensePlate, make);
            setState(() {}); // Actualiza el estado para reflejar el cambio
          },
          onRemoveVehicle: _onRemoveVehicle, // Pasa la función para eliminar vehículos
        ),
      ),
    );
  }

  setState(() {
    _isVehiclesButtonPressed = false;
  });
}

void _onRemoveVehicle(String licensePlate) {
  widget.user.removeVehicle(licensePlate); // Usa el método de la clase User
  setState(() {}); // Actualiza la interfaz de usuario
}

void _showAddVehicleDialog() async {
    setState(() {
      _isAddVehicleButtonPressed = true;
    });

    String? licensePlate;
    String? make;
    List<String> makes = [
      'Toyota', 'Honda', 'Ford', 'Chevrolet', 'Volkswagen', 'BMW', 'Mercedes-Benz',
      'Audi', 'Nissan', 'Hyundai', 'Kia', 'Subaru', 'Mazda', 'Dodge', 'Chrysler',
      'Jeep', 'Buick', 'GMC', 'Porsche', 'Lexus', 'Infinity', 'Land Rover', 'Jaguar',
      'Fiat', 'Volvo', 'Mitsubishi', 'Tesla', 'Acura', 'Lincoln', 'Mini', 'Alfa Romeo',
      'Ram', 'Genesis', 'Scion', 'Rover', 'Hummer', 'Smart', 'Peugeot', 'Renault',
      'Citroën', 'Skoda', 'Seat', 'Opel', 'Saab', 'Lancia', 'Tata', 'Mahindra',
      'Changan', 'Geely', 'BYD'
    ];

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Vehículo'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Ingrese los detalles de su vehículo:'),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    licensePlate = value.isNotEmpty ? value : null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Placa',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != null && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                      return null;
                    } else {
                      return 'La placa debe contener solo letras y números.';
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: make,
                  onChanged: (value) {
                    make = value;
                  },
                  items: makes.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    hintText: 'Marca',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Seleccione una marca.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Para eliminar un vehiculo guardado deslice hacia la derecha',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  if (licensePlate != null && make != null) {
                    widget.user.addVehicle(licensePlate!, make!); // Agrega el vehículo
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        );
      },
    );

    setState(() {
      _isAddVehicleButtonPressed = false;
    });
}

  void _toggleScanQrButtonState() async {
    setState(() {
      _isScanQrButtonPressed = true;
    });

    try {
      String scannedData = await FlutterBarcodeScanner.scanBarcode(
        _qrCodeBorderColor.value.toRadixString(16),
        'Cancelar',
        true,
        ScanMode.QR,
      );

      if (scannedData != '-1') {
        _processScannedQrCode(scannedData);
      }
    } catch (e, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al escanear código QR: $e')),
      );
      print('Error al escanear código QR: $e');
      print('Stacktrace: $stackTrace');
    } finally {
      setState(() {
        _isScanQrButtonPressed = false;
      });
    }
  }

void _processScannedQrCode(String scannedData) {
  List<String> parts = scannedData.split(':');
  if (parts.length == 2 && parts[0] == 'usuario') {
    String username = parts[1];
    double chargeAmount = _minRechargeAmount; // Importe del cobro por peaje

    if (widget.user.balance >= chargeAmount) {
      setState(() {
        widget.user.balance -= chargeAmount;
        widget.user.addTransaction(-chargeAmount, DateTime.now(), 'Charge'); // Agrega la transacción
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cobro de \$$chargeAmount realizado. Saldo actual: \$${widget.user.balance.toStringAsFixed(2)}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay saldo suficiente para realizar el cobro.')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Código QR inválido')),
    );
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
                                  widget.user.name,
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
                      '\$${widget.user.balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.user.balance == 0.0)
                      const Text(
                        'No hay saldo disponible',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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