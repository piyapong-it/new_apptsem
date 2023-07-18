import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tsem/constants.dart';
import '../../../size_config.dart';

class UserBanner extends StatefulWidget {
  @override
  _UserBannerState createState() => _UserBannerState();
}

class _UserBannerState extends State<UserBanner> {
  final _storage = FlutterSecureStorage();
  String fullName;

  @override
  void initState() {
    super.initState();
    _readFullName();
  }

  Future<Null> _readFullName() async {
    fullName = await _storage.read(key: FULLNAME);

    setState(() {
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 90,
      width: double.infinity,
      margin: EdgeInsets.all(getProportionateScreenWidth(10)),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(10),
        vertical: getProportionateScreenWidth(5),
      ),
      decoration: BoxDecoration(
        color: Color(0xFF4A3298),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text.rich(
        TextSpan(
          style: TextStyle(color: Colors.white),
          children: [
            //TextSpan(text: "A Summer Surpise\n"),
            TextSpan(
              text: fullName,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(14),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
