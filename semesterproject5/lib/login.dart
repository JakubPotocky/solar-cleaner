import 'package:flutter/material.dart';
import 'package:semesterproject5/controls.dart';
import 'package:semesterproject5/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _demoMode = false;
  final _formKey = GlobalKey<FormState>();

  void _goToHome() {
    final name = _nameController.text.trim();
    if (_demoMode) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const Controls()));
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HomeScreen(name: name, demoMode: _demoMode),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
        colors: [
          Color.fromARGB(255, 15, 24, 44), 
          Color.fromARGB(255, 28, 41, 61), 
        ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Card(
            color: const Color.fromARGB(255, 255, 255, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
            'assets/img.png',
            height: 150,
            fit: BoxFit.contain,
              ),
              const SizedBox(height: 12),
                  const Text(
                    'Enter your credentials to access the system',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
                  ),
              const SizedBox(height: 16),

              Form(
            key: _formKey,
            child: Column(
              children: [
                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                            decoration: const InputDecoration(
                              labelText: 'User',
                              hintText: 'Enter your user',
                              labelStyle: TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
                              hintStyle: TextStyle(color: Color.fromARGB(137, 0, 0, 0)),
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _goToHome(),
                          ),
                const SizedBox(height: 50),
                SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _goToHome,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 10, 20, 36),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14.0,
                      ),
                    ),
                    child: const Text('Log In'),
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
        ),
      ),
    );
  }
}
