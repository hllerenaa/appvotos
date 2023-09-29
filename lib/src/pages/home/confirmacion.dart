import 'package:flutter/material.dart';
import 'package:appvotos/src/widget/extends_files.dart';

class ConfirmacionPage extends StatefulWidget {
  ConfirmacionPage({Key? key}) : super(key: key);

  @override
  _ConfirmacionPageState createState() => _ConfirmacionPageState();
}

class _ConfirmacionPageState extends State<ConfirmacionPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;  // Esto bloquea el botón de retroceso
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: ColorResources.white,
          automaticallyImplyLeading: false,
          // Para evitar el botón de retroceso
          title: Row(
            children: [
              Image.asset(
                'assets/images/cne.png',
                height: 30, // Puedes ajustar este valor como desees
                width: 30, // Puedes ajustar este valor como desees
              ),
              SizedBox(width: 10), // Espacio entre el logo y el texto
              Text(
                'COMPROBANTE DE VOTACIÓN',
                style: TextStyle(
                  color: ColorResources.blue1D3,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              // Agregado
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: true ? Colors.green : Colors.red,
                        ),
                        child: Icon(
                          true ? Icons.check : Icons.close,
                          color: Colors.white,
                          size: 100,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    buildDataRow('Nombres', '${context.userFirstName}'),
                    buildDataRow('Apellidos', '${context.userLastName}'),
                    buildDataRow('Provincia', '${context.userprovincia}'),
                    buildDataRow('Cantón', '${context.usercanton}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                await JWTService().logout();
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: Container(
                height: 40,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorResources.blue1D3.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 16,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                      color:
                      ColorResources.black111.withOpacity(0.02),
                    ),
                  ],
                  border: Border.all(
                    color: ColorResources.black.withOpacity(0.06),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Images.search,
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 2),
                    mediumText(
                      "Realizar nueva consulta",
                      ColorResources.blue1D3,
                      14,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value)), // Agregado Flexible
        ],
      ),
    );
  }
}
