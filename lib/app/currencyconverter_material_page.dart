import 'package:flutter/material.dart';

class CurrencyconverterMaterialPage extends StatefulWidget {
  const CurrencyconverterMaterialPage({super.key});

  @override 
  CurrencyconverterMaterialPageState createState() => CurrencyconverterMaterialPageState();
}

class CurrencyconverterMaterialPageState extends State<CurrencyconverterMaterialPage> {
  int _counter = 0;
    void _incrementCounter() {
      setState(() {
        _counter++;
      });
    }
    @override
    Widget build(BuildContext context){
      return Scaffold(appBar: AppBar(
        title: const Text('Counter App'),
      ),
      body:Center(child: Text(
      'Counter: $_counter',
        style: TextStyle(fontSize:15),
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      );
    }
  }
