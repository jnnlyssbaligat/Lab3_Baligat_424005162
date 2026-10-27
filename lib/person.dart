/// ABSTRACT CLASS: the blueprint for everyone in the clinic.
/// It cannot be instantiated directly; subclasses must implement
/// [role] and [describe].
abstract class Person {
  final String id;
  final String name;

  // Constructor
  Person(this.id, this.name);

  /// Label for this kind of person (e.g. "Doctor", "Patient").
  String get role;

  /// One-line summary used in listings.
  String describe();
}