import 'package:flutter/material.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wuakala/screens/image_open.dart';
import 'dart:typed_data';

class Comment {
  final String data;
  final String author;
  final DateTime date;
  Comment({required this.data, required this.author, required this.date});
}

// ignore: camel_case_types
class viewDetails extends StatefulWidget {
  final int report; // Include the Report object as a parameter

  const viewDetails({Key? key, required this.report}) : super(key: key);

  @override
  State<viewDetails> createState() => _viewDetailsState();
}

// ignore: camel_case_types
class _viewDetailsState extends State<viewDetails> {
  List<Comment> comments = [];
  final TextEditingController _textFieldController = TextEditingController();

  late String place = '';
  late String description = '';
  late DateTime date = DateTime.now();
  late String posterUsername = '';
  late String image1 = '';
  late String image2 = '';
  late int is_still_there = 0;
  late int is_no_longer_there = 0;

  @override
  void initState() {
    super.initState();
    _getPostDetails();
  }

  Future<void> createComment(String content, int postID) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

      if (accessToken != null && accessToken.isNotEmpty) {
        var headers = <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
          'Connection': 'Keep-Alive:',
          'Keep-Alive': 'timeout=600, max=1000',
        };

        var response = await http.post(
          Uri.parse('http://10.0.2.2:5000/comments/$postID'),
          headers: headers,
          body: jsonEncode(<String, String>{
            'content': content,
          }),
        );

        if (response.statusCode == 200) {
          print('Comment created successfully');
          setState(() {
            comments.add(
              Comment(
                data: content,
                author: 'Tu',
                date: DateTime.now(),
              ),
            );
          });
        } else {
          print(
              'Failed to create comment. Status code: ${response.statusCode}');
        }
      } else {
        print('Access token is missing or empty');
      }
    } catch (error) {
      print('Caught error: $error');
    }
  }

  Future<void> _incrementIsStillThere(int postID) async {
    try {
      var response = await http.patch(
        Uri.parse('http://10.0.2.2:5000/posts/$postID/is_still_there'),
      );

      if (response.statusCode == 200) {
        setState(() {
          is_still_there++; // Increment the value in Flutter state
        });
        print("Actualizado exitosamente");
      } else {
        print("Problemas al actualizar");
      }
    } catch (error) {
      print("Caught error: $error");
    }
  }

  Future<void> _incrementIsNoLongerThere(int postID) async {
    try {
      var response = await http.patch(
        Uri.parse('http://10.0.2.2:5000/posts/$postID/is_no_longer_there'),
      );

      if (response.statusCode == 200) {
        setState(() {
          is_no_longer_there++; // Increment the value in Flutter state
        });
        print("Actualizado exitosamente");
      } else {
        print("Problemas al actualizar");
      }
    } catch (error) {
      print("Caught error: $error");
    }
  }

  // Add a method to fetch comments by post ID
  Future<void> _getCommentsForPost(int postID) async {
    try {
      var response =
          await http.get(Uri.parse('http://10.0.2.2:5000/comments/$postID'));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        List<dynamic> commentsData = responseData['comments'];

        setState(() {
          comments = commentsData
              .map((comment) => Comment(
                    data: comment['content'],
                    author: comment['poster_username'],
                    date: DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'")
                        .parse(comment['date']),
                  ))
              .toList();
        });
      } else {
        print("Comentarios no pudieron ser obtenidos");
      }
    } catch (error) {
      print("Caught error: $error");
    }
  }

  Future<void> _getPostDetails() async {
    try {
      var response = await http
          .get(Uri.parse('http://10.0.2.2:5000/posts/${widget.report}'));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> postDetails = responseData['post'];

        setState(() {
          place = postDetails['sector'];
          description = postDetails['description'];
          date = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'")
              .parse(postDetails['date']);
          posterUsername = postDetails['poster_username'];
          image1 = postDetails['image1'];
          image2 = postDetails['image2'] ?? '';
          is_still_there = postDetails['is_still_there'];
          is_no_longer_there = postDetails['is_no_longer_there'];
        });
        await _getCommentsForPost(widget.report);
      } else {
        print("Detalles de post no pudieron ser obtenidos");
      }
    } catch (error) {
      print("Caught error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(description),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildImageContainer(1),
              const SizedBox(
                width: 40,
              ),
              _buildImageContainer(2),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
              child:
                  Text('Subido por @$posterUsername')), //modificar logica api
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _incrementIsStillThere(widget.report);
                },
                child: Text('Sigue ahi($is_still_there)'),
              ),
              const SizedBox(
                width: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  _incrementIsNoLongerThere(widget.report);
                },
                child: Text('Ya no esta($is_no_longer_there)'),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: Validators.required('Este campo no puede estar vacío'),
            controller: _textFieldController,
            decoration:
                const InputDecoration(hintText: 'Agrega un comentario...'),
            onFieldSubmitted: (value) {
              if (value.isNotEmpty) {
                createComment(value, widget.report);
                _textFieldController.clear();
              } else {
                print("Comentario vacio");
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(child: _generateComments())
        ]),
      ),
    );
  }

  ListView _generateComments() {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return Center(
          child: ListTile(
            title: Text(comments[index].data),
            subtitle: Text(
                'por @${comments[index].author} - ${comments[index].date}'),
            onTap: () {}, //modificar logica api
          ),
        );
      },
    );
  }

  Widget _buildImageContainer(int imageIndex) {
    return InkWell(
      onTap: () => _navigateToImageDetail(imageIndex),
      child: Hero(
        tag: 'image$imageIndex',
        child: Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 68, 68, 68).withOpacity(0.5),
                spreadRadius: 0.1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: _imageContainerContent(imageIndex),
        ),
      ),
    );
  }

  Widget _imageContainerContent(int imageIndex) {
    String base64Image = (imageIndex == 1)
        ? image1
        : image2; // Assuming image1 and image2 contain base64-encoded strings

    if (base64Image.isNotEmpty) {
      Uint8List bytes =
          base64Decode(base64Image); // Convert base64 string to bytes
      return Image.memory(
        bytes,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      );
    } else {
      return Center(
        child: Text('No image available'),
      );
    }
  }

  Future<void> _navigateToImageDetail(int imageIndex) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageDetailScreen(
            imageIndex: imageIndex, image1: image1, image2: image2),
      ),
    );
  }
}
