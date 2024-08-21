import 'package:flutter/material.dart';
import 'package:msib_arkatama/helpers/database_helper.dart';
import 'package:msib_arkatama/models/travel_model.dart';

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  final _formKey = GlobalKey<FormState>();
  String _tanggalKeberangkatan = '';
  int _kuota = 0;

  Future<void> _saveTravel() async {
    final dbHelper = DatabaseHelper.instance;
    Travel travel = Travel(tanggalKeberangkatan: _tanggalKeberangkatan, kuota: _kuota);
    await dbHelper.insertTravel(travel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel CRUD'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Tanggal Keberangkatan'),
              onSaved: (value) {
                _tanggalKeberangkatan = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Kuota'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                _kuota = int.parse(value!);
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _saveTravel();
                  print(_tanggalKeberangkatan);
                  print(_kuota);
                }
              },
              child: Text('Simpan Travel'),
            ),
          ],
        ),
      ),
    );
  }
}
