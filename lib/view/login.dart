import 'package:flutter/material.dart';
import 'package:prueba_simpleagri/conexion/verify_connectivity.dart';
import 'package:prueba_simpleagri/controlador/login.dart';
import 'package:prueba_simpleagri/widgets/Dialogo.dart';
import 'package:prueba_simpleagri/widgets/button_pill.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController controllerUser = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  ControladorLogin controlador = ControladorLogin();

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          Image.asset(
            'images/logoSA.png',
            width: 200,
          ),
          input("Ingrese Usuario", "Usuario", false, controllerUser),
          const SizedBox(height: 20),
          input("Ingrese Contraseña" , "Contraseña", true, controllerPassword),
          const SizedBox(height: 40),
          ButtonPill(text: "Ingresar",
            onPressed: () {
              go(context);
            },
          ),
          const SizedBox(height: 140),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Versión App: 1.0.1"),
            ],
          ),
        ],
      ),
    );
  }

  Widget input(String hintText, String labelText, bool pwd,
      TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: pwd ? _obscureText : false,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        hintText: hintText,
        suffix: pwd
            ? GestureDetector(
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      onFieldSubmitted: (value) => go(context),
    );
  }

  Future<void> go(context) async {
   // _loading.show(context);
    final String user = controllerUser.text.trim();
    final String password = controllerPassword.text.trim();
    if (user.isEmpty) {
      controllerUser.clear();
      Dialogo().showAlert(context,"Por favor ingrese un usuario");
    } else if (password.isEmpty) {
      controllerPassword.clear();
      Dialogo().showAlert(context,"Por favor ingrese su contraseña");
    } else {
      if (await VerifyConnectivity().netPing() == true) {
      //  try {

          var result = await controlador.verificacionUsuario(context: context, usuario: user, password: password);

          if( result ){
            Navigator.of(context).pushNamed('/menu');
          }

      } else {
        Dialogo().showAlert(context,"Sin conexión a internet!");
      }
    }
  }


}