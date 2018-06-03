import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  var dados = await leituraDados();

  if (dados != null) {
    String mensagem = await leituraDados();
    print(mensagem);
  }
  runApp(new MaterialApp(
    title: 'IO',
    home: new Inicio(),
  ));
}

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => new _InicioState();
}

class _InicioState extends State<Inicio> {
  var _campoDadosEntrada = new TextEditingController();
  String _dadosSalvos = "";

  @override
  void initState() {
    super.initState();

    _carregaDadosSalvos();
  }

  void _carregaDadosSalvos() async {
    SharedPreferences preferencias = await SharedPreferences.getInstance();
    setState(() {
      if (preferencias.getString('dados') != null &&
          preferencias.getString('dados').isNotEmpty) {
        _dadosSalvos = preferencias.getString("dados");
      } else {
        _dadosSalvos = "Shared Preferences vazio...";
      }
    });
  }

  _salvaMensagens(String mensagem) async {
    SharedPreferences preferencias = await SharedPreferences.getInstance();
    preferencias.setString(
        "dados", mensagem); // Usando dados como chave e mensagem como valor
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Usando Shared Preferences'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: new Container(
        padding: const EdgeInsets.all(13.4),
        alignment: Alignment.topCenter,
        child: new ListTile(
          title: new TextField(
            controller: _campoDadosEntrada,
            decoration: new InputDecoration(labelText: 'Escreva algo...'),
          ),
          subtitle: new FlatButton(
            color: Colors.blue,
            onPressed: () {
              // Salva o arquivo
              _salvaMensagens(_campoDadosEntrada.text);
            },
            child: new Column(
              children: <Widget>[
                new Text('Salva os Dados'),
                new Padding(padding: new EdgeInsets.all(14.5)),
                new Text(_dadosSalvos),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<String> get _caminhoLocal async {
  final diretorio = await getApplicationDocumentsDirectory();

  return diretorio.path; // /home/directory:text
}

Future<File> get _arquivoLocal async {
  final caminho = await _caminhoLocal;
  return new File('$caminho/dados.txt'); // /home/directory/dados.txt
}

// Escreve e faz a leitura do nosso arquivo
Future<File> escreveDados(String mensagem) async {
  final arquivo = await _arquivoLocal;

  // escreve no arquivo
  return arquivo.writeAsString('$mensagem');
}

Future<String> leituraDados() async {
  String dados;

  try {
    final arquivo = await _arquivoLocal;

    // Leitura
    dados = await arquivo.readAsString();
  } catch (e) {
    dados = "Nada foi escrito por enquanto...";
  }

  return dados;
}
