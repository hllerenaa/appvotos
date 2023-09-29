import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class User {
  final int id;
  final int cab;
  final String fullName;
  final String first_name;
  final String last_name;
  final String? provincia;
  final String? canton;

  User({
    required this.id,
    required this.cab,
    required this.fullName,
    required this.first_name,
    required this.last_name,
    this.provincia,
    this.canton,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'cab': cab,
        'fullName': fullName,
        'first_name': first_name,
        'last_name': last_name,
        'provincia': provincia,
        'canton': canton,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        cab: json['cab'],
        fullName: json['fullName'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        provincia: json['provincia'],
        canton: json['canton'],
      );
}

class UserSingleton {
  // Crear una instancia privada del singleton
  static final UserSingleton _instance = UserSingleton._privateConstructor();

  // Constructor privado
  UserSingleton._privateConstructor();

  // Proveer una instancia pública para acceder al singleton
  static UserSingleton get instance => _instance;

  User? currentUser;

  Future<void> saveUserToPrefs() async {
    if (currentUser != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(currentUser!.toJson()));
    }
  }

  Future<void> loadUserFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString('user');
    if (userString != null) {
      currentUser = User.fromJson(jsonDecode(userString));
    }
  }

  void clear() {
    currentUser = null;
  }
}

extension UserContextExtensions on BuildContext {
  UserSingleton get userSingleton => UserSingleton.instance;
  User? get currentUser => userSingleton.currentUser;
  int? get userId => currentUser?.id;
  int? get cabId => currentUser?.cab;
  String? get userFullName => currentUser?.fullName;
  String? get userFirstName => currentUser?.first_name;
  String? get userLastName => currentUser?.last_name;
  String? get userprovincia => currentUser?.provincia;
  String? get usercanton => currentUser?.canton;
}
