import 'package:flutter/material.dart';
import '../../data/repository.dart';
import '../../data/models.dart';

class ProgramFormScreen extends StatefulWidget {
  final int? editId;
  const ProgramFormScreen({super.key, this.editId});

  @override
  State<ProgramFormScreen> createState() => _ProgramFormScreenState();
}

class _ProgramFormScreenState extends State<ProgramFormScreen> {
  final _form = GlobalKey<FormState>();
  final _code = TextEditingController();
  final _name = TextEditingController();
  final _dept = TextEditingController();
  String _status = 'active';
  double _opacity = 0;

  Program? get editing => widget.editId == null
      ? null
      : AppRepositories.programs.items.firstWhere((p) => p.id == widget.editId);

  @override
  void initState() {
    super.initState();
    if (editing != null) {
      _code.text = editing!.code;
      _name.text = editing!.name;
      _dept.text = editing!.department;
      _status = editing!.status;
    }
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) setState(() => _opacity = 1);
    });
  }

  Future<void> _save() async {
    if (!(_form.currentState?.validate() ?? false)) return;

    if (editing == null) {
      await AppRepositories.programs.create(
        code: _code.text,
        name: _name.text,
        department: _dept.text,
        status: _status,
      );
    } else {
      await AppRepositories.programs.update(
        editing!.copyWith(
          code: _code.text,
          name: _name.text,
          department: _dept.text,
          status: _status,
        ),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = editing != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Program' : 'Add Program')),
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
                  controller: _code,
                  decoration: const InputDecoration(labelText: 'Program Code (e.g., BSIT)'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Program Name'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dept,
                  decoration: const InputDecoration(labelText: 'Department'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: const [
                    DropdownMenuItem(value: 'active', child: Text('active')),
                    DropdownMenuItem(value: 'inactive', child: Text('inactive')),
                  ],
                  onChanged: (v) => setState(() => _status = v ?? 'active'),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: Text(isEdit ? 'Save Changes' : 'Create Program'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}