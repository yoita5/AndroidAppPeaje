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
  double balance;
  List<PaymentMethod> paymentMethods; // List to store payment methods
  List<Vehicle> vehicles; // List to store vehicles

  User({
    required this.name,
    required this.email,
    this.balance = 0.0,
    List<PaymentMethod>? paymentMethods, // Accepts a list of payment methods as an optional parameter
    List<Vehicle>? vehicles, // Accepts a list of vehicles as an optional parameter
  })  : paymentMethods = paymentMethods ?? [], // Initializes paymentMethods to an empty list if null
        vehicles = vehicles ?? []; // Initializes vehicles to an empty list if null

  // Method to add a payment method
  void addPaymentMethod(String cardNumber, String cardHolderName, String expiryDate, String cvv) {
    paymentMethods.add(PaymentMethod(
      cardNumber: cardNumber,
      cardHolderName: cardHolderName,
      expiryDate: expiryDate,
      cvv: cvv,
    ));
  }

  // Method to remove a payment method by card number
  void removePaymentMethod(String cardNumber) {
    paymentMethods.removeWhere((paymentMethod) => paymentMethod.cardNumber == cardNumber);
  }

  // Method to get a list of payment methods
  List<PaymentMethod> getPaymentMethods() {
    return paymentMethods;
  }

  // Method to add a vehicle
  void addVehicle(String licensePlate, String make) {
    vehicles.add(Vehicle(licensePlate: licensePlate, make: make));
  }

  // Method to remove a vehicle by license plate
  void removeVehicle(String licensePlate) {
    vehicles.removeWhere((vehicle) => vehicle.licensePlate == licensePlate);
  }

  // Method to get a list of vehicles
  List<Vehicle> getVehicles() {
    return vehicles;
  }
}