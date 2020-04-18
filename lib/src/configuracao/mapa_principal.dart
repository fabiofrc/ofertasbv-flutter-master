import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class MapaPageApp extends StatefulWidget {
  @override
  _MapaPageAppState createState() => _MapaPageAppState();
}

class _MapaPageAppState extends State<MapaPageApp> {
  final _bloc = GetIt.I.get<LojaController>();
  final pessoa = Loja();

  var selectedCard = 'WEIGHT';
  double distanciaKilomentros = 0;

  Geolocator geolocator;
  Position position;

  Completer<GoogleMapController> completer = Completer<GoogleMapController>();
  var formatadorNumber = NumberFormat("##0.0##", "pt_BR");

  List<Marker> allMarkers = [];

  @override
  void initState() {
    super.initState();
    geolocator = Geolocator();
    LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      position = position;
    });
    _bloc.getAll();
  }

  Future<void> onRefresh() {
    return _bloc.getAll();
  }

  selectCard(cardTitle) {
    setState(() {
      selectedCard = cardTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('localização comercial', style: GoogleFonts.lato()),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Container(
              //height: double.infinity,
              padding: EdgeInsets.only(top: 100),
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
                          snippet: p.enderecos[0].logradouro + ", " + p.enderecos[0].numero,
                        ),
                        markerId: MarkerId(p.nome),
                        position: LatLng(p.enderecos[0].latitude ?? 0.0,
                            p.enderecos[0].longitude ?? 0.0),
                        onTap: () {
                          calcularDistancia(p.enderecos[0].latitude,
                              p.enderecos[0].longitude);
                          showDialogAlert(context, p);
                        });
                  }).toList();

                  return GoogleMap(
                    onTap: (pos) {
                      print(pos);
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    rotateGesturesEnabled: true,
                    trafficEnabled: false,
                    mapType: MapType.satellite,
                    onMapCreated: criarMapa,
                    initialCameraPosition: posicaoCamera,
                    markers: Set.of(allMarkers),
                  );
                },
              ),
            ),
            Container(
              height: 100,
              color: Colors.transparent,
              padding: EdgeInsets.all(2),
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

                  return RefreshIndicator(
                    onRefresh: onRefresh,
                    child: builderList(pessoas),
                  );
                },
              ),
            ),
          ],
        ),
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
            duration: Duration(seconds: 2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]),
              color: p.nome == selectedCard ? Colors.grey[100] : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            width: 200,
            padding: EdgeInsets.all(2),
            child: Row(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      ConstantApi.urlArquivoProduto + p.foto,
                      fit: BoxFit.fill,
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
                        Text(
                          p.nome,
                          style: TextStyle(
                            color: Colors.deepPurple[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Nº. ${p.enderecos[0].numero}",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
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
            calcularDistancia(
                p.enderecos[0].latitude, p.enderecos[0].longitude);
            showToast(p.nome, p.enderecos[0].numero);
          },
        );
      },
    );
  }

  void criarMapa(GoogleMapController controller) {
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

  CameraPosition posicaoCamera = CameraPosition(
    target: LatLng(2.817, -60.690),
    zoom: 10,
  );

  movimentarCamera(double latitude, double longitude) async {
    GoogleMapController googleMapController = await completer.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 18, tilt: 54),
      ),
    );
  }

  calcularDistancia(double latMercado, double longMercado) async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    double distanciaMetros = await Geolocator().distanceBetween(
        position.latitude, position.longitude, latMercado, longMercado);
    distanciaKilomentros = distanciaMetros / 1000;
    print(" distancia : ${formatadorNumber.format(distanciaKilomentros)}");
    return distanciaKilomentros;
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
                Text("Endereço : ${p.enderecos[0].logradouro}"),
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

  void showToast(String cardTitle, String unit) {
    Fluttertoast.showToast(
      msg: "Loja: $cardTitle - $unit $distanciaKilomentros",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.indigo,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

enum ConfirmAction { CANCEL, ACCEPT }
