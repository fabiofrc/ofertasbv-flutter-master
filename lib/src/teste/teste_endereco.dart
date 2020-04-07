import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ofertasbv/src/endereco/endereco_model.dart';

class TesteEndereco extends StatefulWidget {
  @override
  _TesteEnderecoState createState() => _TesteEnderecoState();
}

class _TesteEnderecoState extends State<TesteEndereco> {
  Endereco destino = Endereco();

  var _controllerDestino = TextEditingController(text: "Rua Piraíba, 868");
  var _controllerLogradouro = TextEditingController();
  var _controllerNumero = TextEditingController();
  var _controllerBairro = TextEditingController();
  var _controllerCidade = TextEditingController();
  var _controllerCep = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Endereço"),
        elevation: 0.0,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _controllerDestino,
                    decoration: InputDecoration(
                      labelText: "Pesquisa",
                      hintText: "Digite o destino",
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _controllerLogradouro,
                    decoration: InputDecoration(
                      labelText: "Logradouro",
                      hintText: "Digite o logradouro",
                    ),
                  ),
                  TextField(
                    controller: _controllerNumero,
                    decoration: InputDecoration(
                      labelText: "Número",
                      hintText: "Digite o número",
                    ),
                  ),
                  TextField(
                    controller: _controllerBairro,
                    decoration: InputDecoration(
                      labelText: "Bairro",
                      hintText: "Digite o bairro",
                    ),
                  ),
                  TextField(
                    controller: _controllerCidade,
                    decoration: InputDecoration(
                      labelText: "Cidade",
                      hintText: "Digite o cidade",
                    ),
                  ),
                  TextField(
                    controller: _controllerCep,
                    decoration: InputDecoration(
                      labelText: "Cep",
                      hintText: "Digite o cep",
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  RaisedButton.icon(
                    icon: Icon(Icons.search),
                    label: Text("Pesquisar"),
                    onPressed: () {
                      _chamarEndereco();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _chamarEndereco() async {
    String enderecoDestino = _controllerDestino.text;

    if (enderecoDestino.isNotEmpty) {
      List<Placemark> listaEnderecos =
          await Geolocator().placemarkFromAddress(enderecoDestino);

      if (listaEnderecos != null && listaEnderecos.length > 0) {
        Placemark endereco = listaEnderecos[0];

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
                    _controllerLogradouro.text = destino.logradouro;
                    _controllerNumero.text = destino.numero;
                    _controllerBairro.text = destino.bairro;
                    _controllerCidade.text = destino.cidade;
                    _controllerCep.text = destino.cep;
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


}
