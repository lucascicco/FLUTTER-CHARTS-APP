import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'dart:convert';
import '../helpers/DataPicker.dart';

class SearchChartWidget extends StatefulWidget {
  final Function filterSet;
  final List<String> chartsList;
  final String selectedItem;
  final Function setText;
  final String filterCategory;

  SearchChartWidget(
      {Key key,
      this.filterSet,
      this.chartsList,
      this.selectedItem,
      this.setText,
      this.filterCategory})
      : super(key: key);

  @override
  _SearchChartWidgetState createState() => _SearchChartWidgetState();
}

class _SearchChartWidgetState extends State<SearchChartWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> getListOption() {
      List<Widget> results = [];

      for (var i = 0; i < widget.chartsList.length; i++) {
        results.add(SimpleDialogOption(
            child: Text(
              widget.chartsList[i],
              style: TextStyle(
                  fontWeight: widget.filterCategory == widget.chartsList[i]
                      ? FontWeight.bold
                      : null),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              widget.filterSet(widget.chartsList[i]);
            }));
      }

      return results;
    }

    SimpleDialog dialog = SimpleDialog(
      title: Row(
        children: <Widget>[
          Expanded(child: Text('Selecione um filtro:')),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.filterSet('');
              },
              icon: Icon(
                Icons.remove_circle,
                color: Colors.redAccent,
              ))
        ],
      ),
      children: getListOption(),
    );

    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 15),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                cursorColor: Colors.black,
                onChanged: (value) {
                  widget.setText(value);
                },
                decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 15, top: 15, right: 15),
                    hintText: "Procure gráfico por título"),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
                child: Icon(Icons.list_alt_rounded),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return dialog;
                    },
                  );
                })
          ],
        ));
  }
}
