
import 'package:tsem/models/province.dart';
import 'package:tsem/models/district.dart';
import 'package:tsem/models/subdistrict.dart';
import 'package:tsem/services/address_api.dart';

class AddressProvider {
  AddressApi api = AddressApi();

  Future<Province> getProvince() async {
    return api.fetchProvince();
  }

  Future<District> getDistrict(
      {String province}) async {
    return api.fetchDistrict(province: province);
  }
    Future<SubDistrict> getSubDistrict(
      {String district}) async {
    return api.fetchSubDistrict(district: district);
  }

}