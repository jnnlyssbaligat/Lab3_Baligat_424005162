import 'person.dart';

/// INHERITANCE: Receptionist extends Person.
/// Works the front desk and handles every booking made in the clinic.
class Receptionist extends Person {
  final String deskNumber;
  final String shift;
  int appointmentsHandled = 0;

  // Constructor calls the parent constructor via super
  Receptionist(String id, String name, this.deskNumber, this.shift)
      : super(id, name);

  @override
  String get role => 'Receptionist';

  /// Called each time this receptionist books an appointment.
  void recordBooking() {
    appointmentsHandled++;
  }

  @override
  String describe() =>
      '${id.padRight(6)} ${name.padRight(20)} ${deskNumber.padRight(16)} $shift';
}