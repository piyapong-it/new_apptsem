import 'package:flutter/material.dart';
import 'package:tsem/screens/home/components/corporate_new.dart';
import 'package:tsem/screens/home/components/user_banner.dart';
import '../../../size_config.dart';
import 'categories.dart';
import 'home_header.dart';


class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(10)),
              HomeHeader(),
              //SizedBox(height: getProportionateScreenWidth(05)),
              UserBanner(),
              Categories(),
              //CorporateNews(),
              //SizedBox(height: getProportionateScreenWidth(30)),
            ],
          ),
        ),
      ),
    );
  }
}