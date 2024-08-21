import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msib_arkatama/helpers/database_helper.dart';
import 'package:msib_arkatama/models/penumpang_model.dart';
import 'package:msib_arkatama/screens/edit_penumpang.dart';
import 'package:msib_arkatama/screens/penumpang_screen.dart';



class PenumpangListPage extends StatefulWidget {
  @override
  _PenumpangListPageState createState() => _PenumpangListPageState();
}

class _PenumpangListPageState extends State<PenumpangListPage> {
  List<Penumpang> _penumpangs = [];

  @override
  void initState() {
    super.initState();
    _loadPenumpangs();
  }

   Future<void> _deletePenumpang(int id) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.deletePenumpang(id);
    _loadPenumpangs(); 
  }

  Future<void> _loadPenumpangs() async {
    final dbHelper = DatabaseHelper.instance;
    List<Penumpang> penumpangs = await dbHelper.getAllPenumpangs();
    setState(() {
      _penumpangs = penumpangs;
    });
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF6900FF),
        title: Text('Daftar Penumpang',style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                  ),),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PenumpangPage()),
              ).then((_) => _loadPenumpangs());
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 50),
        color: Color(0xFF6900FF).withOpacity(0.3),
        child: ListView.builder(
          itemCount: _penumpangs.length,
          itemBuilder: (context, index) {
            final penumpang = _penumpangs[index];
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Color(0xFF6900FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text('${penumpang.nama} (${penumpang.kodeBooking})' , style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                  ),),
                subtitle: Text('Travel ID: ${penumpang.idTravel}, Kota: ${penumpang.kota}' , style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                  ),),
                trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Hapus Penumpang'),
                      content: Text('Apakah Anda yakin ingin menghapus penumpang ini?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            _deletePenumpang(penumpang.id!);
                            Navigator.of(context).pop();
                          },
                          child: Text('Hapus'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
                onTap: () { 
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPenumpangPage(penumpang: penumpang),
                      ),
                    ).then((_) => _loadPenumpangs()); 
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
