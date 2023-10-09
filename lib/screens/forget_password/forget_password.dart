import 'dart:ffi';
import 'package:tsem/components/custom_surfix_icon.dart';
import 'package:tsem/components/default_button.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/provider/tsem_provider.dart';
import 'package:tsem/screens/home/home_screen.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';
import 'package:tsem/size_config.dart';
import 'package:validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:tsem/components/default_control.dart';

class ForgetPassword extends StatefulWidget {
  static String routeName = "/signup";
  const ForgetPassword();

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  MessageAlert messageAlert = MessageAlert();
  final TextEditingController _userId = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool passwordVisible = true;
  var _txtShow = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => {Navigator.pop(context)}),
          title: DefaultControl.headerText(headText: "Forget Password Forms"),
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(children: [
                _TextFeild(_userId, 6, 14.0, true, TextInputType.number,
                    "Employee No.", Icons.account_box, '', 'รหัสพนักงาน'),
                SizedBox(height: 8),
                TextField(
                  maxLength: 20,
                  controller: _password,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: Colors.white,
                    border: UnderlineInputBorder(),
                    hintText: "Password",
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            passwordVisible = !passwordVisible;
                          },
                        );
                      },
                    ),
                    alignLabelWithHint: false,
                    filled: true,
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(
                  height: 3,
                ),
                _txtShow != ''
                    ? _buildChip(_txtShow, Colors.orange.shade500)
                    : SizedBox(
                        height: 2,
                      ),
                SizedBox(height: getProportionateScreenHeight(15)),
                DefaultButton(
                  text: "Update",
                  press: () {
                    validate();
                  },
                ),
              ]),
            ),
          ),
        ));
  }

  String validate() {
    if (_userId.text == '' || _userId.text.length != 6) {
      setState(() {
        _txtShow = 'Enter Employee No. 6 length';
      });
    } else if (_password.text == '') {
      setState(() {
        _txtShow = 'Enter Password';
      });
    } else if (_password.text.length < 5) {
      setState(() {
        _txtShow = 'Password is too short';
      });
    } else {
      setState(() {
        _txtShow = '';
      });
      submit();
    }
  }

  void submit() async {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child:
                  SimpleDialog(backgroundColor: Colors.blue, children: <Widget>[
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

    final data = {"userID": _userId.text, "password": _password.text};
    await TsemProvider().updatePassword(data: data).then((value) {
      print('message ${value.message}');
      setState(() {
        Navigator.pop(context);
      });
      if (!value.success) {
        messageAlert.okAlert(
            context: context, message: value.message, title: "Alert");
      } else {
        messageAlert.functAlert(
            context: context,
            message: "Change password success.",
            function: () {
              Navigator.pushReplacementNamed(context, SignInScreen.routeName);
            });
      }
    }).catchError((e) {
        setState(() {
        Navigator.pop(context);
      });
      messageAlert.okAlert(
          context: context,
          message: e.toString(),
          title: "Please contact admin");
    });
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.white70,
        child: Text(label[0].toUpperCase()),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
    );
  }

  Widget _TextFeild(controller, maxLength, fontSize, enabled, keyboardType,
      labelText, icon, suffixIcon, hintText) {
    return Container(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              maxLength: maxLength,
              controller: controller,
              style: TextStyle(fontSize: fontSize),
              enabled: enabled,
              keyboardType: keyboardType,
              maxLines: null,
              decoration: InputDecoration(
                counterText: "",
                labelText: labelText,
                hintText: hintText,
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  icon,
                  color: Colors.blueAccent,
                ),
                suffixIcon: CustomSurffixIcon(svgIcon: suffixIcon),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
