import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tsem/components/custom_surfix_icon.dart';
import 'package:tsem/components/form_error.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/user.dart';
import 'package:tsem/provider/tsem_provider.dart';
import 'package:tsem/screens/home/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  FocusNode passwordFocusNode = FocusNode();
  final storage = new FlutterSecureStorage();

  String username;
  String password;
  bool remember = false;
  String storeUsername;
  String storePassword;
  final List<String> errors = [];

  Future<void> getRemember() async {
    storeUsername = await storage.read(key: USERNAME);
    storePassword = await storage.read(key: PASSWORD);
    if (storeUsername != null) {
      setState(() {
        username = storeUsername;
        password = storePassword;
        remember = true;
        return;
      });
    }
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  void initState() {
    super.initState();
    getRemember();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildUserNameFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Remember me"),
              Spacer(),
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // if all are valid then go to Home screen
                authenUser(
                    userid: username, password: password, remember: remember);
              }
            },
          ),
          SizedBox(height: getProportionateScreenHeight(15)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("TAP Sales Execution Mobile v.${kVersion}"),
              // Text("TAP Sales Execution Mobile v.1.1.0"),
            ],
          ),
        ],
      ),
    );
  }

  TextFormField buildUserNameFormField() {
    String _key = storeUsername == null ? 'user' : storeUsername;

    return TextFormField(
      key: Key(_key),
      initialValue: storeUsername,
      keyboardType: TextInputType.text,
      onSaved: (newValue) => username = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kUserNameNullError);
        }
        // else if (emailValidatorRegExp.hasMatch(value)) {
        //   removeError(error: kUserNameNullError);
        // }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kUserNameNullError);
          return "";
        }
        // else if (!emailValidatorRegExp.hasMatch(value)) {
        //   addError(error: kInvalidEmailError);
        //   return "";
        // }
        return null;
      },
      decoration: InputDecoration(
        labelText: "User name",
        hintText: "Enter your user name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User Icon.svg"),
      ),
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(passwordFocusNode);
      },
    );
  }

  TextFormField buildPasswordFormField() {
    String _key = storePassword == null ? 'pass' : storePassword;

    return TextFormField(
      key: Key(_key),
      initialValue: storePassword,
      focusNode: passwordFocusNode,
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 4) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 4) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
      onFieldSubmitted: (String value) {},
    );
  }

  void authenUser({String userid, String password, bool remember}) {
    MessageAlert messageAlert = MessageAlert();

    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  //key: key,
                  backgroundColor: Colors.blue,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(
                          backgroundColor: Colors.yellow,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please Wait....",
                          style: TextStyle(color: Colors.white),
                        )
                      ]),
                    )
                  ]));
        });

    TsemProvider().getUser(userId: userid, password: password).then((value) {
      User _user = value;

      if (_user.success == true) {
        final storage = FlutterSecureStorage();
        if (remember) {
          storage.write(key: USERNAME, value: userid);
          storage.write(key: PASSWORD, value: password);
        } else {
          storage.delete(key: USERNAME);
          storage.delete(key: PASSWORD);
        }
        storage.write(key: JDECODE, value: _user.jdeCode);
        storage.write(
            key: FULLNAME, value: _user.firstName + ' ' + _user.lastName);
        storage.write(key: FRISTNAME, value: _user.firstName);
        storage.write(key: APPLEVEL, value: _user.level);
        storage.write(key: DEPARTMENT, value: _user.department);
        storage.write(key: USERTOKEN, value: _user.token);

        if (_user.appversion != kVersion) {
          messageAlert.okAlert(
              context: context,
              message:
                  'Please update application in play store to version ${_user.appversion}',
              title: "Update Version");
        } else {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        }
        //Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } else {
        // messageAlert.okAlert(
        //     context: context, message: _user.message, title: "Login error");
        messageAlert.functAlert(
            context: context,
            message: "ตรวจสอบผู้ใช้งาน \n" + _user.message,
            function: () {
              Navigator.pop(context);
              Navigator.pop(context);
            });
      }
    }).catchError((e) {
      String msgText = "Login Error";

      if (e is DioError) {
        msgText = e.error.toString();
        if (DioErrorType.receiveTimeout == e.type ||
            DioErrorType.connectTimeout == e.type) {
          msgText =
              "Server is not reachable. Please verify your internet connection and try again";
        } else if (DioErrorType.response == e.type) {
          msgText = '4xx';
        }
        /*else if (DioErrorType.DEFAULT == e.type) {
          if (e.message.contains('SocketException')) {
            msgText = e.message;
          }
        } */
        else {
          msgText = "Problem connecting to the server. Please try again.";
        }
      } else {
        msgText = "Network error";
      }
      //print('error text ===>${e}');
      messageAlert.functAlert(
          context: context,
          message: "ตรวจสอบผู้ใช้งานไม่สำเร็จ \n" + msgText,
          function: () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
    });
  }

  void _launchURL() async {
    String url = "https://${endpoint}/apk/app-release.apk";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
