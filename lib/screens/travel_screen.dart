import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msib_arkatama/helpers/database_helper.dart';
import 'package:msib_arkatama/models/travel_model.dart';

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  DateTime _selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  String _tanggalKeberangkatan = '';
  int _kuota = 0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _tanggalKeberangkatan = pickedDate.toIso8601String().split('T')[0]; // Format: yyyy-MM-dd
      });
    }
  }

  Future<void> _saveTravel() async {
    final dbHelper = DatabaseHelper.instance;
    Travel travel = Travel(
      tanggalKeberangkatan: _tanggalKeberangkatan,
      kuota: _kuota,
    );
    await dbHelper.insertTravel(travel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text('Tambah Travel', style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                  ),),
        backgroundColor: Color(0xFF6900FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Tanggal Keberangkatan',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                  ),
                  fillColor: Color(0xFF104084).withOpacity(0.4),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                ),
                controller: TextEditingController(
                  text: _tanggalKeberangkatan,
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode()); // Menyembunyikan keyboard
                  await _selectDate(context);
                },
                readOnly: true,
              ),
              Gap(10),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Kuota',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                  ),
                  fillColor: Color(0xFF104084).withOpacity(0.4),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                ),
          
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _kuota = int.parse(value!);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6900FF).withOpacity(0.7),
                  maximumSize: Size(double.infinity,100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),

                  ),
                  
                ),
                onPressed: () {
                   if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _saveTravel();
                    print(_tanggalKeberangkatan);
                    print(_kuota);
                    _formKey.currentState!.reset();

                  }
                },
                child: Text('Simpan Travel', style: TextStyle(
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                    
                    color: Colors.white,
                  ),),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
