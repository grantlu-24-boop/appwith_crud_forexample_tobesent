import 'package:flutter/material.dart';
import '../../data/repository.dart';
import 'student_form_screen.dart';
import 'student_view_screen.dart';



class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final studentsRepo = AppRepositories.students;
  final programsRepo = AppRepositories.programs;
  String _q = '';

  @override
  void initState() {
    super.initState();
    studentsRepo.addListener(_refresh);
    programsRepo.addListener(_refresh);
  }

  @override
  void dispose() {
    studentsRepo.removeListener(_refresh);
    programsRepo.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  String _programCodeOf(int programId) {
    final p = programsRepo.items.where((x) => x.id == programId);
    return p.isEmpty ? 'N/A' : p.first.code;
  }

  @override
  Widget build(BuildContext context) {
    final all = studentsRepo.items;
    final items = _q.isEmpty
        ? all
        : all.where((s) {
      final q = _q.toLowerCase();
      return s.studentNo.toLowerCase().contains(q) ||
          s.firstName.toLowerCase().contains(q) ||
          s.lastName.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Programs',
            icon: const Icon(Icons.school_outlined),
            onPressed: () => Navigator.pushNamed(context, '/programs'),
          ),
        ],
      ),
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: 1,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search student (no/name)…',
                ),
                onChanged: (v) => setState(() => _q = v),
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text('No students yet'))
                  : ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 0),
                itemBuilder: (context, i) {
                  final s = items[i];
                  final code = _programCodeOf(s.programId);
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        s.firstName.isNotEmpty ? s.firstName[0] : '?',
                      ),
                    ),
                    title: Text('${s.studentNo} — ${s.fullName}'),
                    subtitle: Text(
                        'Program: $code • Y${s.yearLevel} • ${s.status}'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            StudentViewScreen(studentId: s.id),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              StudentFormScreen(editId: s.id),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add Student'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StudentFormScreen()),
        ),
      ),
    );
  }
}