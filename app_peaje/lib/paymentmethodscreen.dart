import 'package:flutter/material.dart';
import 'package:app_peaje/user.dart';

class PaymentMethodScreen extends StatefulWidget {
  final User user;

  const PaymentMethodScreen({Key? key, required this.user}) : super(key: key);

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderNameController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  bool _isCardNumberValid = false;
  bool _isExpiryDateValid = false;
  bool _isCvvValid = false;

  bool _validateCardNumber(String cardNumber) {
    return cardNumber.length == 16; // Validación básica
  }

  bool _validateExpiryDate(String expiryDate) {
    return RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$').hasMatch(expiryDate);
  }

  bool _validateCvv(String cvv) {
    return cvv.length == 3; // Validación básica
  }

  void _savePaymentMethod() {
    if (_formKey.currentState?.validate() ?? false) {
      PaymentMethod newPaymentMethod = PaymentMethod(
        cardNumber: _cardNumberController.text,
        cardHolderName: _cardHolderNameController.text,
        expiryDate: _expiryDateController.text,
        cvv: _cvvController.text,
      );

      widget.user.addPaymentMethod(
        newPaymentMethod.cardNumber,
        newPaymentMethod.cardHolderName,
        newPaymentMethod.expiryDate,
        newPaymentMethod.cvv,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Método de pago agregado con éxito.')),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFAB47BC), Color(0xFFE040FB)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Métodos de Pago',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _cardNumberController,
                      label: 'Número de Tarjeta',
                      isValid: _isCardNumberValid,
                      onChanged: (value) {
                        setState(() {
                          _isCardNumberValid = _validateCardNumber(value);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _cardHolderNameController,
                      label: 'Nombre del Titular',
                      isValid: true, // No validación específica aquí
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _expiryDateController,
                            label: 'Fecha de Expiración (MM/AA)',
                            isValid: _isExpiryDateValid,
                            onChanged: (value) {
                              setState(() {
                                _isExpiryDateValid = _validateExpiryDate(value);
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _cvvController,
                            label: 'CVV',
                            isValid: _isCvvValid,
                            onChanged: (value) {
                              setState(() {
                                _isCvvValid = _validateCvv(value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: _savePaymentMethod,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Guardar Método de Pago',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFFAB47BC),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isValid,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: TextInputType.text,
      style: const TextStyle(fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        suffixIcon: Icon(
          isValid ? Icons.check : Icons.close,
          color: isValid ? Colors.green : Colors.red,
        ),
        labelText: label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
        filled: true,
        fillColor: const Color(0xFFF0F0F0), // Color de fondo de los campos
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFAB47BC)),
        ),
      ),
    );
  }
}