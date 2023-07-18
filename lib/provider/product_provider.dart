
import 'package:tsem/models/productmaster.dart';
import 'package:tsem/models/productmasterbyvisit.dart';
import 'package:tsem/services/product_api.dart';

class ProductProvider {
  ProductApi api = ProductApi();


  Future<ProductMaster> getProductMaster({String own}) async {
    return api.fetchProductMaster(own: own);
  }

  Future<ProductMasterByVisit> getProductMasterByVisit(
      {String own, String visitid}) async {
    return api.fetchProductByVisitId(own: own, visitid: visitid);
  }

}