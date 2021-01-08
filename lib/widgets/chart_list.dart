import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/charts.dart';
import '../screens/show_chart.dart';

class ChartList extends StatelessWidget {
  const ChartList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chart = Provider.of<Charts>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          padding: EdgeInsets.all(15.0),
          child: ListView.builder(
            itemCount: chart.items.length,
            itemBuilder: (context, i) {
              return Container(
                margin: EdgeInsets.only(bottom: 10.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return ShowChart(chartOne: chart.items[i]); //a screen
                    }));
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(chart.items[i].title)),
                      IconButton(
                          icon: Icon(Icons.delete_sharp, color: Colors.red),
                          onPressed: () {
                            chart.deleteChart(chart.items[i].id);
                          })
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
