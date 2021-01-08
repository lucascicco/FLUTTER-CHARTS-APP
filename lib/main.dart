import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/charts.dart';

import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './screens/charts_overview.dart';
import './screens/list_screeen.dart';
import './screens/add_chart_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Charts>(
            create: (ctx) => Charts(),
            update: (ctx, auth, chart) => chart..receiveToken(auth.token)),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'My charts',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepOrangeAccent,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ChartOverview()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ListCharts.routeName: (ctx) => ListCharts(),
            AddChart.routeName: (ctx) => AddChart()
          },
        ),
      ),
    );
  }
}
