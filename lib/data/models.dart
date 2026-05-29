import 'package:flutter/foundation.dart';

@immutable
class Program {
  final int id;
  final String code;
  final String name;
  final String department;
  final String status;

  const Program({
    required this.id,
    required this.code,
    required this.name,
    required this.department,
    required this.status,
  });

  Program copyWith({
    int? id,
    String? code,
    String? name,
    String? department,
    String? status,
  }) {
    return Program(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      department: department ?? this.department,
      status: status ?? this.status,
    );
  }

  @override
  String toString() => 'Program($code • $name • $department)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Program && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class Student {
  final int id;
  final String studentNo;
  final String firstName;
  final String lastName;
  final int programId; // FK → Program.id
  final int yearLevel; // 1..5
  final String status; // active/inactive
  final DateTime dateEnrolled;

  const Student({
    required this.id,
    required this.studentNo,
    required this.firstName,
    required this.lastName,
    required this.programId,
    required this.yearLevel,
    required this.status,
    required this.dateEnrolled,
  });

  Student copyWith({
    int? id,
    String? studentNo,
    String? firstName,
    String? lastName,
    int? programId,
    int? yearLevel,
    String? status,
    DateTime? dateEnrolled,
  }) {
    return Student(
      id: id ?? this.id,
      studentNo: studentNo ?? this.studentNo,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      programId: programId ?? this.programId,
      yearLevel: yearLevel ?? this.yearLevel,
      status: status ?? this.status,
      dateEnrolled: dateEnrolled ?? this.dateEnrolled,
    );
  }

  String get fullName => '$lastName, $firstName';

  @override
  String toString() => 'Student($studentNo • $fullName • program:$programId)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Student && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}