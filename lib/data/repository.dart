import 'dart:async';
import 'package:flutter/foundation.dart';
import 'models.dart';
import 'package:collection/collection.dart';


int _idCounter = 0;
int _nextId() => ++_idCounter;


/// Base class for common list notifiers
class _NotifierList<T> extends ChangeNotifier {
  final List<T> _items;
  _NotifierList([List<T>? seed]) : _items = List.of(seed ?? []);

  List<T> get items => List.unmodifiable(_items);

  void setItems(Iterable<T> values) {
    _items
      ..clear()
      ..addAll(values);
    notifyListeners();
  }

  void addItem(T value) {
    _items.add(value);
    notifyListeners();
  }

  void replaceWhere(bool Function(T e) test, T newValue) {
    final idx = _items.indexWhere(test);
    if (idx != -1) {
      _items[idx] = newValue;
      notifyListeners();
    }
  }

  void removeWhere(bool Function(T e) test) {
    _items.removeWhere(test);
    notifyListeners();
  }
}

/// PROGRAM REPOSITORY
class ProgramRepository extends _NotifierList<Program> {
  ProgramRepository({List<Program>? seed}) : super(seed);

  Future<List<Program>> getAll() async => items;

  Future<Program?> getById(int id) async =>
      items.firstWhereOrNull((p) => p.id == id);

  Future<Program> create({
    required String code,
    required String name,
    required String department,
    required String status,
  }) async {
    final program = Program(
      id: _nextId(),
      code: code.trim(),
      name: name.trim(),
      department: department.trim(),
      status: status.trim(),
    );
    addItem(program);
    return program;
  }

  Future<bool> update(Program updated) async {
    if (await getById(updated.id) == null) return false;
    replaceWhere((p) => p.id == updated.id, updated);
    return true;
  }

  Future<bool> delete(int id) async {
    final before = items.length;
    removeWhere((p) => p.id == id);
    return items.length != before;
  }

  /// Convenience for search/filter
  Future<List<Program>> search(String query) async {
    final q = query.toLowerCase();
    return items.where((p) {
      return p.code.toLowerCase().contains(q) ||
          p.name.toLowerCase().contains(q) ||
          p.department.toLowerCase().contains(q);
    }).toList();
  }
}

/// STUDENT REPOSITORY
class StudentRepository extends _NotifierList<Student> {
  StudentRepository({List<Student>? seed}) : super(seed);

  Future<List<Student>> getAll() async => items;

  Future<Student?> getById(int id) async =>
      items.firstWhereOrNull((s) => s.id == id);

  Future<List<Student>> byProgram(int programId) async =>
      items.where((s) => s.programId == programId).toList();

  Future<Student> create({
    required String studentNo,
    required String firstName,
    required String lastName,
    required int programId,
    required int yearLevel,
    required String status,
    required DateTime dateEnrolled,
  }) async {
    final student = Student(
      id: _nextId(),
      studentNo: studentNo.trim(),
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      programId: programId,
      yearLevel: yearLevel,
      status: status.trim(),
      dateEnrolled: dateEnrolled,
    );
    addItem(student);
    return student;
  }

  Future<bool> update(Student updated) async {
    if (await getById(updated.id) == null) return false;
    replaceWhere((s) => s.id == updated.id, updated);
    return true;
  }

  Future<bool> delete(int id) async {
    final before = items.length;
    removeWhere((s) => s.id == id);
    return items.length != before;
  }

  Future<List<Student>> search(String query) async {
    final q = query.toLowerCase();
    return items.where((s) {
      return s.studentNo.toLowerCase().contains(q) ||
          s.firstName.toLowerCase().contains(q) ||
          s.lastName.toLowerCase().contains(q);
    }).toList();
  }
}

/// A very simple in-memory "db" holder you can access anywhere.
class AppRepositories {
  AppRepositories._();

  static final programs = ProgramRepository(
    seed: [
      Program(
        id: _nextId(),
        code: 'BSIT',
        name: 'BS Information Technology',
        department: 'CCS',
        status: 'active',
      ),
      Program(
        id: _nextId(),
        code: 'BSCS',
        name: 'BS Computer Science',
        department: 'CCS',
        status: 'active',
      ),
    ],
  );

  static final students = StudentRepository(
    seed: [
      Student(
        id: _nextId(),
        studentNo: '2025-0001',
        firstName: 'Ana',
        lastName: 'Reyes',
        programId: programs.items.first.id,
        yearLevel: 3,
        status: 'active',
        dateEnrolled: DateTime(2023, 6, 15),
      ),
    ],
  );
}