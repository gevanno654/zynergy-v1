import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'tambah_jadwal_tidur.dart';
import 'edit_jadwal_tidur.dart';
import '../core/config/strings/app_text.dart';
import '../core/config/theme/app_colors.dart';
import '../core/config/assets/app_vectors.dart';
import '../api/api_service.dart';

class PengingatTidurScreen extends StatefulWidget {
  @override
  _PengingatTidurScreenState createState() => _PengingatTidurScreenState();
}

class _PengingatTidurScreenState extends State<PengingatTidurScreen> {
  bool _isPengingatTidurEnabled = true;
  bool _isDurasiTidurTerbaikEnabled = true;
  List<Map<String, dynamic>> _sleepReminders = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchSleepReminders();
  }

  Future<void> _fetchSleepReminders() async {
    final response = await _apiService.getSleepReminders();
    if (response.success) {
      setState(() {
        _sleepReminders = List<Map<String, dynamic>>.from(response.data);
      });
    } else {
      // Handle error
      print('Error: ${response.message}');
    }
  }

  void _navigateToAddSleepReminder() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TambahJadwalTidurScreen()),
    ).then((_) => _fetchSleepReminders());
  }

  void _navigateToEditSleepReminder(Map<String, dynamic> reminder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditJadwalTidurScreen(
          id: reminder['id'],
          sleepName: reminder['sleep_name'],
          sleepHour: reminder['sleep_hour'],
          sleepMinute: reminder['sleep_minute'],
          wakeHour: reminder['wake_hour'],
          wakeMinute: reminder['wake_minute'],
          sleepFrequency: reminder['sleep_frequency'] == 0 ? 'Sekali' : 'Harian',
          isVibrationEnabled: reminder['toggle_state'] ?? false, // Provide default value
          isDeleteAfterRing: false, // Assuming this is not used in the edit screen
        ),
      ),
    ).then((_) => _fetchSleepReminders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Pengingat Tidur',
          style: TextStyle(
            color: AppColors.black,
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
            // Card Pengingat Tidur
            Card(
              color: AppColors.primary,
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
                        AppVectors.iconMalam,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        'Pengingat Tidur',
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
                        value: _isPengingatTidurEnabled,
                        onChanged: (value) {
                          setState(() {
                            _isPengingatTidurEnabled = value;
                          });
                        },
                        activeColor: AppColors.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),

            // Card Durasi Tidur Terbaik
            SizedBox(
              height: 60,
              child: Card(
                color: AppColors.primary,
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
                          AppVectors.iconTidur,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          'Durasi Tidur Terbaik',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                            Icons.info_rounded,
                            color: Colors.white
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text(
                                  'Mengaktifkan mode ini akan otomatis membuat alarm bangun 8 jam dari jadwal alarm tidur dan menonaktifkan alarm bangun yang telah diatur.',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Tutup',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      Transform.scale(
                        scale: 0.9,
                        child: CupertinoSwitch(
                          value: _isDurasiTidurTerbaikEnabled,
                          onChanged: (value) {
                            setState(() {
                              _isDurasiTidurTerbaikEnabled = value;
                            });
                          },
                          activeColor: AppColors.lightGrey,
                        ),
                      ),
                    ],
                  ),
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

            // 1 Card dengan backgroundColor white, Outline #1FC29D dan height: 70
            _buildScheduleCard(
              [
                {'time': '06:00', 'description': 'Jam Bangun'},
                {'time': '22:00', 'description': 'Jam Tidur'},
              ],
              'Direkomendasikan',
              true,
                  (value) {},
            ),
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

            // List of sleep reminders
            Expanded(
              child: ListView.builder(
                itemCount: _sleepReminders.length,
                itemBuilder: (context, index) {
                  final reminder = _sleepReminders[index];
                  return _buildScheduleCardWithEdit(
                    [
                      {'time': '${reminder['sleep_hour'].toString().padLeft(2, '0')}:${reminder['sleep_minute'].toString().padLeft(2, '0')}', 'description': 'Jam Tidur'},
                      {'time': '${reminder['wake_hour'].toString().padLeft(2, '0')}:${reminder['wake_minute'].toString().padLeft(2, '0')}', 'description': 'Jam Bangun'},
                    ],
                    reminder['sleep_name'],
                    reminder['toggle_state'] ?? false, // Provide default value
                        (value) {
                      setState(() {
                        reminder['toggle_state'] = value;
                      });
                    },
                        () {
                      _navigateToEditSleepReminder(reminder);
                    },
                  );
                },
              ),
            ),

            // Menggunakan Expanded untuk memastikan tombol berada di bawah
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: _navigateToAddSleepReminder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
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
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard(List<Map<String, String>> times, String frequency, bool isEnabled, ValueChanged<bool> onChanged) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: AppColors.lightGrey,
          width: 1.0,
        ),
      ),
      child: SizedBox(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 12.0, top: 18.0, bottom: 18.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: times.map((time) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        time['time']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        time['description']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      frequency,
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
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCardWithEdit(List<Map<String, String>> times, String frequency, bool isEnabled, ValueChanged<bool> onChanged, VoidCallback onEditPressed) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: AppColors.lightGrey,
          width: 1.0,
        ),
      ),
      child: SizedBox(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 12.0, top: 18.0, bottom: 18.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: times.map((time) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        time['time']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        time['description']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      frequency,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: AppColors.primary),
                onPressed: onEditPressed,
              ),
              Transform.scale(
                scale: 0.9,
                child: CupertinoSwitch( // Mengganti Switch dengan CupertinoSwitch
                  value: isEnabled,
                  onChanged: onChanged,
                  activeColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}