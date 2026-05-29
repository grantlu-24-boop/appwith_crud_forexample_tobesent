import 'package:flutter/material.dart';
import '../../data/repository.dart';
import '../../data/models.dart';


class ProgramViewScreen extends StatelessWidget {
  final int programId;
  const ProgramViewScreen({super.key, required this.programId});

  @override
  Widget build(BuildContext context) {
    final Program? p = AppRepositories.programs.items
        .firstWhereOrNull((x) => x.id == programId);

    if (p == null) {
      return const Scaffold(body: Center(child: Text('Program not found')));
    }

    return Scaffold(
      appBar: AppBar(title: Text('${p.code} details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(p.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Code: ${p.code}'),
              Text('Department: ${p.department}'),
              Text('Status: ${p.status}'),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text('Delete Program'),
                      content: const Text('Are you sure you want to delete this program?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                        FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
                      ],
                    ),
                  );
                  if (ok == true) {
                    await AppRepositories.programs.delete(p.id);
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on List<Program> {
  Program? firstWhereOrNull(bool Function(dynamic x) param0) {}
}