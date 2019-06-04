import 'package:flutter/material.dart';
import 'package:flutter_buscador_de_gifs/ui/gif_page.dart';
import 'package:flutter_buscador_de_gifs/ui/home_page.dart';

void main() => runApp(
    MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        hintColor: Colors.white,
        primaryColor: Colors.white,
      ),
    ));

