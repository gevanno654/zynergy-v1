import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/config/strings/app_text.dart';
import '../core/config/assets/app_vectors.dart';
import '../core/config/theme/app_colors.dart'; // Impor app_colors.dart
import '../api/api_service.dart'; // Impor ApiService
import '../api/notification_service.dart'; // Impor NotificationService

class EditJadwalOlahragaScreen extends StatefulWidget {
  final Map<String, dynamic> initialData;

  EditJadwalOlahragaScreen({required this.initialData});

  @override
  _EditJadwalOlahragaScreenState createState() => _EditJadwalOlahragaScreenState();
}

class _EditJadwalOlahragaScreenState extends State<EditJadwalOlahragaScreen> {
  int _selectedHour = 0;
  int _selectedMinute = 0;
  String _selectedFrequency = 'Sekali';
  bool _isVibrationEnabled = false;
  bool _isDeleteAfterRing = false;
  TextEditingController _namaJadwalController = TextEditingController();

  List<int> _hours = List.generate(24, (index) => index);
  List<int> _minutes = List.generate(60, (index) => index);

  final ApiService _apiService = ApiService();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialData['activity_hour'];
    _selectedMinute = widget.initialData['activity_minute'];
    _selectedFrequency = widget.initialData['activity_frequency'] == 1 ? 'Harian' : 'Sekali';
    _isVibrationEnabled = widget.initialData['toggle_value'] == 1;
    _isDeleteAfterRing = widget.initialData['toggle_value'] == 1;
    _namaJadwalController.text = widget.initialData['activity_name'];
  }

  void _showTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Row(
            children: [
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      _selectedHour = _hours[index];
                    });
                  },
                  children: _hours.map((hour) {
                    return Center(
                      child: Text(
                        hour.toString().padLeft(2, '0'),
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Text(':', style: TextStyle(fontSize: 18)),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      _selectedMinute = _minutes[index];
                    });
                  },
                  children: _minutes.map((minute) {
                    return Center(
                        child: Text(
                          minute.toString().padLeft(2, '0'),
                          style: TextStyle(fontSize: 18),
                        ));
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFrequencyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Sekali'),
                onTap: () {
                  setState(() {
                    _selectedFrequency = 'Sekali';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Harian'),
                onTap: () {
                  setState(() {
                    _selectedFrequency = 'Harian';
                  });
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Simpan'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveJadwal() async {
    final updatedData = {
      'activity_name': _namaJadwalController.text,
      'activity_hour': _selectedHour,
      'activity_minute': _selectedMinute,
      'activity_frequency': _selectedFrequency == 'Harian' ? 1 : 0,
      'toggle_value': _isVibrationEnabled ? 1 : 0,
    };

    try {
      final response = await _apiService.updateLightActivityReminder(widget.initialData['id'], updatedData);

      if (response.success) {
        // Cancel the old notification
        await _notificationService.cancelNotification(widget.initialData['id']);

        // Schedule the new notification
        final now = DateTime.now();
        final scheduledDate = DateTime(now.year, now.month, now.day, _selectedHour, _selectedMinute);
        await _notificationService.scheduleNotification(
          widget.initialData['id'],
          'Pengingat Olahraga',
          'Ingatlah untuk olahraga sesuai jadwal!',
          scheduledDate,
          _selectedFrequency,
        );

        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan jadwal: ${response.message}')),
        );
      }
    } catch (e) {
      print('Error saving schedule: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat menyimpan jadwal: $e')),
      );
    }
  }

  Future<void> _deleteJadwal() async {
    try {
      // Cancel the notification before deleting the schedule
      await _notificationService.cancelNotification(widget.initialData['id']);

      final response = await _apiService.deleteLightActivityReminder(widget.initialData['id']);

      if (response.success) {
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus jadwal: ${response.message}')),
        );
      }
    } catch (e) {
      print('Error deleting schedule: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat menghapus jadwal: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black), // Menggunakan AppColors.black
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Sunting Jadwal Olahraga',
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    TextField(
                      controller: _namaJadwalController,
                      decoration: InputDecoration(
                        labelText: EditJadwalOlahragaText.namaJadwalLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: AppColors.lightGrey, // Menggunakan AppColors.lightGrey
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      PengingatDetailText.infoPilihWaktu,
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _showTimePicker(context),
                      child: Container(
                        width: 136,
                        height: 60,
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: AppColors.lightGrey, // Menggunakan AppColors.lightGrey
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${_selectedHour.toString().padLeft(2, '0')}  :  ${_selectedMinute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Card(
                      color: Colors.white,
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(
                          color: AppColors.lightGrey, // Menggunakan AppColors.lightGrey
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 0.0, top: 4.0, bottom: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 60,
                              child: ListTile(
                                leading: SvgPicture.asset(
                                  AppVectors.iconFreq,
                                  width: 24,
                                  height: 24,
                                ),
                                title: Text(
                                  CardSettingTambahEditJadwalText.frekuensi,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _selectedFrequency,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 18,
                                      color: AppColors.darkGrey, // Menggunakan AppColors.darkGrey
                                    ),
                                  ],
                                ),
                                onTap: () => _showFrequencyModal(context),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: ListTile(
                                leading: SvgPicture.asset(
                                  AppVectors.iconVibration,
                                  width: 24,
                                  height: 24,
                                ),
                                title: Text(
                                  CardSettingTambahEditJadwalText.vibration,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Transform.scale(
                                  scale: 0.9,
                                  child: CupertinoSwitch(
                                    value: _isVibrationEnabled,
                                    onChanged: (value) {
                                      setState(() {
                                        _isVibrationEnabled = value;
                                      });
                                    },
                                    activeColor: AppColors.primary, // Menggunakan AppColors.primary
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: ListTile(
                                leading: SvgPicture.asset(
                                  AppVectors.iconTrash,
                                  width: 24,
                                  height: 24,
                                ),
                                title: Text(
                                  CardSettingTambahEditJadwalText.deleteAfterDo,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Transform.scale(
                                  scale: 0.9,
                                  child: CupertinoSwitch(
                                    value: _isDeleteAfterRing,
                                    onChanged: (value) {
                                      setState(() {
                                        _isDeleteAfterRing = value;
                                      });
                                    },
                                    activeColor: AppColors.primary, // Menggunakan AppColors.primary
                                  ),
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
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: _deleteJadwal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Warna tombol hapus
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'Hapus Jadwal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: _saveJadwal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, // Menggunakan AppColors.primary
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  ButtonPengingatText.simpan,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
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