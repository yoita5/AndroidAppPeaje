import 'package:flutter/material.dart';
import 'package:app_peaje/login_page.dart';
import 'package:app_peaje/registerScreen.dart';
import 'package:app_peaje/welcomeScreen.dart';
import 'package:app_peaje/home_screen.dart' as home_screen;
import 'package:flutter_svg/flutter_svg.dart'; // Importar flutter_svg
import 'package:app_peaje/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Crea un objeto User de ejemplo
    final myUser = User(name: 'Juan Perez', email: 'juan.perez@example.com', balance: 1847.56,);

    return MaterialApp(
      title: 'App Peaje',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterScreen(),
        '/homepage': (context) => home_screen.MainHomeScreen(user: myUser),
      },
    );
  }
}

class GoogleSignInButton extends StatefulWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
  });

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isButtonPressed = true),
      onTapUp: (_) => setState(() => _isButtonPressed = false),
      onTapCancel: () => setState(() => _isButtonPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 218),
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: _isButtonPressed
                ? const Color(0x1F1f1f1f)
                : const Color(0xFF747775),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: _isButtonPressed
              ? null
              : [
                  BoxShadow(
                    color: const Color(0x4D3C4047)
                        .withOpacity(_isButtonPressed ? 0 : 0.3),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: const Color(0x1F3C4047)
                        .withOpacity(_isButtonPressed ? 0 : 0.15),
                    offset: const Offset(0, 1),
                    blurRadius: 3,
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _GoogleSignInIcon(),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'CONTINUAR CON GOOGLE',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.25,
                    color: Color(0xFF1F1F1F),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleSignInIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: SvgPicture.asset(
        'google_logo.svg', // Ruta del archivo SVG
        fit: BoxFit.contain,
      ),
    );
  }
}