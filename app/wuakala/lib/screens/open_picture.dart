import 'package:flutter/material.dart';

// ignore: camel_case_types
class openImage extends StatefulWidget {
  const openImage({super.key});

  @override
  State<openImage> createState() => _openImageState();
}

// ignore: camel_case_types
class _openImageState extends State<openImage> {
  get onPressed => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Detalle Foto')),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Image.asset('assets/wuakala.png'), //modificar logica api
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Volver'))
          ],
        ),
      ),
    );
  }
}
