import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../core/config/strings/app_text.dart';
import '../core/config/theme/app_colors.dart';

class EditJadwalCekKesehatanScreen extends StatefulWidget {
  final DateTime initialDate;
  final String initialTitle;

  EditJadwalCekKesehatanScreen({required this.initialDate, required this.initialTitle});

  @override
  _EditJadwalCekKesehatanScreenState createState() => _EditJadwalCekKesehatanScreenState();
}

class _EditJadwalCekKesehatanScreenState extends State<EditJadwalCekKesehatanScreen> {
  late DateTime _selectedDate;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _titleController = TextEditingController(text: widget.initialTitle);
  }

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
          'Sunting Jadwal Cek Kesehatan',
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
                hintText: EditJadwalCheckupText.namaJadwalLabel,
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
            // Handle "Simpan Perubahan" button press
            _showSuccessDialog(context);
          },
          backgroundColor: AppColors.primary, // Menggunakan AppColors.primary
          child: Text(
            ButtonPengingatText.simpan,
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
          content: Text('Perubahan berhasil disimpan.'),
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