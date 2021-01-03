import 'package:flutter/material.dart';
import '../widgets/add_fields.dart';

class AddChart extends StatelessWidget {
  static const routeName = '/add-chart';

  const AddChart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

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

    final heightAv = deviceSize.height - appBar.preferredSize.height;

    return Scaffold(
      appBar: appBar,
      body: Container(
          height: heightAv,
          width: deviceSize.width,
          child: AddChartDetails(height: heightAv)),
    );
  }
}
