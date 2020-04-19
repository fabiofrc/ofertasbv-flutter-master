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
  double distanciaKilomentros = 0.0;

  Geolocator geolocator;
  Position position;

  Completer<GoogleMapController> completer = Completer<GoogleMapController>();
  var formatadorNumber = NumberFormat("#0.0##", "pt_BR");

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

  onMapTypeButtonPressed() {
    setState(() {
      mapType = mapType == MapType.normal ? MapType.satellite : MapType.normal;
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
    tilt: 59.440,
    zoom: 16.0,
  );

  Future<void> goToPosition() async {
    final GoogleMapController controller = await completer.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(posicaoCamera));
  }

  movimentarCamera(double latitude, double longitude) async {
    GoogleMapController googleMapController = await completer.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 16.0, tilt: 54),
      ),
    );
  }

  calcularDistancia(double latMercado, double longMercado) async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    double distanciaMetros = await Geolocator().distanceBetween(
        position.latitude, position.longitude, latMercado, longMercado);
    distanciaKilomentros = distanciaMetros / 1000;
    print(" distancia : ${distanciaKilomentros.toStringAsPrecision(2)} km}");
    return distanciaKilomentros;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('localização comercial', style: GoogleFonts.lato()),
      ),
      body: Stack(
        children: <Widget>[

          Container(
            //height: double.infinity,
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
                        calcularDistancia(
                            p.enderecos[0].latitude, p.enderecos[0].longitude);
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
                  mapType: mapType,
                  onMapCreated: criarMapa,
                  initialCameraPosition: posicaoCamera,
                  markers: Set.of(allMarkers),
                );
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 60, right: 8),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: onMapTypeButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.redAccent,
                    child: Icon(
                      Icons.map,
                      size: 36,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  FloatingActionButton(
                    onPressed: goToPosition,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.redAccent,
                    child: Icon(
                      Icons.location_searching,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 120,
              color: Colors.transparent,
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.only(bottom: 0),
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
            duration: Duration(seconds: 2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]),
              color: p.nome == selectedCard ? Colors.grey[400] : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            width: 270,
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.only(left: 10),
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
                    padding: EdgeInsets.all(10),
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
                        ListTile(
                          leading: Icon(Icons.directions_run),
                          trailing: Text(
                            "${distanciaKilomentros.toStringAsPrecision(2)} km",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
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
            calcularDistancia(
                p.enderecos[0].latitude, p.enderecos[0].longitude);
            showToast(p.nome, p.enderecos[0].numero);
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
