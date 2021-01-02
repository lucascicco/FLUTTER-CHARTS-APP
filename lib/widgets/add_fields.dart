import 'package:flutter/material.dart';
import '../models/chart_one.dart';

class AddChartDetails extends StatefulWidget {
  double height;

  AddChartDetails({Key key, this.height}) : super(key: key);

  @override
  _AddChartDetailsState createState() => _AddChartDetailsState();
}

class _AddChartDetailsState extends State<AddChartDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String chartTitle = '';
  bool openForm = false;
  String dropdownValue = 'Barras';
  Map<String, dynamic> _chartDetails = {'name': '', 'value': '', 'color': ''};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        width: double.maxFinite,
        height: widget.height * 0.95,
        child: Column(
            mainAxisAlignment: openForm
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (!openForm)
                Column(children: <Widget>[
                  Text(
                    'Selecione o tipo de gráfico',
                    style: TextStyle(fontSize: 25),
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
                        color: Colors.orange,
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
                    onPressed: () {
                      setState(() {
                        openForm = true;
                      });
                    },
                    color: Colors.grey,
                    child: Icon(Icons.arrow_right_alt_rounded,
                        color: Colors.white),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)),
                  )
                ]),
              Card(
                margin: EdgeInsets.all(10.0),
                elevation: 8.0,
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  height: openForm ? 300 : 0,
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
                                decoration:
                                    InputDecoration(labelText: 'Nome do item'),
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
              if (openForm)
                ElevatedButton(
                    onPressed: () {
                      print('THATS WORKING');
                    },
                    child: Text('Adicionar item'))
            ]),
      ),
    );
  }
}
