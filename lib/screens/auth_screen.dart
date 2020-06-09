import 'package:flutter/material.dart';
import 'package:flutter_driver_uber_app/provider/auth_provider.dart';
import 'package:flutter_driver_uber_app/screens/homescreen.dart';
import 'package:provider/provider.dart';
import '../widgets/rounded_button.dart';
import '../widgets/user_text_field.dart';

class AuthScreen extends StatefulWidget {
  static const routeArgs = '/auth-screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final cityController = TextEditingController();

  final passwordController = TextEditingController();

  final phoneNoController = TextEditingController();

  final emailFocusNode = FocusNode();
  final cityNameFocusNode = FocusNode();
  final PhoneFocusNode = FocusNode();
  final PasswordFocusNode = FocusNode();

  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailFocusNode.dispose();
    emailController.dispose();
    cityNameFocusNode.dispose();
    cityController.dispose();
    passwordController.dispose();
    PasswordFocusNode.dispose();
    phoneNoController.dispose();
    PhoneFocusNode.dispose();
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error Occured'),
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'PickUp',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    )),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Please Fill the below form',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                Form(
                  key: _key,
                  autovalidate: true,
                  child: Column(
                    children: [
                      UserTextField(
                        titleLabel: 'Enter your full name',
                        maxLength: 50,
                        icon: Icons.person_pin,
                        inputAction: TextInputAction.next,
                        controller: nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                        inputType: TextInputType.text,
                        fieldSubmit: (_) =>
                            FocusScope.of(context).requestFocus(emailFocusNode),
                      ),
                      UserTextField(
                        titleLabel: 'Enter your Email',
                        maxLength: 30,
                        focusnode: emailFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                        icon: Icons.email,
                        inputAction: TextInputAction.next,
                        controller: emailController,
                        inputType: TextInputType.emailAddress,
                        fieldSubmit: (_) => FocusScope.of(context)
                            .requestFocus(cityNameFocusNode),
                      ),
                      UserTextField(
                        titleLabel: 'Enter your city Name',
                        focusnode: cityNameFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                        maxLength: 40,
                        icon: Icons.location_city,
                        inputAction: TextInputAction.next,
                        controller: cityController,
                        inputType: TextInputType.text,
                        fieldSubmit: (_) =>
                            FocusScope.of(context).requestFocus(PhoneFocusNode),
                      ),
                      UserTextField(
                        titleLabel: 'Enter your Phone Number',
                        focusnode: PhoneFocusNode,
                        inputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                        maxLength: 13,
                        icon: Icons.phone_android,
                        controller: phoneNoController,
                        inputType: TextInputType.number,
                        fieldSubmit: (_) => FocusScope.of(context)
                            .requestFocus(PasswordFocusNode),
                      ),
                      UserTextField(
                        titleLabel: 'Enter your password',
                        focusnode: PasswordFocusNode,
                        inputAction: TextInputAction.done,
                        maxLength: 8,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                        icon: Icons.phonelink_lock,
                        controller: passwordController,
                        inputType: TextInputType.text,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: RoundedButton(
                          title: 'Signup',
                          onpressed: () {
                            if(_key.currentState.validate()) {
                              Provider.of<AuthProvider>(context, listen: false)
                                  .signupUser(
                                  nameController.text.toString(),
                                  emailController.text.toString(),
                                  passwordController.text.toString(),
                                  phoneNoController.text.toString(),
                                  cityController.text.toString())
                                  .then((_) {
                                Navigator.of(context)
                                    .pushReplacementNamed(HomeScreen.routeArgs);
                              });
                            }else{
                              _showErrorDialog(context, 'Please Enter All Fields');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
