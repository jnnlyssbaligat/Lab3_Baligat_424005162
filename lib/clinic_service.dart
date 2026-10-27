import 'appointment.dart';
import 'clinic_exception.dart';
import 'console_formatter.dart';
import 'doctor.dart';
import 'patient.dart';
import 'receptionist.dart';

/// Core logic of the tracker: loading data, booking, cancelling, completing.
/// Uses the ConsoleFormatter mixin and Future-based async methods.
class ClinicService with ConsoleFormatter {
  final List<Doctor> _doctors = [];
  final List<Patient> _patients = [];
  final List<Appointment> _appointments = [];
  Receptionist? _receptionist; // front desk staff (set when data loads)
  int _counter = 0;

  // ---------------------------------------------------------------
  // ASYNC: simulates loading records from a server (2 second delay)
  // ---------------------------------------------------------------
  Future<void> loadData() async {
    info('Connecting to clinic database...');
    await Future.delayed(const Duration(seconds: 1));
    info('Loading doctors, patients and staff...');
    await Future.delayed(const Duration(seconds: 1));

    _doctors.addAll([
      Doctor('D01', 'Dr. Taylor Swift', 'General Medicine',
          ['09:00 AM', '10:00 AM', '11:00 AM']),
      Doctor('D02', 'Dr. Olivia Rodrigo', 'Pediatrics', ['01:00 PM', '02:00 PM']),
      Doctor('D03', 'Dr. Sabrina Carpenter', 'Dentistry', ['03:00 PM', '04:00 PM']),
    ]);

    _patients.addAll([
      Patient('P01', 'Alyssa Baligat', 20, '0917-123-4567'),
      Patient('P02', 'Jenna Quimora', 35, '0918-765-4321'),
    ]);

    _receptionist =
        Receptionist('R01', 'Ms. Margot Robbie', 'Front Desk 1', '8AM - 5PM');

    success('Loaded ${_doctors.length} doctors, ${_patients.length} patients '
        'and 1 receptionist.');
  }

  // ---------------------------------------------------------------
  // Lookup helper used by the menu in main.dart
  // ---------------------------------------------------------------
  Doctor findDoctor(String doctorId) {
    return _doctors.firstWhere(
      (d) => d.id == doctorId.toUpperCase(),
      orElse: () => throw ClinicException('Doctor "$doctorId" not found.'),
    );
  }

  // ---------------------------------------------------------------
  // ASYNC: register a new patient entered by the user (1 second delay)
  // ---------------------------------------------------------------
  Future<Patient> registerPatient(String name, int age, String contact) async {
    info('Saving patient record...');
    await Future.delayed(const Duration(seconds: 1));

    if (name.trim().isEmpty) {
      throw ClinicException('Patient name cannot be empty.');
    }
    if (age < 0 || age > 120) {
      throw ClinicException('Age must be between 0 and 120.');
    }

    final id = 'P${(_patients.length + 1).toString().padLeft(2, '0')}';
    final patient = Patient(id, name.trim(), age, contact.trim());
    _patients.add(patient);
    success('Registered ${patient.name} with ID $id.');
    return patient;
  }

  // ---------------------------------------------------------------
  // Display helpers
  // ---------------------------------------------------------------
  void showDoctors() {
    print('  ${'ID'.padRight(6)} ${'NAME'.padRight(20)} ${'SPECIALTY'.padRight(16)} OPEN');
    divider();
    for (final d in _doctors) {
      print('  ${d.describe()}');
    }
  }

  void showReceptionist() {
    final r = _receptionist;
    if (r == null) {
      info('No receptionist on duty.');
      return;
    }
    print('  ${'ID'.padRight(6)} ${'NAME'.padRight(20)} ${'DESK'.padRight(16)} SHIFT');
    divider();
    print('  ${r.describe()}');
  }

  void showPatients() {
    print('  ${'ID'.padRight(6)} ${'NAME'.padRight(20)} ${'AGE'.padRight(4)} CONTACT');
    divider();
    for (final p in _patients) {
      print('  ${p.describe()}');
    }
  }

