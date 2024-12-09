import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
<<<<<<< Updated upstream
import 'package:intl/intl.dart';
import '../core/config/strings/app_text.dart';
import '../core/config/theme/app_colors.dart';
=======
import 'package:shared_preferences/shared_preferences.dart';
import '../core/config/strings/app_text.dart';
import '../core/config/theme/app_colors.dart';
import '../api/api_service.dart';
import '../api/notification_service.dart';
>>>>>>> Stashed changes

class TambahJadwalCekKesehatanScreen extends StatefulWidget {
  @override
  _TambahJadwalCekKesehatanScreenState createState() => _TambahJadwalCekKesehatanScreenState();
}

class _TambahJadwalCekKesehatanScreenState extends State<TambahJadwalCekKesehatanScreen> {
  DateTime _selectedDate = DateTime.now();
<<<<<<< Updated upstream
  TextEditingController _titleController = TextEditingController();
=======
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  final ApiService _apiService = ApiService();
  final NotificationService _notificationService = NotificationService(); // Tambahkan ini
>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< Updated upstream
      resizeToAvoidBottomInset: false, // Add this line to prevent resizing when keyboard appears
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black), // Menggunakan AppColors.black
=======
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
>>>>>>> Stashed changes
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Tambah Jadwal Cek Kesehatan',
          style: TextStyle(
<<<<<<< Updated upstream
            color: AppColors.black, // Menggunakan AppColors.black
=======
            color: AppColors.black,
>>>>>>> Stashed changes
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
<<<<<<< Updated upstream
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
=======
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildTextFieldSection('Nama Jadwal', _titleController),
                  SizedBox(height: 20),
                  _buildDatePickerSection(),
                  SizedBox(height: 20),
                  _buildTimePickerSection(),
                  SizedBox(height: 20),
                  _buildTextFieldSection('Catatan', _noteController, maxLength: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () async {
              final response = await _apiService.saveHealthCheckupReminder({
                'checkup_name': _titleController.text,
                'checkup_year': _selectedDate.year,
                'checkup_month': _selectedDate.month,
                'checkup_date': _selectedDate.day,
                'checkup_hour': _selectedTime.hour,
                'checkup_minute': _selectedTime.minute,
                'checkup_note': _noteController.text,
                'toggle_value': 1,
              });

              if (response.success) {
                // Jadwalkan notifikasi setelah jadwal berhasil disimpan
                final scheduledDateTime = DateTime(
                  _selectedDate.year,
                  _selectedDate.month,
                  _selectedDate.day,
                  _selectedTime.hour,
                  _selectedTime.minute,
                );

                if (scheduledDateTime.isAfter(DateTime.now())) {
                  await _notificationService.scheduleHealthCheckupNotification(
                    response.data['id'], // ID notifikasi
                    _titleController.text, // Judul notifikasi
                    _noteController.text, // Catatan
                    scheduledDateTime,
                  );

                  // Simpan ID ke daftar notifikasi cek kesehatan
                  await _saveCheckupReminderId(response.data['id']);

                  _showSuccessDialog(context);
                } else {
                  // Tampilkan pesan kesalahan
                  _showErrorDialog(context, 'Waktu yang dipilih sudah lewat.');
                }
              } else {
                _showErrorDialog(context, response.message);
              }
            },
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
      ],
    );
  }

  Future<void> _saveCheckupReminderId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? currentIds = prefs.getStringList('checkupReminderIds');
    if (currentIds == null) {
      currentIds = [];
    }
    if (!currentIds.contains(id.toString())) {
      currentIds.add(id.toString());
    }
    await prefs.setStringList('checkupReminderIds', currentIds);
  }

  Widget _buildTextFieldSection(String label, TextEditingController controller, {int? maxLength}) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label, // Label akan berada di placeholder saat tidak fokus
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: AppColors.lightGrey,
            width: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          PengingatDetailText.infoTanggal,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightGrey, width: 1.0),
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
    );
  }

  Widget _buildTimePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Pilih Waktu',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                color: AppColors.lightGrey,
                width: 1.0,
              ),
            ),
            child: Center(
              child: Text(
                '${_selectedTime.hour.toString().padLeft(2, '0')}  :  ${_selectedTime.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            initialTimerDuration: Duration(
              hours: _selectedTime.hour,
              minutes: _selectedTime.minute,
            ),
            onTimerDurationChanged: (Duration newDuration) {
              setState(() {
                _selectedTime = TimeOfDay(
                  hour: newDuration.inHours,
                  minute: newDuration.inMinutes % 60,
                );
              });
            },
          ),
        );
      },
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
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
>>>>>>> Stashed changes
}