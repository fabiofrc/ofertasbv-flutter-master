import 'package:mobx/mobx.dart';
import 'package:ofertasbv/src/pessoajuridica/pessoajuridica_api_provider.dart';
import 'package:ofertasbv/src/pessoajuridica/pessoajuridica_model.dart';

part 'pessoajuridica_controller.g.dart';

class PessoaJuridicaController = PessoaJuridicaControllerBase
    with _$PessoaJuridicaController;

abstract class PessoaJuridicaControllerBase with Store {
  PessoaJuridicaApiProvider _pessoaJuridicaApiProvider;

  PessoaJuridicaController() {
    _pessoaJuridicaApiProvider = PessoaJuridicaApiProvider();
  }

  @observable
  List<PessoaJuridica> pessoaJuridicas;

  @observable
  int categoria;

  @observable
  Exception error;


  @action
  Future<PessoaJuridica> getAll() async {
    try {
      pessoaJuridicas = await _pessoaJuridicaApiProvider.getAll();
    } catch (e) {
      error = e;
    }
  }


  @action
  Future<int> create(PessoaJuridica p) async {
    try {
      categoria = await _pessoaJuridicaApiProvider.create(p.toJson());
      return categoria;
    } catch (e) {
      error = e;
    }
  }
}
