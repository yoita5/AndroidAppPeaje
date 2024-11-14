class Transaction {
  final double amount;
  final DateTime dateTime;
  final String type; // 'Recharge' or 'Charge'

  Transaction(this.amount, this.type) : dateTime = DateTime.now();
}

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
  List<Transaction> transactions; // Lista de transacciones

  User({
    required this.name,
    required this.email,
    this.phone = '', // Inicializa el teléfono
    this.password = '', // Inicializa la contraseña
    this.balance = 0.0,
    List<PaymentMethod>? paymentMethods,
    List<Vehicle>? vehicles,
  })  : paymentMethods = paymentMethods ?? [],
        vehicles = vehicles ?? [],
        transactions = []; // Inicializa la lista de transacciones

  // Método para actualizar el nombre, email, teléfono y contraseña
  void updateUser({
    String? newName,
    String? newEmail,
    String? newPhone,
    String? newPassword,
  }) {
    if (newName != null) {
      // Se requiere un manejo especial si name es final
      // Por ahora, dejaremos el nombre como está.
    }
    if (newEmail != null) {
      // Manejo de inmutabilidad si email es final.
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

  // Método para agregar una transacción
  void addTransaction(double amount, DateTime dateTime, String type) {
    transactions.add(Transaction(amount, type)); // Agrega la transacción con tipo
  }

  // Método para obtener una lista de transacciones
  List<Transaction> getTransactions() {
    return transactions;
  }
}