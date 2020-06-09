import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_driver_uber_app/utils/flutter_secure_storage.dart';
import 'package:flutter_driver_uber_app/utils/http_exception.dart';
import 'package:flutter_driver_uber_app/utils/shared_preferences.dart';

class User {
  String userid;
  String email;
  String username;
  String cityName;
  String phonenumber;

  User({
    this.userid,
    this.phonenumber,
    this.username,
    this.cityName,
    this.email,
  });
}

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class AuthProvider with ChangeNotifier {
  List<User> _usersList;
  final  _auth = FirebaseAuth.instance;
  final  _firestore = Firestore.instance;
  FirebaseUser _user;
  SecureStorage _secureStorage = SecureStorage();
  List _list;
  String _userid;
  String _username;
  String _phonenumber;
  String _email;
  String _cityName;

  //getters
  List<User> get userList => [..._usersList];

  bool get getAuthLogin => _userid != null;
  String get getUserid => _userid;
  String get getemail => _email;
  String get getUserName => _username;
  String get getCityName => _cityName;
  String get getPhoneNumber => _phonenumber;
  //getter length
  int get userListLength => _usersList.length;

  Future<void> signupUser(String name, String email, String password,
      String phoneNumber, String cityName) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      _user = result.user;

      String getPassword = _secureStorage.encrypt(password);
      
      await _firestore.collection('RegisteredDriver').add({
        'uid': _user.uid,
        'username': name,
        'email': email,
        'phoneNo': phoneNumber,
        'cityname': cityName,
        'password': getPassword,
      });

      _usersList.add(User(
          email: email,
          phonenumber: phoneNumber,
          userid: _user.uid,
          username: name,
          cityName: cityName));

      _userid = _user.uid;
      _username = name;
      _phonenumber = phoneNumber;
      _email = email;
      _cityName = cityName;
      notifyListeners();
      final userData = json.encode({
        'userId': _user.uid,
        'name': name,
        'email': email,
        'phoneNo': phoneNumber,
        'password': getPassword,
        'cityName': cityName
      });
      notifyListeners();
      await SharedPref.init();
      await SharedPref.setAuthdata(userData);
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  var _userData;
  Future<void> signInUser(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _user = result.user;

      await _firestore
          .collection('RegisteredDriver')
          .where('uid', isEqualTo: _user.uid)
          .getDocuments()
          .then((snapshot) => snapshot.documents.forEach((element) {
                _userid = _user.uid;
                _username = element.data['username'];
                _phonenumber = element.data['phoneNo'];
                _email = email;
                _cityName = element.data['cityname'];

                print("${element.data['uid']} USER LOGIN");
                _userData = json.encode({
                  'userId': _user.uid,
                  'name': element.data['username'],
                  'email': email,
                  'phoneNo': element.data['phoneNo'],
                  'password': element.data['password'],
                  'cityName': element.data['cityname'],
                });
              }));
      notifyListeners();

      await SharedPref.init();
      await SharedPref.setAuthdata(_userData);
    } catch (e) {
      throw HttpException(e.message);
    }
  }

  Future<bool> checkEmailExist(String email) async {
    await Firestore.instance
        .collection("RegisteredDriver")
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((element) {
        _list.add(element.data);
      });
    });

    notifyListeners();
    if (_list.contains(email)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> autoLogin() async {
    await SharedPref.init();
    String abc = SharedPref.getAuthData();
    // if (abc == null || abc.isEmpty) {
    //   return false;
    // }
    final extractedData = json.decode(abc) as Map<String, Object>;
    if (extractedData == null || extractedData.isEmpty) {
      return false;
    }

    _username = extractedData['name'];
    _userid = extractedData['userId'];
    _phonenumber = extractedData['phoneNo'];
    _email = extractedData['email'];
    _cityName = extractedData['cityName'];

    notifyListeners();
    return true;
  }

  void logoutUser() async {
    _userid = null;
    _email = null;
    _phonenumber = null;
    _username = null;
    _auth.signOut();
    notifyListeners();
    await SharedPref.init();
//    pref.remove('userData');
    SharedPref.clearSharedPrefData();
  }
}
