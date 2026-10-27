import 'person.dart';

/// INHERITANCE: Patient extends Person.
class Patient extends Person {
  final int age;
  final String contact;

  Patient(String id, String name, this.age, this.contact) : super(id, name);

  @override
  String get role => 'Patient';

  @override
  String describe() =>
      '${id.padRight(6)} ${name.padRight(20)} ${age.toString().padRight(4)} $contact';
}