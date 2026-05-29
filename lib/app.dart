import 'package:flutter/material.dart';
import 'features/auth/login_screen.dart';
import 'features/programs/program_list_screen.dart';
import 'features/students/student_list_screen.dart';

class RegistrarApp extends StatelessWidget {
  const RegistrarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registrar CRUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/programs': (_) => const ProgramListScreen(),
        '/students': (_) => const StudentListScreen(),
      },
    );
  }
}