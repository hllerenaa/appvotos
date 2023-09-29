// main.dart
import 'package:appvotos/src/helpers/globals.dart';
import 'package:appvotos/src/pages/home/home.dart';
import 'package:appvotos/src/pages/utils/enmantenimiento.dart';
import 'package:flutter/material.dart';
import 'package:appvotos/src/pages/autentication/login.dart';
import 'package:appvotos/src/pages/utils/nointernet.dart';
import 'package:appvotos/src/pages/utils/splash_screen.dart';
import 'package:appvotos/src/services/jwt_service.dart';
import 'package:appvotos/src/models/user_singleton.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSingleton.instance.loadUserFromPrefs();
  runApp(MyApp());
}

Future<bool> checkInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF4A4A4A);
    const btnColor = Color(0xFF40B7AD);
    const bgColor = Color(0xFFF5F5F5);
    return GetMaterialApp(
      title: 'Votaciones 2023',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: btnColor),
          scaffoldBackgroundColor: bgColor,
          textTheme: Theme.of(context)
              .textTheme
              .apply(bodyColor: textColor, displayColor: textColor)),
      routes: {
        '/login': (context) => LoginPage(),
        '/mantenimiento': (context) => MantenimientoPage(),
        '/nointernet': (context) => NoInternetPage(),
        // CUANDO ES RUTA ACCESO DIRECTO POR RUTA USAR AUTHMIDDLEWARE
        '/menu': (context) => AuthMiddleware(
            child: HomePage(),
            checkInternetConnection: checkInternetConnection),
      },
      home: AuthMiddleware(
        child: HomePage(),
        checkInternetConnection: checkInternetConnection,
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class AuthMiddleware extends StatelessWidget {
  final Widget child;
  final Future<bool> Function() checkInternetConnection;

  AuthMiddleware({
    required this.child,
    required this.checkInternetConnection,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<bool>>(
      future: Future.wait(
        [JWTService().isAuthenticated(), checkInternetConnection()],
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        } else if (snapshot.hasData) {
          final isAuthenticated = snapshot.data?[0] ?? false;
          final isConnected = snapshot.data?[1] ?? false;

          if (!isConnected) {
            return NoInternetPage();
          } else {
            return FutureBuilder<http.Response>(
              future: _checkUrlAvailability(urlConsumo),
              builder: (context, responseSnapshot) {
                if (responseSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return SplashScreen();
                } else if (responseSnapshot.hasData) {
                  final response = responseSnapshot.data!;
                  if (response.statusCode != 200) {
                    return MantenimientoPage();
                  } else {
                    if (isAuthenticated) {
                      return child;
                    } else {
                      return LoginPage();
                    }
                  }
                } else if (responseSnapshot.hasError) {
                  return MantenimientoPage();
                }
                return MantenimientoPage();
              },
            );
          }
        } else {
          return MantenimientoPage();
        }
      },
    );
  }

  Future<http.Response> _checkUrlAvailability(String url) async {
    try {
      return http.Response('Ok', 200);
    } catch (e) {
      return http.Response('Error', 500);
    }
  }
}
