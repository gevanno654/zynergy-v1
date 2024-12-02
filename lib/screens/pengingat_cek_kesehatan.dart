import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'tambah_jadwal_cek_kesehatan.dart';
import 'edit_jadwal_cek_kesehatan.dart';
import '../core/config/assets/app_vectors.dart';
import '../core/config/strings/app_text.dart';
import '../core/config/theme/app_colors.dart';

class PengingatCekKesehatanScreen extends StatefulWidget {
  @override
  _PengingatCekKesehatanScreenState createState() => _PengingatCekKesehatanScreenState();
}

class _PengingatCekKesehatanScreenState extends State<PengingatCekKesehatanScreen> {
  bool _isPengingatCekKesehatanEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black), // Menggunakan AppColors.black
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Pengingat Cek Kesehatan',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: AppColors.primary, // Menggunakan AppColors.primary
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 6.0, top: 6.0, bottom: 6.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: SvgPicture.asset(
                        AppVectors.iconCheckup,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        'Pengingat Cek Kesehatan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Spacer(),
                    Transform.scale(
                      scale: 0.9,
                      child: CupertinoSwitch(
                        value: _isPengingatCekKesehatanEnabled,
                        onChanged: (value) {
                          setState(() {
                            _isPengingatCekKesehatanEnabled = value;
                          });
                        },
                        activeColor: AppColors.lightGrey, // Menggunakan AppColors.lightGrey
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Calendar
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lightGrey, width: 1.0), // Menggunakan AppColors.lightGrey
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2050),
                onDateChanged: (date) {
                  // Handle date change
                },
              ),
            ),
            SizedBox(height: 20),

            // Event Cards
            _buildEventCard(
              'Selasa, 10 Sep 2024',
              'Anu',
                  () {
                // Handle info button press
              },
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditJadwalCekKesehatanScreen(
                      initialDate: DateTime(2024, 9, 10), // Replace with actual date
                      initialTitle: 'Anu', // Replace with actual title
                    ),
                  ),
                );
              },
                  () {
                _showDeleteConfirmationDialog(context);
              },
            ),
            SizedBox(height: 4),
            _buildEventCard(
              'Kamis, 12 Sep 2024',
              'Anu',
                  () {
                // Handle info button press
              },
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditJadwalCekKesehatanScreen(
                      initialDate: DateTime(2024, 9, 10), // Replace with actual date
                      initialTitle: 'Anu', // Replace with actual title
                    ),
                  ),
                );
              },
                  () {
                _showDeleteConfirmationDialog(context);
              },
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TambahJadwalCekKesehatanScreen()),
            );
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

  Widget _buildEventCard(String date, String title, VoidCallback onInfoPressed, VoidCallback onEditPressed, VoidCallback onDeletePressed) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: AppColors.lightGrey, // Menggunakan AppColors.lightGrey
          width: 1.0,
        ),
      ),
      child: SizedBox(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.only(left: 6.0, right: 4.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.info_outline_rounded, color: AppColors.primary), // Menggunakan AppColors.primary
                onPressed: onInfoPressed,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                        Icons.edit,
                        color: AppColors.primary // Menggunakan AppColors.primary
                    ),
                    onPressed: onEditPressed,
                  ),
                  IconButton(
                    icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.danger // Menggunakan AppColors.danger
                    ),
                    onPressed: onDeletePressed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus jadwal ini?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () {
                // Handle delete action
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}