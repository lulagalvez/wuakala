import 'package:wuakala/screens/new_report.dart';
import 'package:wuakala/screens/view_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

// ignore: camel_case_types

class Report {
  final int id;
  final String sector;
  final String posterUsername;
  final DateTime date;

  Report({
    required this.id,
    required this.sector,
    required this.posterUsername,
    required this.date,
  });
}

// ignore: camel_case_types
class listWuakalas extends StatefulWidget {
  const listWuakalas({Key? key}) : super(key: key);

  @override
  _listWuakalasState createState() => _listWuakalasState();
}

// ignore: camel_case_types
class _listWuakalasState extends State<listWuakalas> {
  List<Report> reports = [];

  @override
  void initState() {
    super.initState();
    fetchWuakalas();
  }

  Future<void> fetchWuakalas() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/posts'));
      if (response.statusCode == 200) {
        final List<dynamic> postsJson = json.decode(response.body)['posts'];
        setState(() {
          reports = postsJson
              .map((json) => Report(
                    id: json['id'],
                    sector: json['sector'],
                    posterUsername: json['poster_username'],
                    date: DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'")
                        .parse(json['date']),
                  ))
              .toList();
        });
      } else {
        print('Failed to load wuakalas: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Wuakalas'),
      ),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(reports[index].sector),
            subtitle: Text(
                'por @${reports[index].posterUsername} - ${reports[index].date}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => viewDetails(report: reports[index].id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //modificar logica api
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const newReport()),
          );
          fetchWuakalas();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
