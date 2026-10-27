import 'person.dart';

/// INHERITANCE: Doctor extends Person.
/// A doctor has a specialty and a list of open time slots.
class Doctor extends Person {
  final String specialty;
  final List<String> availableSlots;

  // Constructor calls the parent constructor via super
  Doctor(String id, String name, this.specialty, this.availableSlots)
      : super(id, name);

  @override
  String get role => 'Doctor';

  @override
  String describe() =>
      '${id.padRight(6)} ${name.padRight(20)} ${specialty.padRight(16)} '
      '${availableSlots.length} slot(s)';
}