import 'package:flutter/material.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';
import '../../../size_config.dart';
import 'icon_btn.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'TAP Sales Execution Mobile',
            style: TextStyle(
              fontSize: getProportionateScreenWidth(14.0),
              color: Colors.black,
            ),
          ),
          IconBtn(
            svgSrc: "assets/icons/Log out.svg",
            press: () => Navigator.pushReplacementNamed(context, SignInScreen.routeName),
          ),
        ],
      ),
    );
  }
}
