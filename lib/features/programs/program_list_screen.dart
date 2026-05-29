import 'package:flutter/material.dart';
import '../../data/repository.dart';
import 'program_form_screen.dart';
import 'program_view_screen.dart';

class ProgramListScreen extends StatefulWidget {
  const ProgramListScreen({super.key});

  @override
  State<ProgramListScreen> createState() => _ProgramListScreenState();
}

class _ProgramListScreenState extends State<ProgramListScreen> {
  final repo = AppRepositories.programs;
  String _q = '';

  @override
  void initState() {
    super.initState();
    repo.addListener(_refresh);
  }

  @override
  void dispose() {
    repo.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final items = _q.isEmpty ? repo.items : repo.items.where((p) {
      final q = _q.toLowerCase();
      return p.code.toLowerCase().contains(q) ||
          p.name.toLowerCase().contains(q) ||
          p.department.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Programs'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Students',
            onPressed: () => Navigator.pushNamed(context, '/students'),
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
                  hintText: 'Search program...',
                ),
                onChanged: (v) => setState(() => _q = v),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 0),
                itemBuilder: (context, i) {
                  final p = items[i];
                  return ListTile(
                    title: Text('${p.code} — ${p.name}'),
                    subtitle: Text('${p.department} • ${p.status}'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProgramViewScreen(programId: p.id),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProgramFormScreen(editId: p.id),
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
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProgramFormScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Program'),
      ),
    );
  }
}