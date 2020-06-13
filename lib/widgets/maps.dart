import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver_uber_app/provider/home_provider.dart';
import 'package:flutter_driver_uber_app/screens/homescreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Maps extends StatefulWidget {
  final scaffoldKey;

  Maps(this.scaffoldKey);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Maps> {
  final _firebaseMessaging = FirebaseMessaging();
  bool _isConfigured = false;

  void _showDialog(BuildContext context, String message, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK!'),
          )
        ],
      ),
    );
  }

  Widget getTitle(String title, var textStyle) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: textStyle,
      ),
    );
  }

  void getBottomSheet(var homeProv, Function onpress) {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (ctx) => SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getTitle('User Pick-Up Point:',
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                  getTitle(homeProv.getUserAddress,
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                  getTitle('User Destination Point:',
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                  getTitle(homeProv.getEndAddress,
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: onpress,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      splashColor: Colors.purple,
                      child: Text(
                        'Confirm Ride',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  @override
  void initState() {
    super.initState();
    print('init called again');
//    Future.delayed(Duration.zero, () {
////      Navigator.of(context).pushReplacementNamed(HomeScreen.routeArgs);
//      Provider.of<HomeProvider>(context).addMarker();
//
//    });

    if (!_isConfigured) {
      _firebaseMessaging.configure(
        //called when app is in foreground
        onMessage: (Map<String, dynamic> message) async {
          print('init called onMessage');

          final snackBar = SnackBar(
            content: Text(message['notification']['body']),
            action: SnackBarAction(
              label: 'GO',
              onPressed: () => Future.delayed(Duration.zero, () {
                Provider.of<HomeProvider>(context).addMarker().then((value) {
                  getBottomSheet(Provider.of<HomeProvider>(context), () {});

                });
              }),
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        },
        //called when app is completely closed and open from push notification
        onLaunch: (Map<String, dynamic> message) async {
          print('init called onLaunch');

          Future.delayed(Duration.zero, () {
//          Navigator.of(context).pushReplacementNamed(HomeScreen.routeArgs);
            Provider.of<HomeProvider>(context).addMarker().then((value) {
              getBottomSheet(Provider.of<HomeProvider>(context), () {});

            });
          });
        },
        //called when app is in background  and open from push notification

        onResume: (Map<String, dynamic> message) async {
          print('init called onResume');
          Future.delayed(Duration.zero, () {
//          Navigator.of(context).pushReplacementNamed(HomeScreen.routeArgs);
            Provider.of<HomeProvider>(context).addMarker().then((value) {
              getBottomSheet(Provider.of<HomeProvider>(context), () {});

            });
          });
        },
      );
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
      _isConfigured = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provData = Provider.of<HomeProvider>(context);

    return provData.getInitialPosition == null
        ? SpinKitSquareCircle(
            color: Theme.of(context).primaryColor,
          )
        : Stack(
            children: [
              GoogleMap(
                onMapCreated: provData.onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: provData.getInitialPosition,
                  zoom: 12.0,
                ),
                markers: provData.getAllMarkers,
                myLocationEnabled: true,
              ),
              Positioned(
                left: 10,
                top: 20,
                child: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => widget.scaffoldKey.currentState.openDrawer(),
                ),
              ),
            ],
          );
  }
}
