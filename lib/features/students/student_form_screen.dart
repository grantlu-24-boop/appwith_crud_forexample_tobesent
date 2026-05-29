import 'package:flutter/material.dart';
import '../../data/repository.dart';
import '../../data/models.dart';

class StudentFormScreen extends StatefulWidget {
  final int? editId;
  const StudentFormScreen({super.key, this.editId});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _form = GlobalKey<FormState>();
  final studentsRepo = AppRepositories.students;
  final programsRepo = AppRepositories.programs;

  // Controllers
  final _studentNo = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _yearLevel = TextEditingController();
  final _dateEnrolledText = TextEditingController();

  // Selectors
  int? _programId;
  String _status = 'active';
  DateTime _dateEnrolled = DateTime.now();

  double _opacity = 0;

  Student? get editing => widget.editId == null
      ? null
      : AppRepositories.students.items.firstWhere((s) => s.id == widget.editId);

  @override
  void initState() {
    super.initState();
    // Seed edit values
    if (editing != null) {
      final s = editing!;
      _studentNo.text = s.studentNo;
      _firstName.text = s.firstName;
      _lastName.text = s.lastName;
      _yearLevel.text = s.yearLevel.toString();
      _programId = s.programId;
      _status = s.status;
      _dateEnrolled = s.dateEnrolled;
    } else {
      // default to first program if available
      if (AppRepositories.programs.items.isNotEmpty) {
        _programId = AppRepositories.programs.items.first.id;
      }
    }
    _dateEnrolledText.text = _fmtDate(_dateEnrolled);

    // Fade in animation
    Future.delayed(
      const Duration(milliseconds: 120),
          () => mounted ? setState(() => _opacity = 1) : null,
    );
  }

  @override
  void dispose() {
    _studentNo.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _yearLevel.dispose();
    _dateEnrolledText.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateEnrolled,
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime(2100, 12, 31),
    );
    if (picked != null) {
      setState(() {
        _dateEnrolled = picked;
        _dateEnrolledText.text = _fmtDate(picked);
      });
    }
  }

  Future<void> _save() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    if (_programId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add/select a Program first.')),
      );
      return;
    }

    final year = int.parse(_yearLevel.text);

    if (editing == null) {
      await AppRepositories.students.create(
        studentNo: _studentNo.text,
        firstName: _firstName.text,
        lastName: _lastName.text,
        programId: _programId!,
        yearLevel: year,
        status: _status,
        dateEnrolled: _dateEnrolled,
      );
    } else {
      await AppRepositories.students.update(
        editing!.copyWith(
          studentNo: _studentNo.text,
          firstName: _firstName.text,
          lastName: _lastName.text,
          programId: _programId!,
          yearLevel: year,
          status: _status,
          dateEnrolled: _dateEnrolled,
        ),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final uniquePrograms = programsRepo.items.toSet().toList();
    final isEdit = editing != null;
    final programs = AppRepositories.programs.items;
    final programItems = List.of(programs);

    if (isEdit &&
        _programId != null &&
        !programItems.any((p) => p.id == _programId)) {
      // FIX: Use firstWhere to find the missing program from the repository's items list.
      // Use a try-catch block or firstWhereOrNull to handle cases where the item might truly not exist.
      try {
        final missingProgram = AppRepositories.programs.items.firstWhere((p) => p.id == _programId);
        programItems.add(missingProgram);
      } catch (e) {
        // This can happen if the student's program was permanently deleted.
        // In this case, we can't add it to the list, and _programId will be invalid.
        // The validator will correctly prompt the user to select a new program.
        print('Could not find program with ID $_programId in the repository.');
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Student' : 'Add Student')),
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: _opacity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  controller: _studentNo,
                  decoration: const InputDecoration(
                    labelText: 'Student No (e.g., 2025-0001)',
                  ),
                  validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _firstName,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _lastName,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: _programId,
                  decoration: const InputDecoration(
                    labelText: 'Program',
                    border: OutlineInputBorder(),
                  ),
                  items: uniquePrograms.map((program) {
                    return DropdownMenuItem<int>(
                      value: program.id,
                      child: Text(program.code),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _programId = value;
                    });
                  },
                  validator: (value) => value == null ? 'Program is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _yearLevel,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Year Level (1..5)',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    final n = int.tryParse(v);
                    if (n == null) return 'Enter a number';
                    if (n < 1 || n > 5) return 'Must be 1..5';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  items: const [
                    DropdownMenuItem(value: 'active', child: Text('active')),
                    DropdownMenuItem(
                      value: 'inactive',
                      child: Text('inactive'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _status = v ?? 'active'),
                  decoration: const InputDecoration(labelText: 'Status'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dateEnrolledText,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Date Enrolled',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: Text(isEdit ? 'Save Changes' : 'Create Student'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}