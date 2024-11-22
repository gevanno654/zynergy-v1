import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import LoginScreen
import '../api/api_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _apiService = ApiService();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final response = await _apiService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
        _confirmPasswordController.text,
      );

      if (response.success) {
        await _apiService.saveToken(response.data['token']);
        _showSuccessDialog();
      } else {
        _showErrorDialog(response.message);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pendaftaran Berhasil'),
          content: Text('Akun Anda berhasil didaftarkan.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pendaftaran Gagal'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent sheet from resizing with keyboard
      body: SafeArea(
        child: Stack(
          children: [
            // Background dan logo yang tidak bergeser
            Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1AD7AC), // Warna awal
                    Color(0xFF1FC29D), // Warna akhir
                  ],
                  transform: GradientRotation(280 * (3.1415926535 / 180)),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Image.asset(
                    'assets/Logo 1.png',
                    width: 250,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Ambil langkah pertama untuk mulai peduli kesehatanmu.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Bagian bawah yang bisa discroll
            AnimatedPositioned(
              duration: Duration(milliseconds: 900),
              curve: Curves.easeInOutCubic,
              top: keyboardHeight > 0 ? 50 : 210,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    width: screenWidth,
                    padding: EdgeInsets.only(top: 32.0, bottom: 0.0, left: 20.0, right: 20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Daftar Akun Baru',
                            style: TextStyle(
                              color: Color(0xFF3F3F3F),
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(height: 20),

                          // Form registrasi
                          // textField 'Name'
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Color(0x903F3F3F), fontSize: 18),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF1FC29D)),
                                borderRadius: BorderRadius.circular(8.0), // Atur border radius di sini
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF1FC29D)),
                                borderRadius: BorderRadius.circular(8.0), // Atur border radius di sini
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            style: TextStyle(color: Color(0xFF3F3F3F)), // Warna teks abu-abu
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),

                          // textField 'Email'
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Color(0x903F3F3F), fontSize: 18),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF1FC29D)),
                                borderRadius: BorderRadius.circular(8.0), // Atur border radius di sini
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF1FC29D)),
                                borderRadius: BorderRadius.circular(8.0), // Atur border radius di sini
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            style: TextStyle(color: Color(0xFF3F3F3F)), // Warna teks abu-abu
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),

                          // textField 'Password'
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Color(0x903F3F3F), fontSize: 18), // Warna label abu-abu transparan
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF1FC29D)), // Warna border hijau
                                borderRadius: BorderRadius.circular(8.0), // Atur border radius di sini
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF1FC29D)), // Warna border hijau
                                borderRadius: BorderRadius.circular(8.0), // Atur border radius di sini
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureTextPassword ? Icons.visibility : Icons.visibility_off,
                                  color: Color(0xFF3F3F3F), // Warna icon abu-abu
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureTextPassword = !_obscureTextPassword;
                                  });
                                },
                              ),
                            ),
                            style: TextStyle(color: Color(0xFF3F3F3F)), // Warna teks abu-abu
                            obscureText: _obscureTextPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),

                          // textField 'Confirm Password'
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(color: Color(0x903F3F3F), fontSize: 18), // Warna label abu-abu transparan
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF1FC29D)), // Warna border hijau
                                borderRadius: BorderRadius.circular(8.0), // Atur border radius di sini
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF1FC29D)), // Warna border hijau
                                borderRadius: BorderRadius.circular(8.0), // Atur border radius di sini
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureTextConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                  color: Color(0xFF3F3F3F), // Warna icon abu-abu
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            style: TextStyle(color: Color(0xFF3F3F3F)), // Warna teks abu-abu
                            obscureText: _obscureTextConfirmPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),

                          // Button 'Register'
                          ElevatedButton(
                            onPressed: _register,
                            child: Text(
                              'Daftar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1FC29D), // Warna background hijau
                              foregroundColor: Colors.white, // Warna teks putih
                              minimumSize: Size(320, 50), // Ukuran button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0), // Border radius
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Button 'Sudah punya akun? Login disini'
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            },
                            child: Text(
                              'Sudah punya akun? Login disini',
                              style: TextStyle(
                                color: Color(0xFF1FC29D),
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // Warna background putih
                              foregroundColor: Color(0xFF1FC29D), // Warna teks hijau
                              minimumSize: Size(320, 50), // Ukuran button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0), // Border radius
                                side: BorderSide(color: Color(0xFF1FC29D)), // Outline warna hijau
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}