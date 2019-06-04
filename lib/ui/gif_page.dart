import "package:flutter/material.dart";
import 'package:share/share.dart';

class GifPage extends StatelessWidget {
  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(_gifData["title"], style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(icon:Icon(Icons.arrow_back, color: Colors.white,),
          onPressed:() => Navigator.pop(context, false),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            color: Colors.white,
            onPressed: () {
              Share.share("Veja esse gif: ${_gifData["images"]["original"]["url"]}");
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifData["images"]["original"]["url"]),
    ),
    );
  }
}
