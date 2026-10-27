import 'console_formatter.dart';
import 'doctor.dart';
import 'patient.dart';
import 'receptionist.dart';

/// Possible states of an appointment.
enum AppointmentStatus { scheduled, completed, cancelled }

/// A booked visit between a patient and a doctor.
/// Uses the ConsoleFormatter mixin to print its own receipt.
class Appointment with ConsoleFormatter {
  final String id;
  final Patient patient;
  final Doctor doctor;
  final String slot;
  final Receptionist bookedBy;
  AppointmentStatus status;

  Appointment(
      this.id, this.patient, this.doctor, this.slot, this.bookedBy)
      : status = AppointmentStatus.scheduled;

  /// Prints a neat confirmation receipt.
  void printReceipt() {
    divider();
    row('Appointment', id);
    row('Patient', patient.name);
    row('Doctor', '${doctor.name} (${doctor.specialty})');
    row('Time', slot);
    row('Booked by', '${bookedBy.name} (${bookedBy.deskNumber})');
    row('Status', status.name.toUpperCase());
    divider();
  }
}