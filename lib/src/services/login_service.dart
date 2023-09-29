import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:appvotos/src/widget/extends_files.dart';
import 'package:appvotos/src/services/jwt_service.dart';
import 'package:appvotos/src/models/user_singleton.dart';

class LoginService {
  final TextEditingController usernameController = TextEditingController();
  final JWTService _jwtService =
      JWTService(); // <-- instancia de tu nuevo servicio JWT

  Future<bool> authenticateUser(BuildContext context) async {
    if (usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Complete el formulario',
            style: TextStyle(color: Colors.white),  // Texto blanco
          ),
          backgroundColor: Colors.orange,  // Fondo naranja
        ),
      );
      return false;
    }

    try {
      final response = await _sendLoginRequest(
        usernameController.text,
      );
      if (response['success']) {
        final token = response['data']['token'] ?? '';
        if (token.isEmpty) {
          throw Exception('Token not received from server.');
        }
        // Guardar el JWT
        await _jwtService.saveToken(token);
        // Guardar el modelo USER
        User loggedInUser = User(
            id: response['data']['user']['id'],
            cab: response['data']['user']['cab'],
            fullName: response['data']['user']['fullName'],
            first_name: response['data']['user']['first_name'],
            last_name: response['data']['user']['last_name'],
            canton: response['data']['user']['canton'],
            provincia: response['data']['user']['provincia']);
        UserSingleton.instance.currentUser = loggedInUser;
        await UserSingleton.instance.saveUserToPrefs();
        // Luego de guardar, inicializa el UserSingleton con los valores de SharedPreferences
        await UserSingleton.instance.loadUserFromPrefs();
        // Luego de guardar, puedes navegar a la pantalla principal o hacer lo que necesites
        Navigator.of(context).pushReplacementNamed('/menu');
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response['msg'],
              style: TextStyle(color: Colors.white),  // Texto blanco
            ),
            backgroundColor: Colors.orange,  // Fondo naranja
          ),
        );
        return false;
      }
    } catch (error) {
      if (error is SocketException) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          confirmBtnText: 'Ok',
          title: '',
          text: 'Error de conexión: $error',
        );
        return false;
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          confirmBtnText: 'Ok',
          title: '',
          text: 'Error inesperado: $error',
        );
        return false;
      }
    }
  }

  Future<Map<String, dynamic>> _sendLoginRequest(
      String username) async {
    final url = '${urlConsumo}/api/v1/auth/';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'dni': username,
      }),
    );

    return json.decode(response.body);
  }
}
