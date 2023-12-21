import 'package:flutter/material.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

// ignore: camel_case_types
class newReport extends StatefulWidget {
  const newReport({super.key});

  @override
  State<newReport> createState() => _newReportState();
}

// ignore: camel_case_types
class _newReportState extends State<newReport> {
  final TextEditingController _textFieldController1 = TextEditingController();
  final TextEditingController _textFieldController2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reportar Wuakala'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(children: [
              TextFormField(
                validator:
                    Validators.required('Este campo no puede estar vacío'),
                controller: _textFieldController1,
                decoration: const InputDecoration(
                    hintText: 'Sector', border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                maxLength: 300,
                maxLines: 8,
                validator: Validators.minLength(
                    15, 'Este campo requiere mínimo 15 caracteres'),
                controller: _textFieldController2,
                decoration: const InputDecoration(
                    hintText: 'Descripción', border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 68, 68, 68)
                                      .withOpacity(0.5),
                                  spreadRadius: 0.1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: Center(
                              child: IconButton(
                                  iconSize: 40,
                                  onPressed: () {},
                                  icon: const Icon(Icons.cloud_upload)))),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {}, //modificar logica api
                          child: const Text('Eliminar Imagen'))
                    ],
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Column(
                    children: [
                      Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 68, 68, 68)
                                      .withOpacity(0.5),
                                  spreadRadius: 0.1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: Center(
                              child: IconButton(
                                  iconSize: 40,
                                  onPressed: () {},
                                  icon: const Icon(Icons.cloud_upload)))),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {}, //modificar logica api
                          child: const Text('Eliminar Imagen'))
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    //modificar logica api
                  },
                  child: const Text('Denunciar'))
            ])));
  }
}
