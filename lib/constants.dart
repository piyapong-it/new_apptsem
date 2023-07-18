import 'package:flutter/material.dart';
import 'package:tsem/size_config.dart';

const kVersion = "1.0.1";
// const String endpoint = "192.168.1.55:3001";
//const String endpoint = "172.32.100.95:3001";
/*Development*/
//  const String endpoint = "10.0.2.2:3000";
const String endpoint = "172.32.100.33:3003";

/*Production*/
//const String endpoint = "tap.tapb.co.th:3001";
//current
// const String endpoint = "tap.tapb.co.th:3003";

const String JDECODE = "jdecode";
const String FULLNAME = "fullname";
const String APPLEVEL = "applevel";
const String DEPARTMENT = "department";
const String USERNAME = "username";
const String PASSWORD = "password";
const String USERTOKEN = "usertoken";
const String FRISTNAME = 'firstName';
const String APPROVED = 'approved';
const String PLANAPPROVED = 'planapprove';


const kPrimaryColor = Color(0xFF1976D2);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
const String kUserNameNullError = "Please Enter your user name";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
