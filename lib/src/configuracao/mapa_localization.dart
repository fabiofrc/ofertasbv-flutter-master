import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ofertasbv/src/endereco/endereco_model.dart';
import 'dart:async';
import 'dart:io';

class PainelEndereco extends StatefulWidget {
  @override
  _PainelEnderecoState createState() => _PainelEnderecoState();
}

class _PainelEnderecoState extends State<PainelEndereco> {
  TextEditingController _controllerDestino = TextEditingController(text: "Rua Piraíba, 868");

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _posicaoCamera = CameraPosition(target: LatLng(2.817, -60.690), zoom: 10);
  Set<Marker> _marcadores = {};

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _adicionarListenerLocalizacao() {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    geolocator.getPositionStream(locationOptions).listen((Position position) {
      _exibirMarcadorPassageiro(position);

      _posicaoCamera = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 19,
      );

      _movimentarCamera(_posicaoCamera);
    });
  }

  _recuperaUltimaLocalizacaoConhecida() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      if (position != null) {
        _exibirMarcadorPassageiro(position);

        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 19);

        _movimentarCamera(_posicaoCamera);
      }
    });
  }

  _movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _exibirMarcadorPassageiro(Position local) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "assets/images/teste.png")
        .then(
      (BitmapDescriptor icone) {
        Marker marcadorPassageiro = Marker(
            markerId: MarkerId("marcador-passageiro"),
            position: LatLng(local.latitude, local.longitude),
            infoWindow: InfoWindow(title: "Meu local"),
            icon: icone);

        setState(
          () {
            _marcadores.add(marcadorPassageiro);
          },
        );
      },
    );
  }

  _chamarEndereco() async {
    String enderecoDestino = _controllerDestino.text;

    if (enderecoDestino.isNotEmpty) {
      List<Placemark> listaEnderecos =
          await Geolocator().placemarkFromAddress(enderecoDestino);

      if (listaEnderecos != null && listaEnderecos.length > 0) {
        Placemark endereco = listaEnderecos[0];
        Endereco destino = Endereco();
        destino.cidade = endereco.administrativeArea;
        destino.cep = endereco.postalCode;
        destino.bairro = endereco.subLocality;
        destino.logradouro = endereco.thoroughfare;
        destino.numero = endereco.subThoroughfare;

        destino.latitude = endereco.position.latitude;
        destino.longitude = endereco.position.longitude;

        String enderecoConfirmacao;
        enderecoConfirmacao = "\n Cidade: " + destino.cidade;
        enderecoConfirmacao +=
            "\n Rua: " + destino.logradouro + ", " + destino.numero;
        enderecoConfirmacao += "\n Bairro: " + destino.bairro;
        enderecoConfirmacao += "\n Cep: " + destino.cep;

        showDialog(
          context: context,
          builder: (contex) {
            return AlertDialog(
              title: Text("Confirmação do endereço"),
              content: Text(enderecoConfirmacao),
              contentPadding: EdgeInsets.all(16),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => Navigator.pop(contex),
                ),
                FlatButton(
                  child: Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    Navigator.pop(contex);
                  },
                )
              ],
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperaUltimaLocalizacaoConhecida();
    _adicionarListenerLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Painel de endereço"),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _posicaoCamera,
              onMapCreated: _onMapCreated,
              //myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _marcadores,
              //-23,559200, -46,658878
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white),
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.green,
                          ),
                        ),
                        hintText: "Meu local",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15, top: 16)),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 55,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white),
                  child: TextField(
                    controller: _controllerDestino,
                    decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.local_taxi,
                            color: Colors.black,
                          ),
                        ),
                        hintText: "Digite o destino",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15, top: 16)),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Padding(
                padding: Platform.isIOS
                    ? EdgeInsets.fromLTRB(20, 10, 20, 25)
                    : EdgeInsets.all(10),
                child: RaisedButton(
                    child: Text(
                      "Pesquisar endereço",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.grey,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    onPressed: () {
                      _chamarEndereco();
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
