import 'package:flutter/material.dart';
import '../../data/repository.dart';
import '../../data/models.dart';
import 'student_form_screen.dart';


class StudentViewScreen extends StatelessWidget {
  final int studentId;
  const StudentViewScreen({super.key, required this.studentId});

  Program? _programOf(int programId) {
    final items = AppRepositories.programs.items;
    try {
      return items.firstWhere((p) => p.id == programId);
    } catch (_) {
      return null;
    }
  }

  String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final Student? s = AppRepositories.students.items
        .where((x) => x.id == studentId)
        .cast<Student?>()
        .firstWhere((e) => true, orElse: () => null);

    if (s == null) {
      return const Scaffold(
        body: Center(child: Text('Student not found')),
      );
    }

    final p = _programOf(s.programId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Student ${s.studentNo}'),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StudentFormScreen(editId: s.id)),
            ),
          ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Delete Student'),
                  content: Text(
                      'Are you sure you want to delete ${s.fullName} (${s.studentNo})?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: const Text('Cancel')),
                    FilledButton(
                        onPressed: () => Navigator.pop(c, true),
                        child: const Text('Delete')),
                  ],
                ),
              );
              if (ok == true) {
                await AppRepositories.students.delete(s.id);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    child: Text(
                      s.firstName.isNotEmpty ? s.firstName[0] : '?',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.fullName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('Student No: ${s.studentNo}'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              _kv('Program', p == null ? 'N/A' : '${p.code} — ${p.name}'),
              _kv('Year Level', 'Y${s.yearLevel}'),
              _kv('Status', s.status),
              _kv('Date Enrolled', _fmtDate(s.dateEnrolled)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600))),
          const SizedBox(width: 8),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }
}