import 'dart:io';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class newReport extends StatefulWidget {
  const newReport({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _newReportState createState() => _newReportState();
}

// ignore: camel_case_types
class _newReportState extends State<newReport> {
  final TextEditingController _textFieldController1 = TextEditingController();
  final TextEditingController _textFieldController2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _image1;
  File? _image2;

  Future<void> _getImageFromCamera(int imageIndex) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        if (imageIndex == 1) {
          _image1 = File(pickedFile.path);
        } else if (imageIndex == 2) {
          _image2 = File(pickedFile.path);
        }
      }
    });
  }

  Future<void> _postReport() async {
    if (_formKey.currentState!.validate()) {
      String? image1Base64 =
          _image1 != null ? base64Encode(await _image1!.readAsBytes()) : null;
      String? image2Base64 =
          _image2 != null ? base64Encode(await _image2!.readAsBytes()) : null;

      // Prepare report data
      Map<String, dynamic> reportData = {
        'sector': _textFieldController1.text,
        'description': _textFieldController2.text,
        'image1': image1Base64,
        'image2': image2Base64,
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

      if (accessToken != null && accessToken.isNotEmpty) {
        var headers = <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        };

        final response = await http.post(
          Uri.parse('http://10.0.2.2:5000/posts'),
          headers: headers,
          body: jsonEncode(reportData),
        );

        if (response.statusCode == 201) {
          // ignore: use_build_context_synchronously
          _textFieldController1.clear();
          _textFieldController2.clear();
          setState(() {
            _image1 = null;
            _image2 = null;
          });
        } else {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reportar Wuakala'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  validator:
                      Validators.required('Este campo no puede estar vacío'),
                  controller: _textFieldController1,
                  decoration: const InputDecoration(
                    hintText: 'Sector',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLength: 300,
                  maxLines: 8,
                  validator: Validators.compose([
                    Validators.required('Debes agregar una descripción'),
                    Validators.minLength(
                        15, 'Tu descripción debe tener mínimo 15 caracteres')
                  ]),
                  controller: _textFieldController2,
                  decoration: const InputDecoration(
                    hintText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                ),
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
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_image1 == null && _image2 == null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                  '¡Debes subir mínimo 1 fotografía!'),
                              actions: <Widget>[
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        _postReport();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                  '¡Denuncia realizada correctamente!'),
                              actions: <Widget>[
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: const Text('Denunciar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer(int imageIndex) {
    return Column(
      children: [
        InkWell(
          onTap: () => _getImageFromCamera(imageIndex),
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
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('¿Seguro que desea eliminar imagen?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          if (imageIndex == 1) {
                            _image1 = null;
                          } else if (imageIndex == 2) {
                            _image2 = null;
                          }
                        });
                      },
                      child: const Text('Si'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('Eliminar Imagen'),
        ),
      ],
    );
  }

  Widget _imageContainerContent(int imageIndex) {
    File? image = imageIndex == 1 ? _image1 : _image2;

    if (image != null) {
      return Image.file(
        image,
        fit: BoxFit.cover,
      );
    } else {
      return Center(
        child: IconButton(
          iconSize: 40,
          onPressed: () => _getImageFromCamera(imageIndex),
          icon: const Icon(Icons.cloud_upload),
        ),
      );
    }
  }

  Future<bool> _onWillPopScope() async {
    bool userConfirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Seguro que desea salir?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );
    return userConfirmed;
  }
}
