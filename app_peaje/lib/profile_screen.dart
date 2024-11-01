import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings screen
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF751aff),
              Color(0xFF9c33ff),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/default_profile.png'),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Usuario Ejemplo',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'usuario@ejemplo.com',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32.0),
            CustomButton(
              title: 'Detalles de Facturación',
              icon: Icons.wallet,
              onTap: () {
                // Navigate to billing details
              },
            ),
            CustomButton(
              title: 'Gestión de Usuarios',
              icon: Icons.person_outline,
              onTap: () {
                // Navigate to user management
              },
            ),
            CustomButton(
              title: 'Información',
              icon: Icons.info_outline,
              onTap: () {
                // Navigate to information
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Log out
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text('Cerrar Sesión'),
                ),
                IconButton(
                  onPressed: () {
                    _showDeleteAccountDialog(context);
                  },
                  icon: const Icon(
                    Icons.person_remove,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Estás seguro?'),
          content: const Text('¿Deseas eliminar tu cuenta?'),
          actions: [
            TextButton(
              onPressed: () {
                // Code to delete account
                Navigator.of(context).pop();
              },
              child: const Text('Sí', style: TextStyle(color: Color(0xFF751aff))),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No', style: TextStyle(color: Color(0xFF751aff))),
            ),
          ],
        );
      },
    );
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_right,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}