  void showAppointments() {
    if (_appointments.isEmpty) {
      info('No appointments yet.');
      return;
    }
    print('  ${'ID'.padRight(6)} ${'PATIENT'.padRight(16)} ${'DOCTOR'.padRight(18)} '
        '${'TIME'.padRight(9)} STATUS');
    divider();
    for (final a in _appointments) {
      print('  ${a.id.padRight(6)} ${a.patient.name.padRight(16)} '
          '${a.doctor.name.padRight(18)} ${a.slot.padRight(9)} '
          '${a.status.name.toUpperCase()}');
    }
  }

  void showSummary() {
    int count(AppointmentStatus s) =>
        _appointments.where((a) => a.status == s).length;
    row('Scheduled', '${count(AppointmentStatus.scheduled)}');
    row('Completed', '${count(AppointmentStatus.completed)}');
    row('Cancelled', '${count(AppointmentStatus.cancelled)}');
    row('Total', '${_appointments.length}');
    final r = _receptionist;
    row('Handled by', '${r?.name ?? 'N/A'} (${r?.appointmentsHandled ?? 0} booking(s))');
  }

  // ---------------------------------------------------------------
  // ASYNC: booking (1 second delay). Throws ClinicException on failure.
  // ---------------------------------------------------------------
  Future<Appointment> bookAppointment(
      String patientId, String doctorId, String slot) async {
    info('Processing booking request...');
    await Future.delayed(const Duration(seconds: 1));

    final receptionist = _receptionist;
    if (receptionist == null) {
      throw ClinicException('Clinic data is not loaded yet.');
    }

    final patient = _patients.firstWhere(
      (p) => p.id == patientId.toUpperCase(),
      orElse: () => throw ClinicException('Patient "$patientId" not found.'),
    );
    final doctor = _doctors.firstWhere(
      (d) => d.id == doctorId.toUpperCase(),
      orElse: () => throw ClinicException('Doctor "$doctorId" not found.'),
    );

    if (!doctor.availableSlots.contains(slot)) {
      throw ClinicException('${doctor.name} is not available at $slot.');
    }

    doctor.availableSlots.remove(slot); // slot is now taken
    _counter++;
    final appt = Appointment('A${_counter.toString().padLeft(3, '0')}',
        patient, doctor, slot, receptionist);
    _appointments.add(appt);
    receptionist.recordBooking(); // receptionist handled this booking

    success('Appointment booked!');
    appt.printReceipt();
    return appt;
  }

  // ---------------------------------------------------------------
  // ASYNC: cancel an appointment and free the doctor's slot
  // ---------------------------------------------------------------
  Future<void> cancelAppointment(String appointmentId) async {
    info('Cancelling $appointmentId...');
    await Future.delayed(const Duration(seconds: 1));

    final appt = _findAppointment(appointmentId);
    if (appt.status != AppointmentStatus.scheduled) {
      throw ClinicException('$appointmentId is already ${appt.status.name}.');
    }

    appt.status = AppointmentStatus.cancelled;
    appt.doctor.availableSlots.add(appt.slot); // give the slot back
    success('$appointmentId cancelled. Slot ${appt.slot} is open again.');
  }

  // ---------------------------------------------------------------
  // ASYNC: mark a visit as done
  // ---------------------------------------------------------------
  Future<void> completeAppointment(String appointmentId) async {
    info('Completing $appointmentId...');
    await Future.delayed(const Duration(seconds: 1));

    final appt = _findAppointment(appointmentId);
    if (appt.status != AppointmentStatus.scheduled) {
      throw ClinicException('$appointmentId is already ${appt.status.name}.');
    }

    appt.status = AppointmentStatus.completed;
    success('$appointmentId marked as completed.');
  }

  Appointment _findAppointment(String id) {
    return _appointments.firstWhere(
      (a) => a.id == id.toUpperCase(),
      orElse: () => throw ClinicException('Appointment "$id" not found.'),
    );
  }
}