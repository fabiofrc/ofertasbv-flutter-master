import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ofertasbv/const.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewSite extends StatefulWidget {
  String urlSite;
  WebViewSite(this.urlSite);

  @override
  _WebViewSiteState createState() => _WebViewSiteState();
}

class _WebViewSiteState extends State<WebViewSite> {
  WebViewController conroller;
  var _stackIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pesquisa externa",
          style: Constants.textoAppTitulo,
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, color: Constants.colorIconsAppMenu,),
            onPressed: _clickRefresh,
          )
        ],
      ),
      body: _webView(),
    );
  }

  _webView() {
    return IndexedStack(
      index: _stackIndex,
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl: widget.urlSite,
                onWebViewCreated: (controller) {
                  this.conroller = controller;
                },
                javascriptMode: JavascriptMode.unrestricted,
                navigationDelegate: (request) {
                  return NavigationDecision.navigate;
                },
                onPageFinished: _onPageFinished,
              ),
            ),

          ],
        ),
        Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }

  void _clickRefresh() {
    this.conroller.reload();
  }

  void _onPageFinished(String url) {
    setState(() {
      _stackIndex = 0;
    });
  }
}
