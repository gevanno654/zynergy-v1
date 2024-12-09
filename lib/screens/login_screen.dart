import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
<<<<<<< Updated upstream
import 'package:zynergy/api/api_response.dart';
import 'beranda_screen.dart';
import 'register_screen.dart';
import 'package:http/http.dart' as http;
import 'forget_password.dart';
=======
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'beranda_screen.dart';
import 'register_screen.dart';
import 'forget_password.dart';
import 'personalization_screen.dart'; // Import personalization_screen.dart
import '../api/api_response.dart';
>>>>>>> Stashed changes
import '../api/api_service.dart';
import '../core/config/assets/app_vectors.dart'; // Import app_vectors.dart
import '../core/config/theme/app_colors.dart'; // Import app_colors.dart
import '../core/config/strings/app_text.dart'; // Import app_text.dart
<<<<<<< Updated upstream
import 'package:google_sign_in/google_sign_in.dart';
=======
>>>>>>> Stashed changes

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();
  final _storage = FlutterSecureStorage();
<<<<<<< Updated upstream
=======

  @override
  void initState() {
    super.initState();
    _checkAuthToken();
  }

  Future<void> _checkAuthToken() async {
    String? token = await _storage.read(key: 'auth_token');

    if (token != null) {
      // Verifikasi token dengan API atau lakukan sesuatu untuk memastikan token masih valid
      // Misalnya:
      // final isValid = await _apiService.verifyToken(token);
      // if (!isValid) {
      //   await _storage.delete(key: 'auth_token');
      //   token = null;
      // }
    }

    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BerandaScreen()),
      );
    }
  }
>>>>>>> Stashed changes

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final response = await _apiService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (response.success) {
        await _apiService.saveToken(response.data['token']);
        await _apiService.getUserData(); // Simpan data pengguna setelah login

        // Simpan token ke flutter_secure_storage
        await _storage.write(key: 'auth_token', value: response.data['token']);

<<<<<<< Updated upstream
        _showSuccessDialog();
=======
        // Memeriksa apakah pengguna sudah mengisi data personalisasi
        bool hasPersonalizationData = await _apiService.hasPersonalizationData();

        if (hasPersonalizationData) {
          _showSuccessDialog();
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PersonalizationScreen()),
          );
        }
>>>>>>> Stashed changes
      } else {
        _showErrorDialog(response.message);
      }
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
<<<<<<< Updated upstream
=======
        'https://www.googleapis.com/auth/contacts.readonly',
>>>>>>> Stashed changes
      ],
    );
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
<<<<<<< Updated upstream
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        // print(googleAuth.accessToken);

        // Send the id token to the backend
        // final Dio dio = Dio();
        // final response = await dio.post(
        //   'http://192.168.100.4:8000/api/auth/google/callback',
        //   data: {
        //     'provider': 'google',
        //     'access_provider_token': googleAuth.idToken
        //   },
        // );

        // final response = await http.post(
        //   Uri.parse('http://192.168.100.4:8000/api/auth/google/callback'),
        //   headers: {'Content-Type': 'application/json'},
        //   body: jsonEncode({
        //     'provider': 'google',
        //     'access_provider_token': googleAuth.accessToken
        //   }),
        // );
        final response = await _apiService.signInGoogle(googleAuth.accessToken);

        // Save the token locally
=======
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        print(googleAuth.accessToken);

        final response = await _apiService.signInGoogle(googleAuth.accessToken);

>>>>>>> Stashed changes
        if (response.success) {
          await _apiService.saveToken(response.data['token']);
          await _apiService.getUserData(); // Simpan data pengguna setelah login

<<<<<<< Updated upstream
          // Simpan token ke flutter_secure_storage
          await _storage.write(
              key: 'auth_token', value: response.data['token']);

          _showSuccessDialog();
=======
          await _storage.write(key: 'auth_token', value: response.data['token']);

          // Memeriksa apakah pengguna sudah mengisi data personalisasi
          bool hasPersonalizationData = await _apiService.hasPersonalizationData();

          if (hasPersonalizationData) {
            _showSuccessDialog();
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PersonalizationScreen()),
            );
          }
>>>>>>> Stashed changes
        } else {
          _showErrorDialog(response.message);
        }
      }
    } catch (error) {
      print(error);
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

  bool _obscureText = true; //Logic show & hide kata sandi
<<<<<<< Updated upstream

  @override
  void initState() {
    super.initState();
    _checkAuthToken();
  }

  Future<void> _checkAuthToken() async {
    String? token = await _storage.read(key: 'auth_token');

    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BerandaScreen()),
      );
    }
  }
=======
>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
<<<<<<< Updated upstream
      resizeToAvoidBottomInset:
          false, // Prevent sheet from resizing with keyboard
=======
      resizeToAvoidBottomInset: false, // Prevent sheet from resizing with keyboard
