
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msib_arkatama/helpers/database_helper.dart';
import 'package:msib_arkatama/models/penumpang_model.dart';
import 'package:msib_arkatama/models/travel_model.dart';

class PenumpangPage extends StatefulWidget {
  @override
  _PenumpangPageState createState() => _PenumpangPageState();
}

class _PenumpangPageState extends State<PenumpangPage> {
  final _formKey = GlobalKey<FormState>();
  String _inputData = '';
  int? _selectedTravelId;
  List<Travel> _availableTravels = [];

  @override
  void initState() {
    super.initState();
    _loadAvailableTravels();
  }

  Future<void> _loadAvailableTravels() async {
    final dbHelper = DatabaseHelper.instance;
    List<Travel> travels = await dbHelper.getAvailableTravels();
    setState(() {
      _availableTravels = travels;
    });
  }

  Future<void> _savePenumpang() async {
  final dbHelper = DatabaseHelper.instance;

  List<String> inputParts = _inputData.split(' ');
  if (inputParts.length != 3) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Format input harus: NAMA USIA KOTA')),
    );
    return;
  }

  String nama = inputParts[0];
  int usia;
  String kota = inputParts[2];
  try {
    usia = int.parse(inputParts[1]); // Pastikan ini hanya angka
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Usia harus berupa angka')),
    );
    return;
  }

  int tahunLahir = DateTime.now().year - usia;
  String kodeBooking = await dbHelper.generateKodeBooking(_selectedTravelId!);

  Penumpang penumpang = Penumpang(
    idTravel: _selectedTravelId!,
    kodeBooking: kodeBooking,
    nama: nama,
    jenisKelamin: '', 
    kota: kota,
    usia: usia,
    tahunLahir: tahunLahir,
    createdAt: DateTime.now().toIso8601String(),
  );

  await dbHelper.insertPenumpang(penumpang);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text('Tambah Penumpang', style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                  ),),
        backgroundColor: Color(0xFF6900FF),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 150),
        color: Color(0xFF6900FF).withOpacity(0.3),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  decoration: InputDecoration(
                  hintText: 'NAMA USIA KOTA',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                  ),
                  fillColor: Color(0xFF104084).withOpacity(0.4),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                  ),
                ),
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                  ),
                onSaved: (value) {
                  _inputData = value!;
                },
              ),
              Gap(20),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  fillColor: Color(0xFF104084).withOpacity(0.4),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                ),
                hint: Text('Pilih Travel', style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                ),),
                items: _availableTravels.map((travel) {
                  return DropdownMenuItem<int>(
                    value: travel.id,
                    child: Text('Travel ID: ${travel.id}, Kuota: ${travel.kuota}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTravelId = value;
                  });
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
                    _savePenumpang();
                    print(_inputData);
                    _formKey.currentState!.reset();
                    print(_selectedTravelId);
                    
                  }
                },
                child: Text('Simpan Penumpang', style: TextStyle(
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
