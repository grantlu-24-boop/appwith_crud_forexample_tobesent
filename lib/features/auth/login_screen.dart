import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _user = TextEditingController();
  final _pass = TextEditingController();
  double _logoOpacity = 0;

  @override
  void initState() {
    super.initState();
    // fade-in animation
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() => _logoOpacity = 1);
    });
  }

  void _login() {
    if (_form.currentState?.validate() ?? false) {
      // Dummy auth: admin/admin
      if (_user.text == 'admin' && _pass.text == 'admin') {
        Navigator.pushReplacementNamed(context, '/programs');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid credentials')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 3,
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 600),
                    opacity: _logoOpacity,
                    child: const Icon(Icons.school, size: 72),
                  ),
                  const SizedBox(height: 16),
                  const Text('Registrar Login', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 16),
                  Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _user,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _pass,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: double.infinity,
                          height: 48,
                          child: FilledButton(
                            onPressed: _login,
                            child: const Text('Sign in (admin/admin)'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}