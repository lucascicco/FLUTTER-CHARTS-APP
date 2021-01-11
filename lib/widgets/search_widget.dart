import 'package:flutter/material.dart';

class SearchChartWidget extends StatefulWidget {
  final Function filterSet;
  final List<String> chartsList;
  final String selectedItem;
  final Function setText;

  SearchChartWidget(
      {Key key,
      this.filterSet,
      this.chartsList,
      this.selectedItem,
      this.setText})
      : super(key: key);

  @override
  _SearchChartWidgetState createState() => _SearchChartWidgetState();
}

class _SearchChartWidgetState extends State<SearchChartWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 15),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                cursorColor: Colors.black,
                onChanged: (value) {
                  print(value);
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
                child: Icon(Icons.list_alt_rounded), onPressed: () {})
          ],
        ));
  }
}
