import 'package:flutter/material.dart';
import '../widgets/add_fields.dart';

class AddChart extends StatelessWidget {
  static const routeName = '/add-chart';

  const AddChart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.blueGrey,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/');
        },
      ),
    );

    return Scaffold(appBar: appBar, body: AddChartDetails());
  }
}
