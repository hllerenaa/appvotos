import 'package:appvotos/src/widget/extends_files.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:appvotos/src/pages/home/confirmacion.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isLoading = true;
  List<Map<String, dynamic>> listElectorales = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchData() async {
    if (!mounted) {
      return; // Evitar actualizaciones de estado si el widget ya no está montado
    }

    try {
      final queryParams = {'action': 'loadListas', 'cab': '${context.cabId}'};
      final response = await BackendService.get('${urlConsumo}/api/v1/home/',
          params: queryParams);
      if (response['success']) {
        final list = response['listElectorales'] as List;
        listElectorales =
            list.map((item) => item as Map<String, dynamic>).toList();
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  List<Map> botonesFinalList(BuildContext context) {
    return [
      {
        "image": Images.search,
        "text": "Realizar nueva consulta",
        "onTap": () {
          Get.defaultDialog(
            backgroundColor: ColorResources.white,
            contentPadding: EdgeInsets.zero,
            title: "",
            titlePadding: EdgeInsets.zero,
            content: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  boldText("", ColorResources.blue1D3, 18),
                  SizedBox(height: 10),
                  regularText(
                      "Siempre puede acceder a su contenido volviendo a consultar su número de documento",
                      ColorResources.grey6B7,
                      16,
                      TextAlign.center),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child:
                            regularText("Cancelar", ColorResources.blue1D3, 16),
                      ),
                      SizedBox(width: 30),
                      SizedBox(
                        height: 50,
                        child: VerticalDivider(
                          color: ColorResources.greyEDE,
                          thickness: 1,
                          indent: 10,
                          endIndent: 0,
                          width: 20,
                        ),
                      ),
                      SizedBox(width: 30),
                      InkWell(
                        onTap: () async {
                          await JWTService().logout();
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: mediumText(
                            "Confirmar", ColorResources.blue1D3, 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List2 = botonesFinalList(context);
    return Scaffold(
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
              'ELECCIONES PRESIDENCIALES 2023',
              style: TextStyle(
                color: ColorResources.blue1D3,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: ColorResources.white,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boldText(
                        '¡Hola ${context.userFullName}, el CNE ha implementado mecanismos de acceso al voto con el objetivo de facilitar el ejercicio del sufragio!',
                        ColorResources.grey6B7,
                        15),
                    SizedBox(height: 20),
                    GridView.count(
                      padding: EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 50),
                      childAspectRatio:
                          MediaQuery.of(context).size.aspectRatio * 2.6 / 1.7,
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      children: List.generate(
                        listElectorales.length,
                        (index) => InkWell(
                          onTap: () {},
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    contentPadding: EdgeInsets.all(16),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.network(
                                          '${urlConsumo}/media/${listElectorales[index]["logo_file"]}',
                                          height: 100,
                                          width: 100,
                                        ),
                                        SizedBox(height: 16),
                                        Center(
                                          child: Text(
                                              utf8.decode(listElectorales[index]
                                                      ["nombre"]
                                                  .codeUnits),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Text(
                                            'Estàs por confirmar la elección, esta acción es irreversible',
                                            style: TextStyle(fontSize: 12)),
                                        // Replace with actual list name
                                        SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: 125,
                                              child: ElevatedButton(
                                                child: Text('No'),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors
                                                      .red, // Reemplaza TU_COLOR_DESEADO con el color que quieras.
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 125,
                                              child: ElevatedButton(
                                                child: Text('Sí'),
                                                onPressed: () async {
                                                  setState(() {
                                                    isLoading = true;
                                                  });

                                                  final response =
                                                      await BackendService.get(
                                                          '${urlConsumo}/api/v1/home/',
                                                          params: {
                                                        'action': 'vote',
                                                        'userId':
                                                            '${context.userId}',
                                                        'listaId':
                                                            listElectorales[
                                                                    index]["id"]
                                                                .toString()
                                                      });

                                                  if (response['success']) {
                                                    Get.to(ConfirmacionPage(),
                                                        arguments: {
                                                          'id': listElectorales[
                                                              index]["id"]
                                                        });
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        title: Text('Error'),
                                                        content: Text(
                                                            response['msg']),
                                                        actions: [
                                                          TextButton(
                                                            child: Text('OK'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }

                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: ColorResources.white,
                                border: Border.all(
                                    color: ColorResources.greyE5E, width: 1),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 25, bottom: 20, left: 12, right: 12),
                                child: Column(
                                  children: [
                                    Image.network(
                                      '${urlConsumo}/media/${listElectorales[index]["logo_file"]}',
                                      height: 100,
                                      width: 100,
                                    ),
                                    SizedBox(height: 10),
                                    boldText(
                                        utf8.decode(listElectorales[index]
                                                ["nombre"]
                                            .codeUnits),
                                        ColorResources.blue1D3,
                                        11),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      itemCount: List2.length,
                      padding: EdgeInsets.only(top: 25, left: 10, right: 10),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: InkWell(
                          onTap: List2[index]["onTap"],
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorResources.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 0,
                                  offset: Offset(0, 0),
                                  color: ColorResources.black.withOpacity(0.25),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: Container(
                                height: 100,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: SvgPicture.asset(
                                    List2[index]["image"],
                                  ),
                                ),
                              ),
                              title: mediumText(List2[index]["text"],
                                  ColorResources.orangeFB9, 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
