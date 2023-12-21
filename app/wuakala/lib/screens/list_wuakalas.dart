import 'package:wuakala/screens/new_report.dart';
import 'package:wuakala/screens/view_details.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types

class Report {
  //modificar logica por api
  final String place;
  final String author;
  final DateTime date;
  Report({required this.place, required this.author, required this.date});
}

// ignore: camel_case_types
class listWuakalas extends StatefulWidget {
  const listWuakalas({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _listWuakalasState createState() => _listWuakalasState();
}

// ignore: camel_case_types
class _listWuakalasState extends State<listWuakalas> {
  List<Report> reports = [
    //modificar logica por api
    Report(place: 'Place1', author: 'Autor1', date: DateTime.now()),
    Report(place: 'Place2', author: 'Autor2', date: DateTime.now()),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Wuakalas'),
      ),
      body: ListView.builder(
        itemCount: reports.length, //modificar logica api
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(reports[index].place), //modificar logica api
            subtitle: Text(
                'por @${reports[index].author} - ${reports[index].date}'), //modificar logica api
            onTap: () {
              // Navegar a la pantalla de detalles al tocar un elemento
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => viewDetails(), //modificar logica api
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //modificar logica api
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const newReport()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
