/// Custom exception thrown when a clinic operation fails
/// (slot taken, unknown doctor/patient, bad appointment ID, etc.).
class ClinicException implements Exception {
  final String message;

  ClinicException(this.message);

  @override
  String toString() => 'ClinicException: $message';
}