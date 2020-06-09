import 'package:flutter/material.dart';
import 'package:flutter_driver_uber_app/screens/auth_screen.dart';
import 'package:flutter_driver_uber_app/screens/homescreen.dart';
import 'package:provider/provider.dart';
import './provider/auth_provider.dart';

void main() {
  runApp(Settings());
}

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Uber Clone',
          theme: ThemeData(
            fontFamily: 'oswald',
            primaryColor: Colors.black,
            canvasColor: Colors.white,
            appBarTheme: AppBarTheme(
                actionsIconTheme: IconThemeData(
                  color: Colors.black,
                ),
                iconTheme: IconThemeData(color: Colors.black)),
            textTheme: TextTheme(
              headline6: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.getAuthLogin
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return AuthScreen();
                    }
                  },
                ),
          routes: {
            HomeScreen.routeArgs: (ctx) => HomeScreen(),
            AuthScreen.routeArgs: (ctx) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
