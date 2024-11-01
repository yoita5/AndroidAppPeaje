import 'package:app_peaje/login_page.dart';
import 'package:app_peaje/registerScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Variables para manejar el estado de los botones
  bool _isLoginButtonPressed = false;
  bool _isRegisterButtonPressed = false;
  bool _isGoogleButtonPressed = false;

  void _handleGoogleSignIn(BuildContext context) {
    // Aquí puedes agregar la lógica para iniciar sesión con Google
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()), // Simula el inicio de sesión
    );
  }

  @override
  Widget build(BuildContext context) {
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
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Image.asset('assets/logo.png', width: 300, height: 300),
                ),
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              'Bienvenido',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            _buildButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              text: 'INICIAR SESIÓN',
              isBorderButton: true,
              isPressed: _isLoginButtonPressed,
              onPressChange: (isPressed) {
                setState(() {
                  _isLoginButtonPressed = isPressed;
                });
              },
            ),
            const SizedBox(height: 30),
            _buildButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              text: 'REGISTRARSE',
              isBorderButton: false,
              isPressed: _isRegisterButtonPressed,
              onPressChange: (isPressed) {
                setState(() {
                  _isRegisterButtonPressed = isPressed;
                });
              },
            ),
            const Spacer(),
            const Text(
              'Iniciar sesión con cuenta Google',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            _buildGoogleSignInButton(
              onTap: () => _handleGoogleSignIn(context),
              isPressed: _isGoogleButtonPressed,
              onPressChange: (isPressed) {
                setState(() {
                  _isGoogleButtonPressed = isPressed;
                });
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required void Function() onTap,
    required String text,
    required bool isBorderButton,
    required bool isPressed,
    required void Function(bool) onPressChange,
  }) {
    return GestureDetector(
      onTapDown: (_) => onPressChange(true),
      onTapUp: (_) {
        onPressChange(false);
        onTap();
      },
      onTapCancel: () => onPressChange(false),
      child: Container(
        height: 53,
        width: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: isBorderButton ? Border.all(color: Colors.white) : null,
          color: isPressed ? (isBorderButton ? Colors.white.withOpacity(0.5) : Colors.grey) : (isBorderButton ? Colors.transparent : Colors.white),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isBorderButton ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton({
    required void Function() onTap,
    required bool isPressed,
    required void Function(bool) onPressChange,
  }) {
    return GestureDetector(
      onTapDown: (_) => onPressChange(true),
      onTapUp: (_) {
        onPressChange(false);
        onTap();
      },
      onTapCancel: () => onPressChange(false),
      child: Container(
        height: 53,
        width: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/google_logo.svg', width: 30, height: 30),
              const SizedBox(width: 16),
              const Text(
                'CONTINUAR CON GOOGLE',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}