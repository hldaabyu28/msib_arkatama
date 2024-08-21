import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:msib_arkatama/helpers/database_helper.dart';
import 'package:msib_arkatama/models/penumpang_model.dart';
import 'package:msib_arkatama/models/travel_model.dart';

class EditPenumpangPage extends StatefulWidget {
  final Penumpang penumpang;

  EditPenumpangPage({required this.penumpang});

  @override
  _EditPenumpangPageState createState() => _EditPenumpangPageState();
}

class _EditPenumpangPageState extends State<EditPenumpangPage> {
  final _formKey = GlobalKey<FormState>();
  String _inputData = '';
  int? _selectedTravelId;
  late List<Travel> _availableTravels;

  @override
  void initState() {
    super.initState();
    _loadAvailableTravels();
    _initializeFields();
  }

  Future<void> _loadAvailableTravels() async {
    final dbHelper = DatabaseHelper.instance;
    List<Travel> travels = await dbHelper.getAvailableTravels();
    setState(() {
      _availableTravels = travels;
    });
  }

  void _initializeFields() {
    setState(() {
      _inputData = '${widget.penumpang.nama} ${widget.penumpang.usia} ${widget.penumpang.kota}';
      _selectedTravelId = widget.penumpang.idTravel;
    });
  }

  Future<void> _savePenumpang() async {
    final dbHelper = DatabaseHelper.instance;

    List<String> inputParts = _inputData.split(' ');
    if (inputParts.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Format input tidak sesuai!')),
      );
      return;
    }

    String nama = inputParts[0];
    int usia = int.parse(inputParts[1]);
    String kota = inputParts[2];
    int tahunLahir = DateTime.now().year - usia;

    Penumpang penumpang = Penumpang(
      id: widget.penumpang.id, 
      idTravel: _selectedTravelId!,
      kodeBooking: widget.penumpang.kodeBooking,
      nama: nama,
      jenisKelamin: widget.penumpang.jenisKelamin,
      kota: kota,
      usia: usia,
      tahunLahir: tahunLahir,
      createdAt: widget.penumpang.createdAt, 
    );

    await dbHelper.updatePenumpang(penumpang); 
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Penumpang'),
      ),
      body: _availableTravels.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _inputData,
                    decoration: InputDecoration(
                      labelText: 'Penumpang (NAMA USIA KOTA)',
                      hintText: 'Contoh: Arkatama 25 Malang',
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
                    onChanged: (value) {
                      setState(() {
                        _inputData = value;
                      });
                    },
                  ),
                  DropdownButtonFormField<int>(
                    value: _selectedTravelId,
                    decoration: InputDecoration(labelText: 'Pilih Travel'),
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _savePenumpang();
                      }
                    },
                    child: Text('Simpan Perubahan'),
                  ),
                ],
              ),
            ),
    );
  }
}