>>>>>>> Stashed changes
      body: SafeArea(
        child: Stack(
          children: [
            // Background dan logo yang tidak bergeser
            Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                color: AppColors.primary,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -90,
                    right: -180,
                    child: Container(
                      width: 500,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          center: Alignment.center,
                          colors: [
                            Color(0xFF2CE4BB),
                            AppColors.primary,
                          ],
                          stops: [0.4, 1.0],
                          radius: 0.3,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 50),
                          Image.asset(
                            'assets/images/Logos.png',
                            width: 250,
                          ),
                          SizedBox(height: 20),
                          Text(
                            LoginText.subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Elemen abu-abu di belakang elemen putih
            AnimatedPositioned(
              duration: Duration(milliseconds: 900),
              curve: Curves.easeInOutCubic,
              top: keyboardHeight > 0 ? 50 : 190,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                width: screenWidth,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Warna abu-abu
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                ),
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
<<<<<<< Updated upstream
                    padding: EdgeInsets.only(
                        top: 32.0, bottom: 0.0, left: 20.0, right: 20.0),
=======
                    padding: EdgeInsets.only(top: 32.0, bottom: 0.0, left: 20.0, right: 20.0),
>>>>>>> Stashed changes
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            LoginText.title,
                            style: TextStyle(
                              color: AppColors.darkGrey,
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
                              labelText: LoginText.emailLabel,
<<<<<<< Updated upstream
                              labelStyle: TextStyle(
                                  color: AppColors.darkGrey.withOpacity(0.6),
                                  fontSize: 18),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(8.0),
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
                            style: TextStyle(color: AppColors.darkGrey),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ketik Email Anda!';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),

                          //textField 'Kata Sandi'
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: LoginText.passwordLabel,
                              labelStyle: TextStyle(
                                  color: AppColors.darkGrey.withOpacity(0.6),
                                  fontSize: 18),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(8.0),
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
                                  _obscureText
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppColors.darkGrey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                            style: TextStyle(color: AppColors.darkGrey),
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ketik Kata Sandi Anda!';
                              }
                              return null;
                            },
                          ),

                          // Tombol 'Lupa Kata Sandi'
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgetPasswordScreen()),
                                );
                              },
                              child: Text(
                                LoginText.forgotPassword,
                                style: TextStyle(
                                    color: AppColors.primary, fontSize: 14),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),

                          //Button 'Masuk(Login)'
                          ElevatedButton(
                            onPressed: _login,
                            child: Text(
                              LoginText.loginButton,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              minimumSize: Size(320, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),

                          //Button 'Daftar'
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()),
                              );
                            },
                            child: Text(
                              LoginText.signUp,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              minimumSize: Size(320, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(color: AppColors.primary),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),

                          // Text 'atau'
                          Text(
                            LoginText.or,
                            style: TextStyle(
                              color: AppColors.darkGrey,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 10),

                          // Tombol 'Masuk dengan Google'
                          ElevatedButton(
                            onPressed: () {
                              signInWithGoogle();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppVectors.iconGoogle,
                                  width: 24,
                                  height: 24,
=======
                              labelStyle: TextStyle(color: AppColors.darkGrey.withOpacity(0.6), fontSize: 18),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(8.0),
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
                            style: TextStyle(color: AppColors.darkGrey),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ketik Email Anda!';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),

                          //textField 'Kata Sandi'
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: LoginText.passwordLabel,
                              labelStyle: TextStyle(color: AppColors.darkGrey.withOpacity(0.6), fontSize: 18),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(8.0),
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
                                  _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: AppColors.darkGrey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                            style: TextStyle(color: AppColors.darkGrey),
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ketik Kata Sandi Anda!';
                              }
                              return null;
                            },
                          ),

                          // Tombol 'Lupa Kata Sandi'
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ForgetPasswordScreen()),
                                );
                              },
                              child: Text(
                                LoginText.forgotPassword,
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14
>>>>>>> Stashed changes
                                ),
                                SizedBox(width: 10),
                                Text(
                                  LoginText.google,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              minimumSize: Size(320, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
<<<<<<< Updated upstream
=======
                          SizedBox(height: 15),

                          //Button 'Masuk(Login)'
                          ElevatedButton(
                            onPressed: _login,
                            child: Text(
                              LoginText.loginButton,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              minimumSize: Size(320, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
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
                              LoginText.signUp,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              minimumSize: Size(320, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(color: AppColors.primary),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),

                          // Text 'atau'
                          Text(
                            LoginText.or,
                            style: TextStyle(
                              color: AppColors.darkGrey,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 10),

                          // Tombol 'Masuk dengan Google'
                          ElevatedButton(
                            onPressed: () {
                              signInWithGoogle();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppVectors.iconGoogle,
                                  width: 24,
                                  height: 24,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  LoginText.google,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              minimumSize: Size(320, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
>>>>>>> Stashed changes
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
