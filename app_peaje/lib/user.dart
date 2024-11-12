class Vehicle {
  final String licensePlate;
  final String make;

  Vehicle({
    required this.licensePlate,
    required this.make,
  });
}

class PaymentMethod {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate; // Formatted as MM/YY
  final String cvv;

  PaymentMethod({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
  });
}

class User {
  final String name;
  final String email;
  String phone; // Campo para el teléfono
  String password; // Campo para la contraseña
  double balance;
  List<PaymentMethod> paymentMethods;
  List<Vehicle> vehicles;

  User({
    required this.name,
    required this.email,
    this.phone = '', // Inicializa el teléfono
    this.password = '', // Inicializa la contraseña
    this.balance = 0.0,
    List<PaymentMethod>? paymentMethods,
    List<Vehicle>? vehicles,
  })  : paymentMethods = paymentMethods ?? [],
        vehicles = vehicles ?? [];

  // Método para actualizar el nombre, email, teléfono y contraseña
  void updateUser({
    String? newName,
    String? newEmail,
    String? newPhone,
    String? newPassword,
  }) {
    if (newName != null) {
      // Si se proporciona un nuevo nombre, se actualiza
      // Se requiere un manejo especial si name es final
      // Esto podría implicar un diseño diferente si se necesita inmutabilidad
      // Por ahora, dejaré el nombre como está.
      // name = newName;  // Descomentar si se cambia el diseño
    }
    if (newEmail != null) {
      // Se debe manejar la inmutabilidad si email es final.
      // email = newEmail;  // Descomentar si se cambia el diseño
    }
    if (newPhone != null) {
      phone = newPhone; // Actualiza el teléfono
    }
    if (newPassword != null) {
      password = newPassword; // Actualiza la contraseña
    }
  }

  // Método para agregar un método de pago
  void addPaymentMethod(String cardNumber, String cardHolderName, String expiryDate, String cvv) {
    paymentMethods.add(PaymentMethod(
      cardNumber: cardNumber,
      cardHolderName: cardHolderName,
      expiryDate: expiryDate,
      cvv: cvv,
    ));
  }

  // Método para eliminar un método de pago por número de tarjeta
  void removePaymentMethod(String cardNumber) {
    paymentMethods.removeWhere((paymentMethod) => paymentMethod.cardNumber == cardNumber);
  }

  // Método para obtener una lista de métodos de pago
  List<PaymentMethod> getPaymentMethods() {
    return paymentMethods;
  }

  // Método para agregar un vehículo
  void addVehicle(String licensePlate, String make) {
    vehicles.add(Vehicle(licensePlate: licensePlate, make: make));
  }

  // Método para eliminar un vehículo por matrícula
  void removeVehicle(String licensePlate) {
    vehicles.removeWhere((vehicle) => vehicle.licensePlate == licensePlate);
  }

  // Método para obtener una lista de vehículos
  List<Vehicle> getVehicles() {
    return vehicles;
  }
}