import 'package:east/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: const RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _userType = 'Student';
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          TextField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          Row(
            children: [
              Radio(
                value: 'Student',
                groupValue: _userType,
                onChanged: (value) {
                  setState(() {
                    _userType = value.toString();
                  });
                },
              ),
              const Text('Student'),
              Radio(
                value: 'Teacher',
                groupValue: _userType,
                onChanged: (value) {
                  setState(() {
                    _userType = value.toString();
                  });
                },
              ),
              const Text('Teacher'),
            ],
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
              if (_nameController.text.isEmpty ||
                  _usernameController.text.isEmpty ||
                  _passwordController.text.isEmpty ||
                  _confirmPasswordController.text.isEmpty ||
                  _emailController.text.isEmpty) {
                setState(() {
                  _errorMessage = 'Semua kolom harus diisi.';
                });
                return;
              }
              if (!isValidEmail(_emailController.text)) {
                setState(() {
                  _errorMessage = 'Format email tidak valid.';
                });
                return;
              }
              if (_passwordController.text != _confirmPasswordController.text) {
                setState(() {
                  _errorMessage = 'Password tidak cocok.';
                });
                return;
              }
              // Lakukan pemeriksaan apakah email sudah digunakan sebelumnya
              try {
                UserCredential userCredential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
                // Jika berhasil register, kembali ke halaman login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
                // Tambahkan data pengguna ke database Firebase di sini
              } catch (e) {
                setState(() {
                  // Tangani kesalahan register
                  _errorMessage =
                      'Email telah digunakan. Silakan gunakan email lain.';
                });
              }
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk memeriksa format email
  bool isValidEmail(String email) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }
}
