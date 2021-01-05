import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../providers/charts.dart';

import '../models/chart_one.dart';

class AddChartDetails extends StatefulWidget {
  AddChartDetails({Key key}) : super(key: key);

  @override
  _AddChartDetailsState createState() => _AddChartDetailsState();
}

class _AddChartDetailsState extends State<AddChartDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool openForm = false;
  bool startAnimation = false;
  bool loading = false;

  List<String> dropdownValues = ['Barras', 'Linhas', 'Pizza'];
  String dropdownValue = 'Barras';
  String chartTitle = '';
  bool keyboardOpen = false;
  Map<String, dynamic> _chartDetails = {'name': '', 'value': '', 'color': ''};
  List values = [];

  var porcentageMask = new MaskTextInputFormatter(
      mask: '##.##', filter: {"#": RegExp(r'[0-9]')});

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Um erro aconteceu'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Entendi'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void addValue() {
    bool existingItem =
        values.contains((item) => item.name == _chartDetails['name']);

    if (existingItem) {
      return;
    }

    Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)];

    bool verifyColor(Color colorCompare) {
      return values.contains((item) => item.color == colorCompare);
    }

    while (verifyColor(color)) {
      color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
      bool stopLooping = verifyColor(color);

      if (!stopLooping) {
        break;
      }
    }

    double sumAvalaible =
        values.reduce((current, next) => current.value + next.value);

    if (_chartDetails['value'] > sumAvalaible) {
      return;
    }

    values.add(_chartDetails);

    setState(() {
      _chartDetails['value'] = '';
      _chartDetails['color'] = '';
      _chartDetails['name'] = '';
    });
  }

  Future<void> _submit() async {
    setState(() {
      loading = true;
    });

    try {
      await Provider.of<Charts>(context, listen: false).addChart(new ChartOne(
          title: chartTitle,
          values: values,
          type: dropdownValues.indexOf(dropdownValue)));

      //abrir página com gráfico aberto.
    } catch (e) {
      _showErrorDialog(e);
    }

    setState(() {
      loading = false;
    });
  }

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
                    items: dropdownValues
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
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.all(10.0),
                      elevation: 8.0,
                      child: Container(
                        width: double.infinity,
                        height: constraints.maxHeight < 400
                            ? constraints.maxHeight * 0.9
                            : constraints.maxHeight * 0.6,
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
                            Expanded(
                              child: SingleChildScrollView(
                                child: Card(
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
                                          inputFormatters: [porcentageMask],
                                          decoration: InputDecoration(
                                              labelText: 'Valor em porcentagem',
                                              hintText:
                                                  'Exemplo: 25.70, será igual a 25.7%'),
                                          keyboardType: TextInputType.number,
                                          maxLength: 5,
                                          validator: (value) {
                                            if (value.isEmpty ||
                                                value.length < 3) {
                                              return 'Valor inválido';
                                            }
                                          },
                                          onSaved: (value) {
                                            _chartDetails['value'] =
                                                double.parse(value);
                                          },
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.blueGrey,
                                            ),
                                            onPressed: () {
                                              print(constraints.maxHeight);
                                            },
                                            child: Text('Adicionar item'))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    if (constraints.maxHeight > 400)
                      Container(
                        margin: EdgeInsets.only(bottom: 15.0),
                        child: RaisedButton(
                            onPressed: _submit,
                            color: Colors.grey,
                            textColor: Colors.white,
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                if (loading)
                                  LinearProgressIndicator(
                                      backgroundColor: Colors.grey),
                                Icon(Icons.add_circle_rounded, size: 45),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  loading ? 'Processando' : 'Gerar gráfico',
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
