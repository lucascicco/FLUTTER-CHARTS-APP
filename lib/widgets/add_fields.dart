import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../screens/show_chart.dart';
import '../providers/charts.dart';

import '../models/chart_one.dart';
import '../models/chart_item_one.dart';

class AddChartDetails extends StatefulWidget {
  AddChartDetails({Key key}) : super(key: key);

  @override
  _AddChartDetailsState createState() => _AddChartDetailsState();
}

class _AddChartDetailsState extends State<AddChartDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _formKeyTwo = GlobalKey();

  bool openForm = false;
  bool startAnimation = false;
  bool startSecondAnimation = false;
  bool loading = false;

  List<String> dropdownValues = ['Barras', 'Pizza', 'Linhas'];
  String dropdownValue = 'Barras';
  String chartTitle = '';
  bool keyboardOpen = false;
  Map<String, dynamic> _chartDetails = {'name': '', 'value': ''};
  List<ItemChart> values = [];
  double restSpace = 0;

  var porcentageMask = new MaskTextInputFormatter(
      mask: '##.##', filter: {"#": RegExp(r'[0-9]')});

  var integerMask = new MaskTextInputFormatter(
      mask: '#####', filter: {"#": RegExp(r'[0-9]')});

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

  Color generateColor() {
    Color filteredColor =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];

    bool verifyColor(Color color) {
      return values
          .where((element) => element.color == color)
          .toList()
          .isNotEmpty;
    }

    while (verifyColor(filteredColor)) {
      filteredColor =
          Colors.primaries[Random().nextInt(Colors.primaries.length)];
      bool stopLooping = verifyColor(filteredColor);

      if (!stopLooping) {
        break;
      }
    }

    return filteredColor;
  }

  void addValue() {
    if (!_formKeyTwo.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKeyTwo.currentState.save();

    if (dropdownValue == 'Linhas') {
      values.add(new ItemChart(
          name: _chartDetails['name'],
          color: generateColor(),
          value: _chartDetails['value']));
      return;
    }

    bool existingItem = values
        .where((item) => item.name == _chartDetails['name'])
        .toList()
        .isNotEmpty;

    if (existingItem) {
      return _showErrorDialog('Esse valor já existe para este gráfico');
    }

    double total = values.length == 0
        ? 0.00
        : values
            .map((e) => e.value)
            .toList()
            .reduce((value, element) => value + element);

    double availableSpace = 100.00 - total;

    if (_chartDetails['value'] > availableSpace) {
      return _showErrorDialog(
          'A porcentagem dada em decimal está maior que o valor disponível para inserção. Restante: $availableSpace');
    }

    values.add(new ItemChart(
        name: _chartDetails['name'],
        color: generateColor(),
        value: _chartDetails['value']));

    setState(() {
      restSpace = total + _chartDetails['value'];
    });

    _formKeyTwo.currentState.reset();
  }

  Future<void> _submit(BuildContext context) async {
    if (values.length == 0) {
      return;
    }

    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }

    _formKey.currentState.save();

    setState(() {
      loading = true;
    });

    ChartOne chartToBeCreated = new ChartOne(
        title: chartTitle,
        values: values,
        type: dropdownValues.indexOf(dropdownValue));

    try {
      await Provider.of<Charts>(context, listen: false)
          .addChart(
        chartToBeCreated,
      )
          .then((item) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return ShowChart(chartOne: item); //a screen
        }));
      });
    } on HttpException catch (e) {
      _showErrorDialog(e.toString());
    } catch (e) {
      _showErrorDialog(e.toString());
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> sleepFunction({int seconds = 1, int animationType}) {
    return Future.delayed(Duration(seconds: seconds), () {
      if (animationType == 1) {
        setState(() {
          openForm = true;
        });
      } else {
        setState(() {
          startSecondAnimation = true;
        });
      }
    });
  }

  void nextWidget() async {
    setState(() {
      startAnimation = true;
    });

    await sleepFunction(animationType: 1);

    await sleepFunction(animationType: 2);
  }

  @override
  Widget build(BuildContext context) {
    bool lineChart = dropdownValue == 'Linhas';

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: BoxDecoration(
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
              top: startAnimation ? 1200 : constraints.maxWidth * 45 / 100,
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
                      Icon(Icons.arrow_downward_outlined, color: Colors.white),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.white)),
                )
              ]),
            ),
            if (openForm)
              AnimatedPositioned(
                top: startSecondAnimation ? 0 : -1000,
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
                          child: Column(children: <Widget>[
                            Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Título',
                                ),
                                keyboardType: TextInputType.text,
                                maxLength: 25,
                                maxLengthEnforced: true,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Título inválido';
                                  }
                                },
                                onSaved: (value) {
                                  chartTitle = value.trim().toUpperCase();
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Card(
                                  elevation: 5.0,
                                  child: Container(
                                    padding: EdgeInsets.all(15.0),
                                    width: constraints.maxWidth * 0.90,
                                    color: Colors.grey[100],
                                    child: Form(
                                      key: _formKeyTwo,
                                      child: Column(
                                        children: <Widget>[
                                          TextFormField(
                                            inputFormatters:
                                                lineChart ? [integerMask] : [],
                                            decoration: InputDecoration(
                                                labelText: lineChart
                                                    ? 'Valor em Y'
                                                    : 'Nome do item'),
                                            keyboardType: TextInputType.text,
                                            maxLength: lineChart ? 5 : 15,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Dado inválido';
                                              }
                                            },
                                            onSaved: (value) {
                                              _chartDetails['name'] = lineChart
                                                  ? int.parse(value)
                                                  : value;
                                            },
                                          ),
                                          TextFormField(
                                            inputFormatters: lineChart
                                                ? [integerMask]
                                                : [porcentageMask],
                                            decoration: InputDecoration(
                                                labelText: lineChart
                                                    ? 'Valor em X'
                                                    : 'Valor em porcentagem',
                                                hintText: lineChart
                                                    ? 'Valor em decimal'
                                                    : 'Exemplo: 25.70, será igual a 25.7%',
                                                helperText: lineChart
                                                    ? ''
                                                    : 'Já usado $restSpace'),
                                            keyboardType: TextInputType.number,
                                            maxLength: 5,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Valor inválido';
                                              }
                                            },
                                            onSaved: (value) {
                                              _chartDetails['value'] = lineChart
                                                  ? int.parse(value)
                                                  : value;
                                            },
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.blueGrey,
                                              ),
                                              onPressed: addValue,
                                              child: Text('Adicionar item'))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      if (constraints.maxHeight > 400)
                        Container(
                          width: constraints.maxWidth * 0.4,
                          margin: EdgeInsets.only(bottom: 15.0),
                          child: RaisedButton(
                              onPressed: () => {_submit(context)},
                              color: Colors.grey,
                              textColor: Colors.white,
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  if (loading)
                                    LinearProgressIndicator(
                                        backgroundColor: Colors.grey),
                                  if (!loading)
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
