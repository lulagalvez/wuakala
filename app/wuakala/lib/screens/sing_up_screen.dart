import 'package:flutter/material.dart';
import 'package:wuakala/users.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyFormSingUp extends StatefulWidget {
  const MyFormSingUp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyFormSingUp> {
  final UserRepository _userRepository =
      UserRepository(); //modificar logica api
  final TextEditingController _signupUsernameController =
      TextEditingController();
  final TextEditingController _signupPasswordController =
      TextEditingController();
  final TextEditingController _signupConfirmPasswordController =
      TextEditingController();
  final TextEditingController _signupEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_final_fields
  bool _isPasswordVisible = false, _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/', ModalRoute.withName('/'));
          },
        ),
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _signupEmailController,
                  decoration: const InputDecoration(
                      labelText: 'Email', hintText: 'Ej: example1@adress.com'),
                  validator: Validators.compose([
                    Validators.required('Email requerido'),
                    Validators.email('Email en formato incorrecto')
                  ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _signupPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Ej: SafePassword1',
                    labelText: 'Contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: Validators.compose([
                    Validators.required('Contraseña requerida'),
                    Validators.patternString(
                        r'^[0-9a-zA-Z]+$', 'Contraseña inválida')
                  ]),
                  obscureText: !_isPasswordVisible,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _signupConfirmPasswordController,
                  decoration: InputDecoration(
                      labelText: 'Confirmar contraseña',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      )),
                  obscureText: !_isConfirmPasswordVisible,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: _signupUsernameController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: Validators.required('Nombre requerido')),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _handleSignup(context);
                  },
                  child: const Text('Registrarse'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignup(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String username = _signupUsernameController.text;
      String password = _signupPasswordController.text;
      String email = _signupEmailController.text;

      try {
        var url = Uri.parse('http://10.0.2.2:5000/register');
        var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': username,
            'email': email, // Assuming email and username are the same
            'password': password,
          }),
        );

        if (response.statusCode == 201) {
          // Registration successful
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Registro Exitoso'),
                content:
                    Text('¡Bienvenido, $username! Tu cuenta ha sido creada.'),
                actions: <Widget>[
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', ModalRoute.withName('/'));
                      },
                      child: const Text('OK'),
                    ),
                  ),
                ],
              );
            },
          );
        } else if (response.statusCode == 400) {
          // Email already registered
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content:
                    const Text('El nombre de usuario ya se encuentra en uso.'),
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
        } else if (response.statusCode == 401) {
          // Email already registered
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content:
                    const Text('El correo electrónico ya está registrado.'),
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
          // Other error occurred
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text(
                    'Ocurrió un error al registrar. Por favor, inténtalo de nuevo.'),
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
      } catch (error) {
        print('Error occurred: $error');
        // Handle other error scenarios
      }
    }
  }
}
