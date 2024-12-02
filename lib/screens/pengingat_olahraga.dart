import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'tambah_jadwal_olahraga.dart';
import 'edit_jadwal_olahraga.dart';
import '../core/config/strings/app_text.dart';
import '../core/config/theme/app_colors.dart'; // Impor app_colors.dart
import '../core/config/assets/app_vectors.dart';

class PengingatOlahragaScreen extends StatefulWidget {
  @override
  _PengingatOlahragaScreenState createState() => _PengingatOlahragaScreenState();
}

class _PengingatOlahragaScreenState extends State<PengingatOlahragaScreen> {
  bool _isPengingatOlahragaEnabled = true;
  bool _isJoggingEnabled = true;
  bool _isPereganganEnabled = true;
  bool _isGymEnabled = true;
  bool _isJadwalKhusus1Enabled = true;

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
          'Pengingat Olahraga',
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
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(
                        AppVectors.iconOlahraga,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        'Pengingat Olahraga',
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
                        value: _isPengingatOlahragaEnabled,
                        onChanged: (value) {
                          setState(() {
                            _isPengingatOlahragaEnabled = value;
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

            // Teks "Jadwal Bawaan"
            Text(
              PengingatDetailText.jadwalBawaan,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),

            // 4 Card dengan backgroundColor white, Outline #1FC29D dan height: 70
            _buildScheduleCard('Jogging', '05:00', 'Harian', _isJoggingEnabled, (value) {
              setState(() {
                _isJoggingEnabled = value;
              });
            }),
            SizedBox(height: 4),
            _buildScheduleCard('Peregangan', '11:00', 'Harian', _isPereganganEnabled, (value) {
              setState(() {
                _isPereganganEnabled = value;
              });
            }),
            SizedBox(height: 4),
            _buildScheduleCard('Gym', '19:00', 'Sekali', _isGymEnabled, (value) {
              setState(() {
                _isGymEnabled = value;
              });
            }),
            SizedBox(height: 20),

            // Teks "Jadwal Khusus"
            Text(
              PengingatDetailText.jadwalKhusus,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),

            // Card dengan spesifikasi sama dengan card sebelumnya
            _buildScheduleCardWithEdit(
              'Push Up',
              '10:00',
              'Harian',
              _isJadwalKhusus1Enabled,
                  (value) {
                setState(() {
                  _isJadwalKhusus1Enabled = value;
                });
              },
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditJadwalOlahragaScreen()),
                );
              },
            ),

            // Menggunakan Expanded untuk memastikan tombol berada di bawah
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TambahJadwalOlahragaScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, // Menggunakan AppColors.primary
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.scale(
                              scale: 0.7,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Text(
                                ButtonPengingatText.tambah,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildScheduleCard(String title, String time, String frequency, bool isEnabled, ValueChanged<bool> onChanged) {
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
          padding: const EdgeInsets.only(left: 16.0, right: 12.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    frequency,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              CupertinoSwitch( // Mengganti Switch dengan CupertinoSwitch
                value: isEnabled,
                onChanged: onChanged,
                activeColor: AppColors.primary, // Menggunakan AppColors.primary
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCardWithEdit(String title, String time, String frequency, bool isEnabled, ValueChanged<bool> onChanged, VoidCallback onEditPressed) {
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
          padding: const EdgeInsets.only(left: 16.0, right: 12.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    frequency,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: AppColors.primary), // Menggunakan AppColors.primary
                onPressed: onEditPressed,
              ),
              Transform.scale(
                scale: 0.9,
                child: CupertinoSwitch( // Mengganti Switch dengan CupertinoSwitch
                  value: isEnabled,
                  onChanged: onChanged,
                  activeColor: AppColors.primary, // Menggunakan AppColors.primary
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}