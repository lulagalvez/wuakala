import 'package:flutter/material.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class Comment {
  //modificar logica por api
  final String data;
  final String author;
  final DateTime date;
  Comment({required this.data, required this.author, required this.date});
}

// ignore: camel_case_types
class viewDetails extends StatefulWidget {
  const viewDetails({super.key});

  @override
  State<viewDetails> createState() => _viewDetailsState();
}

// ignore: camel_case_types
class _viewDetailsState extends State<viewDetails> {
  List<Comment> comments = [
    //modificar logica por api
    Comment(
        data: 'Data from this comment', author: 'Autor1', date: DateTime.now()),
    Comment(
        data: 'Data from this comment', author: 'Autor2', date: DateTime.now()),
  ];
  final TextEditingController _textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Place1:', //modificar logica api
          ),
          const SizedBox(
            height: 10,
          ),
          Text('Descripcion larga'), //modificar logica api
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
                  ),
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
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Center(child: Text('Subido por @')), //modificar logica api
          const SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                onPressed: () {},
                child: Text('Sigue ahi()')), //modificar logica api
            const SizedBox(
              width: 50,
            ),
            ElevatedButton(
                onPressed: () {},
                child: Text('Ya no esta()')) //modificar logica api
          ]),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: Validators.required('Este campo no puede estar vacío'),
            controller: _textFieldController,
            decoration:
                const InputDecoration(hintText: 'Agrega un comentario...'),
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
                'por @${comments[index].author} - ${comments[index].date}'), //modificar logica api
            onTap: () {}, //modificar logica api
          ),
        );
      },
    );
  }
}
