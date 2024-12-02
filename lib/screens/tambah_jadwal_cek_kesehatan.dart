import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../core/config/strings/app_text.dart';
import '../core/config/theme/app_colors.dart';

class TambahJadwalCekKesehatanScreen extends StatefulWidget {
  @override
  _TambahJadwalCekKesehatanScreenState createState() => _TambahJadwalCekKesehatanScreenState();
}

class _TambahJadwalCekKesehatanScreenState extends State<TambahJadwalCekKesehatanScreen> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Add this line to prevent resizing when keyboard appears
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black), // Menggunakan AppColors.black
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Tambah Jadwal Cek Kesehatan',
          style: TextStyle(
            color: AppColors.black, // Menggunakan AppColors.black
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Nama Jadwal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: TambahJadwalCheckupText.namaJadwalLabel,
                hintStyle: TextStyle(
                  color: Colors.grey, // Ubah warna hint menjadi abu-abu
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              PengingatDetailText.infoTanggal,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lightGrey, width: 1.0), // Menggunakan AppColors.lightGrey
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: CalendarDatePicker(
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2050),
                onDateChanged: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 320,
        height: 40,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: () {
            // Handle "Buat Pengingat" button press
            _showSuccessDialog(context);
          },
          backgroundColor: AppColors.primary, // Menggunakan AppColors.primary
          child: Text(
            ButtonPengingatText.tambah,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Berhasil'),
          content: Text('Pengingat berhasil dibuat.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}