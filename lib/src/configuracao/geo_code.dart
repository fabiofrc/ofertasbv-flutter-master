import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GeoCode extends StatefulWidget {
  @override
  _GeoCodeState createState() => _GeoCodeState();
}

class _GeoCodeState extends State<GeoCode> {
  Completer<GoogleMapController> _controller = Completer();
  String resultado;
  String pesquisa;

  var pesquisaController = TextEditingController();

  CameraPosition _posicaoCamera = CameraPosition(
    target: LatLng(2.817, -60.690),
    zoom: 18,
  );

  Set<Marker> _marcadores = {};
  Set<Polygon> _polygons = {};
  Set<Polyline> _polylines = {};

  _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_posicaoCamera));
  }

  carregarMarcadores() {
    Set<Marker> marcadoresLocal = {};

    Marker marcadorShopping = Marker(
        markerId: MarkerId("marcador-shopping"),
        position: LatLng(-23.563370, -46.652923),
        infoWindow: InfoWindow(title: "Shopping Cidade São Paulo"),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
        onTap: () {
          print("Shopping clicado!!");
        }
        //rotation: 45
        );

    Marker marcadorCartorio = Marker(
        markerId: MarkerId("marcador-cartorio"),
        position: LatLng(-23.562868, -46.655874),
        infoWindow: InfoWindow(title: "12 Cartório de notas"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        onTap: () {
          print("Cartório clicado!!");
        });

    marcadoresLocal.add(marcadorShopping);
    marcadoresLocal.add(marcadorCartorio);

    setState(() {
      _marcadores = marcadoresLocal;
    });
  }

  _calcularDistancia() async {
    double distanciaMetros = await Geolocator()
        .distanceBetween(2.817, -60.690, -23.562868, -46.655874);
    double distanciaKilomentros = distanciaMetros / 1000;
    double valor = distanciaKilomentros * 5;
    print(" distancia : ${distanciaKilomentros}");
    print(" Valor : ${valor}");
  }

//  recuperarLocalizacaoAtual() async {
//    Position position = await Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//
//    setState(() {
//      _posicaoCamera = CameraPosition(
//          target: LatLng(position.latitude, position.longitude), zoom: 17);
//      _movimentarCamera();
//    });
//    print("localizacao atual: " + position.toString());
//  }

  adicionarListenerLocalizacao() {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      print("localizacao atual: " + position.toString());

      Marker marcadorUsuario = Marker(
        markerId: MarkerId("marcador-usuario"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: "Meu local"),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
        onTap: () {
          print("Meu local clicado!!");
        },
      );

      setState(() {
        //_marcadores.add( marcadorUsuario );
        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 17);
        _movimentarCamera();
      });
    });
  }

  _recuperarLocalParaEndereco() async {
    List<Placemark> listaEnderecos = await Geolocator()
        .placemarkFromAddress("R. Piraíba, 668 - Santa Tereza");

    print("total: " + listaEnderecos.length.toString());

    if (listaEnderecos != null && listaEnderecos.length > 0) {
      Placemark endereco = listaEnderecos[0];

      resultado = "\n administrativeArea: " + endereco.administrativeArea;
      resultado += "\n subAdministrativeArea: " + endereco.subAdministrativeArea;
      resultado += "\n locality: " + endereco.locality;
      resultado += "\n subLocality: " + endereco.subLocality;
      resultado += "\n thoroughfare: " + endereco.thoroughfare;
      resultado += "\n subThoroughfare: " + endereco.subThoroughfare;
      resultado += "\n postalCode: " + endereco.postalCode;
      resultado += "\n country: " + endereco.country;
      resultado += "\n isoCountryCode: " + endereco.isoCountryCode;
      resultado += "\n position: " + endereco.position.toString();

      print("ENDEREÇO POR LOGRADOURO: " + resultado);
    }
  }

  _recuperarEnderecoParaLatLong() async {
    List<Placemark> listaEnderecos =
        await Geolocator().placemarkFromCoordinates(2.825975, -60.731599);

    print("total: " + listaEnderecos.length.toString());

    if (listaEnderecos != null && listaEnderecos.length > 0) {
      Placemark endereco = listaEnderecos[0];

      String resultado;

      resultado = "\n administrativeArea " + endereco.administrativeArea;
      resultado += "\n subAdministrativeArea: " + endereco.subAdministrativeArea;
      resultado += "\n locality: " + endereco.locality;
      resultado += "\n subLocality: " + endereco.subLocality;
      resultado += "\n thoroughfare: " + endereco.thoroughfare;
      resultado += "\n subThoroughfare: " + endereco.subThoroughfare;
      resultado += "\n postalCode: " + endereco.postalCode;
      resultado += "\n country: " + endereco.country;
      resultado += "\n isoCountryCode: " + endereco.isoCountryCode;
      resultado += "\n position: " + endereco.position.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    //_carregarMarcadores();
    //_recuperarLocalizacaoAtual();
    //_adicionarListenerLocalizacao();
    //_recuperarLocalParaEndereco();
    //_recuperarEnderecoParaLatLong();
    //_calcularDistancia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Form(
          child: TextFormField(
            controller: pesquisaController,
            onSaved: (valor) => pesquisa = valor,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.white),
              hintText: "pesquisar endereço...",
            ),
            onChanged: (String entrada){
              setState(() {
                pesquisa = entrada;
              });
            },
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
             setState(() {
               print("pesquisa: " + pesquisa);
               //_recuperarLocalParaEndereco();
             });
            },
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: 8,
            height: 8,
          ),
          FloatingActionButton(
            elevation: 10,
            backgroundColor: Colors.blue,
            child: Icon(Icons.done),
            hoverColor: Colors.redAccent,
            onPressed: _movimentarCamera,
          )
        ],
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _posicaoCamera,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          markers: _marcadores,
        ),
      ),
    );
  }
}
