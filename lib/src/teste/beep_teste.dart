import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BeepTeste extends StatefulWidget {
  @override
  _BeepTesteState createState() => _BeepTesteState();
}

class _BeepTesteState extends State<BeepTeste> {
  AudioCache _audioCache = AudioCache(prefix: "audios/");

  _executar(String nomeAudio) {
    _audioCache.play(nomeAudio + ".mp3");
  }

  @override
  void initState() {
    super.initState();
    _audioCache.loadAll(["beep-07.mp3"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beep"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Teste beep"),
          onPressed: () {
            _executar("beep-07");
          },
        ),
      ),
    );
  }
}
