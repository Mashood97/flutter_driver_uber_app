import 'package:flutter/material.dart';
import 'package:flutter_driver_uber_app/provider/auth_provider.dart';
import 'package:flutter_driver_uber_app/screens/homescreen.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provData = Provider.of<AuthProvider>(context,listen: false);
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 40),
            height: MediaQuery.of(context).size.height * 0.30,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                Text(
                  provData.getUserName ?? '',
                   style: Theme.of(context).textTheme.headline6.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  provData.getemail ?? '',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(HomeScreen.routeArgs),
            title: Text(
              'Home',
              style: Theme.of(context).textTheme.title.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            trailing: Icon(
              Icons.home,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<AuthProvider>(context, listen: false).logoutUser();
            },
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            trailing: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
