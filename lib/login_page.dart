import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_page.dart'; // Import halaman register
import 'beranda/halaman_murid.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 200,
          ),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          if (_errorMessage.isNotEmpty) // Menampilkan pesan kesalahan jika ada
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              // Validasi input
              if (_usernameController.text.isEmpty ||
                  _passwordController.text.isEmpty) {
                setState(() {
                  _errorMessage = 'Email dan password harus diisi.';
                });
                return;
              }
              try {
                // Melakukan login dengan Firebase
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: _usernameController.text,
                  password: _passwordController.text,
                );
                // Jika berhasil login, navigasi ke halaman beranda atau halaman lainnya
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HalamanMurid(),
                  ),
                );
              } catch (e) {
                setState(() {
                  // Tangani kesalahan login
                  _errorMessage = 'Email atau password salah.';
                });
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              );
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
