import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/loja/loja_controller.dart';
import 'package:ofertasbv/src/loja/loja_detalhes.dart';
import 'package:ofertasbv/src/loja/loja_model.dart';

class LojaLocation extends StatefulWidget {
  @override
  _LojaLocationState createState() => _LojaLocationState();
}

class _LojaLocationState extends State<LojaLocation> {
  final _bloc = GetIt.I.get<LojaController>();
  final pessoa = Loja();

  var selectedCard = 'WEIGHT';
  double distanciaKilomentros = 0;

  //GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
  Geolocator geolocator;
  Position position;

  Completer<GoogleMapController> completer = Completer<GoogleMapController>();
  var formatadorNumber = NumberFormat("#0.0##", "pt_BR");

  List<Marker> allMarkers = [];

  @override
  void initState() {
    super.initState();
    getLocation();
    getCurrentLocation();
    _bloc.getAll();
  }

  selectCard(cardTitle) {
    setState(() {
      selectedCard = cardTitle;
    });
  }

  MapType mapType = MapType.normal;
  static const LatLng center = const LatLng(2.817, -60.690);

  LatLng lastMapPosition = center;

  button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.redAccent,
      child: Icon(icon, size: 36),
    );
  }

  onMapTypeButtonPressedNormal() {
    setState(() {
      mapType = MapType.normal;
    });
  }

  onMapTypeButtonPressedTerra() {
    setState(() {
      mapType = MapType.terrain;
    });
  }

  onMapTypeButtonPressedSatelite() {
    setState(() {
      mapType = MapType.satellite;
    });
  }

  onMapTypeButtonPressedHibrido() {
    setState(() {
      mapType = MapType.hybrid;
    });
  }

  onCamaraMove(CameraPosition position) {
    lastMapPosition = position.target;
  }

  criarMapa(GoogleMapController controller) {
    completer.complete(controller);
  }

  Marker markers(Loja p) {
    return Marker(
      markerId: MarkerId(p.nome),
      position: LatLng(p.enderecos[0].latitude, p.enderecos[0].longitude),
      infoWindow: InfoWindow(title: p.nome, snippet: p.enderecos[0].logradouro),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
  }

  static final CameraPosition posicaoCamera = CameraPosition(
    bearing: 192.833,
    target: LatLng(2.817, -60.690),
    tilt: 54,
    zoom: 16.0,
  );

  getLocation() async {
    try {
      geolocator = Geolocator();
      LocationOptions locationOptions =
          LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);
      geolocator.getPositionStream(locationOptions).listen((Position position) {
        position = position;
      });
    } catch (e) {
      print('ERROR:$e');
    }
  }

  void getCurrentLocation() async {
    Position res = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      position = res;
    });
  }

  Future<void> goToPosition() async {
    final GoogleMapController controller = await completer.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(posicaoCamera));
  }

  movimentarCamera(double latitude, double longitude) async {
    GoogleMapController googleMapController = await completer.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 16.0,
          tilt: 54,
        ),
      ),
    );
  }

  calcularDistancia(double latMercado, double longMercado) async {
    return await geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      latMercado,
      longMercado,
    );
  }

  testeDistancia() async {
    double distanceInMeters = await Geolocator()
        .distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Localzação comercial"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            height: double.infinity,
            padding: EdgeInsets.only(top: 0),
            child: Observer(
              builder: (context) {
                List<Loja> lojas = _bloc.lojas;

                if (_bloc.error != null) {
                  return Text("Não foi possível buscar lojas");
                }

                if (lojas == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                allMarkers = lojas.map((p) {
                  return Marker(
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueOrange),
                      infoWindow: InfoWindow(
                        title: p.nome,
                        snippet: p.enderecos[0].logradouro +
                            ", " +
                            p.enderecos[0].numero,
                      ),
                      markerId: MarkerId(p.nome),
                      position: LatLng(p.enderecos[0].latitude ?? 0.0,
                          p.enderecos[0].longitude ?? 0.0),
                      onTap: () {
                        showDialogAlert(context, p);
                      });
                }).toList();

                return GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  rotateGesturesEnabled: true,
                  trafficEnabled: false,
                  onCameraMove: onCamaraMove,
                  mapType: mapType,
                  onMapCreated: criarMapa,
                  initialCameraPosition: CameraPosition(
                    target: position != null
                        ? LatLng(position.latitude, position.longitude)
                        : lastMapPosition,
                    zoom: 16.0,
                  ),
                  markers: Set.of(allMarkers),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 60, right: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: () {
                      showDialogAlertTypeMap(context);
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: Colors.redAccent,
                    child: Icon(
                      Icons.map,
                      size: 25,
                    ),
                    tooltip: "tipo de mapa",
                    focusElevation: 5,
                    mini: true,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 110,
              color: Colors.transparent,
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.only(bottom: 60),
              child: Observer(
                builder: (context) {
                  List<Loja> pessoas = _bloc.lojas;

                  if (_bloc.error != null) {
                    return Text("Não foi possível buscar lojas");
                  }

                  if (pessoas == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return builderList(pessoas);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  builderList(List<Loja> lojas) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: lojas.length,
      itemBuilder: (context, index) {
        Loja p = lojas[index];

        return GestureDetector(
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            decoration: BoxDecoration(
              color: p.nome == selectedCard ? Colors.grey[300] : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            width: 240,
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 0.9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      ConstantApi.urlArquivoProduto + p.foto,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(p.nome,
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              color: Colors.indigo[600],
                            )),
                        ListTile(
                          leading: Icon(Icons.directions_run),
                          trailing: Text(
                            "0.0 km",
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            selectCard(p.nome);
            movimentarCamera(p.enderecos[0].latitude, p.enderecos[0].longitude);
          },
        );
      },
    );
  }

  showDialogAlert(BuildContext context, Loja p) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Localização',
            style: GoogleFonts.lato(),
          ),
          content: Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${p.nome}"),
                Text("${p.enderecos[0].logradouro}, ${p.enderecos[0].numero}"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('DETALHES'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return LojaDetalhes(
                        loja: p,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  showDialogAlertTypeMap(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Tipo de mapa',
            style: GoogleFonts.lato(),
          ),
          content: Container(
            height: 200,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child: Image.asset(
                            ConstantApi.urlNormal,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          "Padrão",
                          style: GoogleFonts.lato(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    onMapTypeButtonPressedNormal();
                    Navigator.of(context).pop();
                  },
                ),
                GestureDetector(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 60,
                          width: 60,
                          color: Colors.grey[200],
                          child: Image.asset(
                            ConstantApi.urlSatelite,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          "Satélite",
                          style: GoogleFonts.lato(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    onMapTypeButtonPressedSatelite();
                    Navigator.of(context).pop();
                  },
                ),
                GestureDetector(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 60,
                          width: 60,
                          color: Colors.grey[200],
                          child: Image.asset(
                            ConstantApi.urlRelevo,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          "Híbrido",
                          style: GoogleFonts.lato(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    onMapTypeButtonPressedHibrido();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showToast(String cardTitle, String unit) {
    Fluttertoast.showToast(
      msg:
          "Loja: $cardTitle - $unit - ${distanciaKilomentros.toStringAsPrecision(2)} km",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.indigo,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
