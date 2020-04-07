//import 'dart:async';
//
//import 'package:bloc_pattern/bloc_pattern.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:intl/intl.dart';
//import 'package:ofertasbv/const.dart';
//import 'package:ofertasbv/src/pessoa/pessoa_controller.dart';
//import 'package:ofertasbv/src/pessoa/pessoa_detalhes.dart';
//import 'package:ofertasbv/src/pessoa/pessoa_model.dart';
//
//class MapaPageApp extends StatefulWidget {
//  @override
//  _MapaPageAppState createState() => _MapaPageAppState();
//}
//
//class _MapaPageAppState extends State<MapaPageApp> {
//  final _bloc = BlocProvider.getBloc<PessoaController>();
//  final pessoa = Pessoa();
//
//  var selectedCard = 'WEIGHT';
//  double distanciaKilomentros = 0;
//
//  Geolocator geolocator;
//  Position position;
//
//  Completer<GoogleMapController> completer = Completer<GoogleMapController>();
//  var formatadorNumber = NumberFormat("##0.0##", "pt_BR");
//
//  List<Marker> allMarkers = [];
//
//  @override
//  void initState() {
//    super.initState();
//    geolocator = Geolocator();
//    LocationOptions locationOptions =
//        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);
//    geolocator.getPositionStream(locationOptions).listen((Position position) {
//      position = position;
//    });
//    _bloc.getAll();
//  }
//
//  Future<void> onRefresh() {
//    return _bloc.getAll();
//  }
//
//  selectCard(cardTitle) {
//    setState(() {
//      selectedCard = cardTitle;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Minha localização e lojas'),
//      ),
//      body: Container(
//        height: MediaQuery.of(context).size.height,
//        width: MediaQuery.of(context).size.width,
//        child: Stack(
//          children: <Widget>[
//            Container(
//              //height: double.infinity,
//              padding: EdgeInsets.only(top: 100),
//              child: StreamBuilder(
//                stream: _bloc.outController,
//                builder: (context, snapshot) {
//                  if (snapshot.hasError) {
//                    return Center(
//                      child: Text("não foi possivel buscar pessoas"),
//                    );
//                  }
//                  if (!snapshot.hasData) {
//                    return Center(
//                      child: CircularProgressIndicator(),
//                    );
//                  }
//
//                  List<Pessoa> pessoas = snapshot.data;
//
//                  allMarkers = pessoas.map((p) {
//                    return Marker(
//                        icon: BitmapDescriptor.defaultMarkerWithHue(
//                            BitmapDescriptor.hueOrange),
//                        infoWindow: InfoWindow(
//                          title: p.nome,
//                          snippet: p.endereco.logradouro,
//                        ),
//                        markerId: MarkerId(p.nome),
//                        position: LatLng(p.endereco.latitude ?? 0.0,
//                            p.endereco.longitude ?? 0.0),
//                        onTap: () {
//                          calcularDistancia(
//                              p.endereco.latitude, p.endereco.longitude);
//                          showDialogAlert(context, p);
//                        });
//                  }).toList();
//
//                  return GoogleMap(
//                    onTap: (pos) {
//                      print(pos);
//                    },
//                    myLocationEnabled: true,
//                    myLocationButtonEnabled: true,
//                    rotateGesturesEnabled: true,
//                    trafficEnabled: false,
//                    mapType: MapType.normal,
//                    onMapCreated: criarMapa,
//                    initialCameraPosition: posicaoCamera,
//                    markers: Set.of(allMarkers),
//                  );
//                },
//              ),
//            ),
//            Container(
//              height: 100,
//              color: Colors.transparent,
//              padding: EdgeInsets.all(2),
//              child: StreamBuilder(
//                stream: _bloc.outController,
//                builder: (context, snapshot) {
//                  if (snapshot.hasError) {
//                    return Center(
//                      child: Text("não foi possivel buscar pessoas"),
//                    );
//                  }
//                  if (!snapshot.hasData) {
//                    return Center(
//                      child: CircularProgressIndicator(),
//                    );
//                  }
//                  List<Pessoa> pessoas = snapshot.data;
//
//                  return RefreshIndicator(
//                    onRefresh: onRefresh,
//                    child: builderList(pessoas),
//                  );
//                },
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  builderList(List<Pessoa> pessoas) {
//    return ListView.builder(
//      scrollDirection: Axis.horizontal,
//      itemCount: pessoas.length,
//      itemBuilder: (context, index) {
//        Pessoa p = pessoas[index];
//        return GestureDetector(
//          child: Card(
//            color: Colors.transparent,
//            margin: EdgeInsets.all(1),
//            elevation: 0.0,
//            child: AnimatedContainer(
//              duration: Duration(seconds: 1),
//              decoration: BoxDecoration(
//                border: Border.all(color: Colors.grey[300]),
//                color: p.nome == selectedCard ? Colors.blue[900] : Colors.white,
//                borderRadius: BorderRadius.circular(10),
//              ),
//              width: 200,
//              padding: EdgeInsets.all(2),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.stretch,
//                children: <Widget>[
//                  ListTile(
//                    leading: CircleAvatar(
//                      child: Text(
//                        p.nome.substring(0, 1).toUpperCase(),
//                        style: TextStyle(fontWeight: FontWeight.w600),
//                      ),
//                      backgroundColor: Colors.grey[300],
//                      foregroundColor: Colors.orangeAccent,
//                    ),
//                    title: Text(
//                      p.nome,
//                      style: TextStyle(
//                        fontSize: 14,
//                        color: Colors.orangeAccent,
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
//                    subtitle: Text(
//                      p.endereco.numero,
//                      style: TextStyle(
//                        fontSize: 14,
//                        color: p.endereco.numero == selectedCard
//                            ? Colors.white
//                            : Colors.grey.withOpacity(0.9),
//                        fontWeight: FontWeight.w600,
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//          onTap: () {
//            selectCard(p.nome);
//            movimentarCamera(p.endereco.latitude, p.endereco.longitude);
//            calcularDistancia(p.endereco.latitude, p.endereco.longitude);
//            showToast(p.nome, p.endereco.numero);
//          },
//        );
//      },
//    );
//  }
//
//  void criarMapa(GoogleMapController controller) {
//    completer.complete(controller);
//  }
//
//  Marker markers(Pessoa p) {
//    return Marker(
//      markerId: MarkerId(p.nome),
//      position: LatLng(p.endereco.latitude, p.endereco.longitude),
//      infoWindow: InfoWindow(title: p.nome, snippet: p.endereco.logradouro),
//      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//    );
//  }
//
//  CameraPosition posicaoCamera = CameraPosition(
//    target: LatLng(2.817, -60.690),
//    zoom: 10,
//  );
//
//  movimentarCamera(double latitude, double longitude) async {
//    GoogleMapController googleMapController = await completer.future;
//    googleMapController.animateCamera(
//      CameraUpdate.newCameraPosition(
//        CameraPosition(target: LatLng(latitude, longitude), zoom: 18, tilt: 54),
//      ),
//    );
//  }
//
//  calcularDistancia(double latMercado, double longMercado) async {
//    Position position = await Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//
//    double distanciaMetros = await Geolocator().distanceBetween(
//        position.latitude, position.longitude, latMercado, longMercado);
//    distanciaKilomentros = distanciaMetros / 1000;
//    print(" distancia : ${formatadorNumber.format(distanciaKilomentros)}");
//    return distanciaKilomentros;
//  }
//
//  showDialogAlert(BuildContext context, Pessoa p) async {
//    return showDialog(
//      context: context,
//      barrierDismissible: false, // user must tap button for close dialog!
//      builder: (BuildContext context) {
//        return AlertDialog(
//          title: Text('Localização'),
//          content: Container(
//            height: 200,
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Text("${p.nome}"),
//                Text("Endereço : ${p.endereco.logradouro}"),
//              ],
//            ),
//          ),
//          actions: <Widget>[
//            FlatButton(
//              child: const Text('CANCELAR'),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//            FlatButton(
//              child: const Text('DETALHES'),
//              onPressed: () {
//                Navigator.of(context).push(
//                  MaterialPageRoute(
//                    builder: (BuildContext context) {
//                      return PessoaDetalhes(p);
//                    },
//                  ),
//                );
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }
//
//  void showToast(String cardTitle, String unit) {
//    Fluttertoast.showToast(
//      msg: "Loja: $cardTitle - $unit $distanciaKilomentros",
//      gravity: ToastGravity.CENTER,
//      timeInSecForIos: 1,
//      backgroundColor: Colors.indigo,
//      textColor: Colors.white,
//      fontSize: 16.0,
//    );
//  }
//}
//
//enum ConfirmAction { CANCEL, ACCEPT }
