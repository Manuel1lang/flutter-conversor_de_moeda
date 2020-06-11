import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json-cors&key=3dedc22c";

void main() async {
  runApp(MaterialApp(
    home: HOME(),
    theme: ThemeData(
      hintColor: Colors.indigo,
      primaryColor: Colors.indigo,

    ),

  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class HOME extends StatefulWidget {
  @override
  _HOMEState createState() => _HOMEState();
}

class _HOMEState extends State<HOME> {

  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  double dollar;
  double euro;

  void _ClearAll(){
    realController.text ="";
    dollarController.text ="";
    euroController.text ="";
  }

  void _realChanged(String text){
    if(text.isEmpty){
      _ClearAll();
      return;
    }
    double real = double.parse(text);
  dollarController.text = (real/dollar).toStringAsFixed(2);
  euroController.text = (real/euro).toStringAsFixed(2);

  }

  void _dollarChanged(String text){
    if(text.isEmpty){
      _ClearAll();
      return;
    }
    double dollar = double.parse(text);
    realController.text = (dollar * this.dollar).toStringAsFixed(2);
    euroController.text = (dollar * this.dollar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    if(text.isEmpty){
      _ClearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dollarController.text = (euro * this.euro / dollar).toStringAsFixed(2);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("\$Conversor\$",
          style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo,
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Text(
                      "Carregando dados...",
                          style: TextStyle(
                          color: Colors.indigo, fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  );

                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Erro ao carregar dados...",
                        style: TextStyle(color: Colors.indigo,
                          fontSize: 22.0, fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.monetization_on,
                            size: 130.0,
                            color: Colors.indigo
                          ),
                          buildTextField(
                              "Reais", "R\$", realController, _realChanged),
                          Divider(),
                          buildTextField(
                              "Dolar", "US\$", dollarController, _dollarChanged),
                          Divider(),
                          buildTextField(
                              "Euro", "€", euroController, _euroChanged),
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget buildTextField(String label, String prefixText, TextEditingController C, Function f ) {
  return  TextField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.indigo),
        prefixText: prefixText,
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.indigo
            ),
        ),
      ),
      style: TextStyle(color: Colors.indigo, fontSize: 21.0),
      onChanged: f,
      controller: C,
    );
}
