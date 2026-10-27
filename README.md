# Lab 3: The Dart App Simulator (Clinic Appointment Tracker)

**Name:** Jenna Alyssa Q. Baligat

**Student No.:** 424005162

**Course:** BSIT 3.8, National Teachers College

A console-based Dart OOP app with asynchronous features that simulates a
clinic booking, completing, and cancelling patient appointments.

## Requirements Coverage
| Requirement | Where |
|---|---|
| 2+ classes with inheritance | `Doctor`, `Patient`, `Receptionist` extend `Person` |
| Abstract class | `Person` (`lib/person.dart`) |
| Mixin | `ConsoleFormatter` (`lib/console_formatter.dart`) used by `ClinicService`, `Appointment` |
| Constructors & methods | All classes |
| Future + simulated delay | `loadData`, `bookAppointment`, `cancelAppointment`, `completeAppointment` |
| async/await in main() | `bin/main.dart` |
| try-catch | `bin/main.dart` + custom `ClinicException` |

## How it Works
After the data loads, a menu lets the user register patients, book, view,
complete and cancel appointments by typing their own input.
Invalid input is handled with try-catch and a custom `ClinicException`.

## How to Run
```
dart pub get
dart run bin/main.dart
```

## Structure
```
bin/main.dart               entry point + interactive menu
lib/person.dart             abstract class
lib/doctor.dart             Doctor (inherits Person)
lib/patient.dart            Patient (inherits Person)
lib/receptionist.dart       Receptionist (inherits Person)
lib/appointment.dart        Appointment + status enum
lib/console_formatter.dart  mixin (lines, banners, rows)
lib/clinic_service.dart     async booking logic
lib/clinic_exception.dart   custom exception
```
