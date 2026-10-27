import 'dart:io';

import 'package:lab3_baligat_424005162/clinic_exception.dart';
import 'package:lab3_baligat_424005162/clinic_service.dart';
import 'package:lab3_baligat_424005162/console_formatter.dart';

/// Prompts the user and returns what they typed (trimmed).
/// If input ends (Ctrl+D / Ctrl+Z), it returns '0' so the menu exits cleanly.
String ask(String label) {
  stdout.write('  $label: ');
  return (stdin.readLineSync() ?? '0').trim();
}

/// Prints the main menu.
void showMenu() {
  print('');
  print('=' * kWidth);
  print('  MAIN MENU');
  print('-' * kWidth);
  print('  [1] View Doctors');
  print('  [2] View Patients');
  print('  [3] Register New Patient');
  print('  [4] Book an Appointment');
  print('  [5] View All Appointments');
  print('  [6] Complete an Appointment');
  print('  [7] Cancel an Appointment');
  print('  [8] View Summary');
  print('  [0] Exit');
  print('-' * kWidth);
}

/// Entry point. async + await are used correctly in main().
Future<void> main() async {
  final clinic = ClinicService();

  clinic.banner('Clinic Appointment Tracker');

  try {
    // Load data first (simulated delay)
    clinic.section('LOADING CLINIC DATA');
    await clinic.loadData();

    // Menu loop: keeps running until the user chooses 0
    var running = true;
    while (running) {
      showMenu();
      final choice = ask('Enter your choice');

      // Each action has its own try-catch so a mistake never crashes the app
      try {
        switch (choice) {
          case '1':
            clinic.section('DOCTORS');
            clinic.showDoctors();
            break;

          case '2':
            clinic.section('PATIENTS');
            clinic.showPatients();
            break;

          case '3':
            clinic.section('REGISTER NEW PATIENT');
            final name = ask('Full Name');
            final age = int.tryParse(ask('Age'));
            if (age == null) {
              throw ClinicException('Age must be a number.');
            }
            final contact = ask('Contact Number');
            await clinic.registerPatient(name, age, contact);
            break;

          case '4':
            clinic.section('BOOK AN APPOINTMENT');
            clinic.showPatients();
            final patientId = ask('Enter Patient ID (e.g. P01)');

            print('');
            clinic.showDoctors();
            final doctorId = ask('Enter Doctor ID (e.g. D01)');

            // Show this doctor's open time slots as a numbered list
            final doctor = clinic.findDoctor(doctorId);
            final slots = doctor.availableSlots;
            if (slots.isEmpty) {
              throw ClinicException('${doctor.name} has no open slots.');
            }
            print('');
            print('  Open slots for ${doctor.name}:');
            for (var i = 0; i < slots.length; i++) {
              print('    [${i + 1}] ${slots[i]}');
            }
            final slotNo = int.tryParse(ask('Choose a time slot number'));
            if (slotNo == null || slotNo < 1 || slotNo > slots.length) {
              throw ClinicException('Invalid time slot choice.');
            }

            await clinic.bookAppointment(patientId, doctorId, slots[slotNo - 1]);
            break;

          case '5':
            clinic.section('APPOINTMENT LIST');
            clinic.showAppointments();
            break;

          case '6':
            clinic.section('COMPLETE AN APPOINTMENT');
            clinic.showAppointments();
            await clinic.completeAppointment(ask('Enter Appointment ID (e.g. A001)'));
            break;

          case '7':
            clinic.section('CANCEL AN APPOINTMENT');
            clinic.showAppointments();
            await clinic.cancelAppointment(ask('Enter Appointment ID (e.g. A001)'));
            break;

          case '8':
            clinic.section('SUMMARY');
            clinic.showSummary();
            break;

          case '0':
            running = false;
            break;

          default:
            clinic.error('Invalid choice. Please pick a number from the menu.');
        }
      } on ClinicException catch (e) {
        // Expected problems: wrong ID, slot taken, bad input, etc.
        clinic.error(e.message);
      }
    }
  } catch (e) {
    // Safety net for anything unexpected
    clinic.error('Unexpected Error: $e');
  } finally {
    print('');
    print('=' * kWidth);
    print(clinic.center('Session ended. Thank you!'));
    print('=' * kWidth);
  }
}