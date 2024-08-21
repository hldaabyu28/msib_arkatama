import 'package:flutter/material.dart';
import 'package:msib_arkatama/screens/Travel_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel CRUD'),
      ),
      body: Column(
        children: [
          TravelPage()
        ],
      ),
    );
  }
}