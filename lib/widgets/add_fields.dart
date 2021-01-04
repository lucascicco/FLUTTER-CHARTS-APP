import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/chart_one.dart';

class AddChartDetails extends StatefulWidget {
  AddChartDetails({Key key}) : super(key: key);

  @override
  _AddChartDetailsState createState() => _AddChartDetailsState();
}

class _AddChartDetailsState extends State<AddChartDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String chartTitle = '';
  bool openForm = false;
  bool startAnimation = false;
  String dropdownValue = 'Barras';
  Map<String, dynamic> _chartDetails = {'name': '', 'value': '', 'color': ''};

  void nextWidget() {
    setState(() {
      startAnimation = true;
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        openForm = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
            gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment(-0.4, -0.8),
                stops: [0.0, 0.5, 0.5, 1],
                colors: [
                  Colors.blueGrey,
                  Colors.blueGrey,
                  Colors.white,
                  Colors.white,
                ],
                tileMode: TileMode.repeated)),
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Stack(
          children: <Widget>[
            AnimatedPositioned(
              top: startAnimation
                  ? -constraints.maxHeight
                  : constraints.maxWidth * 45 / 100,
              right: constraints.maxWidth * 7 / 100,
              width: constraints.maxWidth * 0.90,
              curve: Curves.slowMiddle,
              duration: Duration(seconds: 1),
              child: Column(children: <Widget>[
                Text(
                  'Selecione o tipo de gráfico',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                DropdownButton(
                    value: dropdownValue,
                    elevation: 16,
                    style: TextStyle(color: Colors.black, fontSize: 25),
                    underline: Container(
                      height: 2,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>['Barras', 'Linhas', 'Pizza']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()),
                SizedBox(
                  height: 30,
                ),
                RaisedButton(
                  onPressed: nextWidget,
                  color: Colors.grey,
                  child:
                      Icon(Icons.arrow_right_alt_rounded, color: Colors.white),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.white)),
                )
              ]),
            ),
            AnimatedPositioned(
              top: openForm ? 0 : constraints.maxHeight,
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              curve: Curves.elasticInOut,
              duration: Duration(seconds: 1),
              child: Column(children: <Widget>[
                Card(
                  margin: EdgeInsets.all(10.0),
                  elevation: 8.0,
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    padding: EdgeInsets.all(10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Título'),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Título inválido';
                            }
                          },
                          onSaved: (value) {
                            chartTitle = value.trim().toUpperCase();
                          },
                        ),
                        Card(
                          margin: EdgeInsets.only(top: 15),
                          elevation: 6.0,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            width: double.infinity,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Nome do item'),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Nome inválido';
                                    }
                                  },
                                  onSaved: (value) {
                                    _chartDetails['name'] = value;
                                  },
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Valor em decimal'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Valor inválido';
                                    }
                                  },
                                  onSaved: (value) {
                                    _chartDetails['value'] = value;
                                  },
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blueGrey,
                                    ),
                                    onPressed: () {
                                      print('THATS WORKING');
                                    },
                                    child: Text('Adicionar item'))
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                  child: RaisedButton(
                      onPressed: () {
                        print('Testing');
                      },
                      color: Colors.grey,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.add_circle_rounded, size: 45),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Gerar gráfico',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      )),
                ),
              ]),
            ),
          ],
        ),
      );
    });
  }
}
