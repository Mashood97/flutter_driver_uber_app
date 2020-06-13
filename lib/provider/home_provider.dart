import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_driver_uber_app/utils/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeProvider with ChangeNotifier {
  GoogleMapController mapController;
  final _firestore = Firestore.instance;
  LatLng _initialPosition;

  LatLng get getInitialPosition => _initialPosition;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  String _userAddress;
  String _endAddress;

  Set<Marker> get getAllMarkers => _markers;

  String get getUserAddress => _userAddress;

  String get getEndAddress => _endAddress;

  HomeProvider() {
    getUserLocation();
  }

  void getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      _initialPosition = LatLng(position.latitude, position.longitude);
    }
    notifyListeners();
  }

  void onMapCreated(controller) {
    mapController = controller;
    notifyListeners();
  }

  Future<void> addMarker() async {
    try {
      await _firestore
          .collection('Location')
          .getDocuments()
          .then((value) async {
        if (value.documents.isNotEmpty) {
          var documentData = value.documents;
          for (int i = 0; i < documentData.length; i++) {
            print('${documentData[i]['userDestination']} username of user');
            print(
                '${documentData[i]['userDestination']['latitude']} username of latitude');
            print(
                '${documentData[i]['userDestination']['longitude']} username of latitude');
            _markers.add(Marker(
              markerId: MarkerId(LatLng(
                      documentData[i]['userDestination']['latitude'],
                      documentData[i]['userDestination']['longitude'])
                  .toString()),
              position: LatLng(
                  documentData[i]['userLocation']['latitude'],
                  //we will add userlocation here
                  documentData[i]['userLocation']['longitude']),
              //user location here too.
              infoWindow: InfoWindow(
                title: 'user address',
                snippet: "destination",
              ),
              icon: BitmapDescriptor.defaultMarker,
            ));
            _endAddress = documentData[i]['destinationAddress'];
            _userAddress = documentData[i]['userAddress'];
          }
        }
      });
//      await _firestore.collection('Location').getDocuments().then((value) async {
//        if (value.documents.isNotEmpty) {
//          Map<String, dynamic> documentData = value.documents.single.data;
//
//
//          _markers.add(Marker(
//            markerId: MarkerId(LatLng(
//                    documentData['userDestination']['latitude'],
//                    documentData['userDestination']['longitude'])
//                .toString()),
//            position: _initialPosition,
//            infoWindow: InfoWindow(
//              title: 'user address',
//              snippet: "destination",
//            ),
//            icon: BitmapDescriptor.defaultMarker,
//          ));
//        }
//      });

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  //here we convert the encoded polyline into decode polylines to get lat lng route

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }
}
