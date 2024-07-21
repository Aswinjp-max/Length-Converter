

import 'package:calculator/history.dart';
import 'package:calculator/model/historyentryy.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class calculator extends StatefulWidget {
  

  @override
  State<calculator> createState() => _calculatorState();
}

class _calculatorState extends State<calculator> {

  double _inputValue = 0.0;
  String _fromUnit = 'Centimeters';
  String _toUnit = 'Meters';
  String _result = '';

   Map _unitMap={
    'Millimeters': 0,
    'Centimeters': 1,
    'Meters': 2,
    'Kilometers': 3,
    'Inches': 4,
    'Feet': 5,
  };

  final Map _siMap={
     '0':['mm',],
     '1':["cm",],
     '2':['m',],
     '3':['km',],
     '4':['in',],
     '5':['ft',],
  };


  final dynamic _formulas = {
    '0': [1, 0.1, 0.001, 0.000001, 0.0393701, 0.00328084],
    '1': [10, 1, 0.01, 0.00001, 0.393701, 0.0328084],
    '2': [1000, 100, 1, 0.001, 39.3701, 3.28084],
    '3': [1000000, 100000, 1000, 1, 39370.1, 3280.84],
    '4': [25.4, 2.54, 0.0254, 0.0000254, 1, 0.0833333],
    '5': [304.8, 30.48, 0.3048, 0.0003048, 12, 1],
  };

  late Box<HistoryEntry>? _historyBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  void _openBox() async {
    _historyBox = await Hive.openBox<HistoryEntry>('historyBox');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      
      appBar: AppBar(
        title: Text('LENGTH CONVERTER',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
        backgroundColor: const Color.fromARGB(255, 183, 77, 112),
        
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
              return HistoryScreen(history: _historyBox!, onDelete: _ondelete);
            }));
          }, icon:Icon(Icons.history,color: Colors.black,size: 25,))
        ],
      ),

      body:  Padding(
        
        padding: EdgeInsets.all(18.0),
        child: Column(
          
          children: [
            
        
            TextField(
              keyboardType: TextInputType.number,
              
              decoration: InputDecoration(
                labelText: 'length',
                border: OutlineInputBorder()
              ),
             onChanged: (value) {
               setState(() {
                 _inputValue=double.tryParse(value)!;
               });
             },
            ),
             SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton(
                
                  dropdownColor: Colors.grey,
                  value: _fromUnit,
                  onChanged: (e) {
                    setState(() {
                      _fromUnit = e.toString();
                    });
                  },
                  items: _unitMap.keys.map((e) {
                    return DropdownMenuItem(
                      
                      value: e,
                      child: Text(e));
                  },).toList(),
                ),
                Icon(Icons.arrow_forward),


                DropdownButton(
                  hint: Text('to'),
                  dropdownColor: Colors.grey,
                  value: _toUnit,
                  onChanged: (e) {
                    setState(() {
                      _toUnit = e.toString();
                    });
                  },
                  items: _unitMap.keys.map((e) {
                    return DropdownMenuItem(
                      
                      value: e,
                      child: Text(e));
                  },).toList(),
                ),
               
              ],
            ),
            SizedBox(height: 15,),
            ElevatedButton(
              
              onPressed: _convert, 
              child: Text('CONVERT')),
              SizedBox(height: 25,), 
               
              Text(_result,style: const TextStyle(color: Colors.black,fontSize: 20),)
          ],
        ),
      ),
    ));
  }

  void _convert(){
   if (_inputValue != 0.0) {
      var from = _unitMap[_fromUnit];
      var to = _unitMap[_toUnit];

      var multiplier = _formulas[from.toString()][to];

      
        String historyentry = '$_inputValue ${_siMap[from.toString()][0]} = ${( _inputValue * multiplier)} ${_siMap[to.toString()][0]}';
setState(() {
        _result=historyentry;
       _addHistoryEntry(historyentry);
      });
    } else {
      setState(() {
        _result = "Please enter a non zero value";
      });
    }
  }

  void _addHistoryEntry(String entry) {
    final historyEntry = HistoryEntry(entry: entry, timestamp: DateTime.now());
     _historyBox!.add(historyEntry);
  }

   void _ondelete(int index) {
    _historyBox!.deleteAt(index); 
  }
}