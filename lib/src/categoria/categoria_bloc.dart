import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:ofertasbv/src/categoria/categoria_model.dart';
import 'categoria_api_provider.dart';

class CategoriaBloc extends ChangeNotifier {
  CategoriaApiProvider _categoriaApiProvider = CategoriaApiProvider();

  /* ================= post categoria ================= */

  var _streamController = StreamController<List<Categoria>>();

  Stream<List<Categoria>> get outController => _streamController.stream;

  carregaCategorias() async {
    List<Categoria> categorias = await _categoriaApiProvider.getAll();
    _streamController.add(categorias);
  }

}
