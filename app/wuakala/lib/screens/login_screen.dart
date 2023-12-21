import 'package:wuakala/screens/list_wuakalas.dart';
import 'package:flutter/material.dart';
import 'package:wuakala/users.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class MyFormLogin extends StatefulWidget {
  const MyFormLogin({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyFormLogin> {
  final UserRepository _userRepository =
      UserRepository(); //modificar logica api
  final TextEditingController _loginUsernameController =
      TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'WUAKALAS APP',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/wuakala.png',
                  scale: 2,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _loginUsernameController,
                  decoration: const InputDecoration(labelText: 'Usuario'),
                  validator: Validators.required('Nombre de usuario requerido'),
                ),
                TextFormField(
                  controller: _loginPasswordController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
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
                  validator: Validators.required('Contraseña requerida'),
                  obscureText: !_isPasswordVisible,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _handleLogin(context);
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  child: const Text('No tienes una cuenta? Regístrate aquí'),
                ),
                const SizedBox(
                  height: 150,
                ),
                const Center(
                    child: Text(
                  'Desarrollado por:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                )),
                const Center(
                  child: Text(
                    'Luis Galves\nOscar Castillo',
                    style: TextStyle(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) {
    String username = _loginUsernameController.text;
    String password = _loginPasswordController.text;
    if (_formKey.currentState!.validate()) {
      if (_userRepository.authenticateUser(username, password)) {
        //modificar logica api
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => listWuakalas(),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'Usuario o contraseña incorrectos. Por favor, inténtalo de nuevo.'),
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
    _formKey.currentState?.reset();
  }
}
