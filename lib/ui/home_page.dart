import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_buscador_de_gifs/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;
  final _urlTrending =
      "https://api.giphy.com/v1/gifs/trending?api_key=G1b70QyWGiU7AkBrXWoKjpmO7tDNp0Bf&limit=20&rating=G";
  final _urlSearch =
      "https://api.giphy.com/v1/gifs/search?api_key=G1b70QyWGiU7AkBrXWoKjpmO7tDNp0Bf&limit=19&rating=G&lang=pt";

  Future<Map> _getGif() async {
    http.Response response;
    if (_search == null || _search.isEmpty) {
      response = await http.get(_urlTrending);
    } else {
      response = await http.get("$_urlSearch&q=$_search&offset=$_offset");
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGif().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquisar",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getGif(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError)
                        return Container();
                      else
                        return _createGifTable(context, snapshot);
                  }
                }),
          )
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null) return data.length;
    return data.length + 1;
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if (_search == null || index < snapshot.data["data"].length)
            return GestureDetector(
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: snapshot
                      .data["data"][index]["images"]["fixed_height"]["url"],
                  height: 300.0,
                  fit: BoxFit.cover,),
                onTap: ()
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GifPage(snapshot.data["data"][index])));
          },onLongPress
              :
          (
          )
          {
          Share.share("Veja esse gif: ${snapshot.data
          ["data"][index]["
          images"]["original"]["
          url"]}");
          }
          ,
          );
          else
          {
          return Container(
          child: GestureDetector(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Icon(Icons.add, color: Colors.white, size: 70.0),
          Text(
          "Carregar mais...",
          style: TextStyle(color: Colors.white, fontSize: 22.0),
          )
          ],
          ),
          onTap: () {
          setState(() {
          _offset += 19;
          });
          }),
          );
          }
        });
  }
}