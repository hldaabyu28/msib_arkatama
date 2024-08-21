import 'package:flutter/material.dart';
import 'package:msib_arkatama/helpers/database_helper.dart';
import 'package:msib_arkatama/models/travel_model.dart';
import 'package:msib_arkatama/screens/travel_screen.dart';


class TravelListPage extends StatefulWidget {
  @override
  _TravelListPageState createState() => _TravelListPageState();
}

class _TravelListPageState extends State<TravelListPage> {
  List<Travel> _travels = [];

  @override
  void initState() {
    super.initState();
    _loadTravels();
  }

Future<void> _loadTravels() async {
  final dbHelper = DatabaseHelper.instance;
  List<Travel> travels = await dbHelper.getAllTravel(); // Pastikan nama metode sesuai
  setState(() {
    _travels = travels;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Travel'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TravelPage()),
              ).then((_) => _loadTravels());
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _travels.length,
        itemBuilder: (context, index) {
          final travel = _travels[index];
          return ListTile(
            title: Text('Travel ID: ${travel.id}, Kuota: ${travel.kuota}'),
            subtitle: Text('Tanggal Keberangkatan: ${travel.tanggalKeberangkatan}'),
            onTap: () {
              // Arahkan ke halaman edit Travel di sini
            },
          );
        },
      ),
    );
  }
}
