import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'beranda_screen.dart';
import 'register_screen.dart'; // Import RegisterScreen
import '../api/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final response = await _apiService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (response.success) {
        await _apiService.saveToken(response.data['token']);
        await _apiService.getUserData(); // Simpan data pengguna setelah login
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
          title: Text('Login Berhasil'),
          content: Text('Anda berhasil login.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BerandaScreen()),
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
          title: Text('Login Gagal'),
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

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 90),
                Column(
                  children: [
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
                SizedBox(height: 70),

                // Bagian bawah: Form login dan button
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 32.0, bottom: 0.0, left: 20.0, right: 20.0), // Padding dalam container
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Login untuk Masuk',
                          style: TextStyle(
                            color: Color(0xFF3F3F3F),
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Form login
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
                              return 'Masukkan Email Anda!';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),

                        //textField 'Password'
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
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                                color: Color(0xFF3F3F3F), // Warna icon abu-abu
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          style: TextStyle(color: Color(0xFF3F3F3F)), // Warna teks abu-abu
                          obscureText: _obscureText,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan Password Anda!';
                            }
                            return null;
                          },
                        ),

                        // Tombol 'Lupa Kata Sandi'
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Tambahkan logika untuk lupa kata sandi di sini
                            },
                            child: Text(
                              'Lupa Kata Sandi?',
                              style: TextStyle(
                                  color: Color(0xFF1FC29D),
                                  fontSize: 14
                              ), // Warna teks hijau
                            ),
                          ),
                        ),
                        SizedBox(height: 15),

                        //Button 'Masuk(Login)'
                        ElevatedButton(
                          onPressed: _login,
                          child: Text(
                            'Masuk',
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
                        SizedBox(height: 10),

                        //Button 'Daftar'
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterScreen()),
                            );
                          },
                          child: Text(
                            'Buat Akun Baru',
                            style: TextStyle(
                              color: Color(0xFF1FC29D),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF1FC29D),
                            minimumSize: Size(320, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Color(0xFF1FC29D)),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),

                        // Text 'atau'
                        Text(
                          'atau',
                          style: TextStyle(
                            color: Color(0xFF3F3F3F),
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 10),

                        // Tombol 'Masuk dengan Google'
                        ElevatedButton(
                          onPressed: () {
                            // Tambahkan logika untuk masuk dengan Google di sini
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/google.svg',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Masuk dengan Google',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Warna background putih
                            foregroundColor: Colors.black, // Warna teks hitam
                            minimumSize: Size(320, 50), // Ukuran button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0), // Border radius
                              side: BorderSide(color: Colors.grey), // Outline warna abu-abu
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}