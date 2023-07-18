
import 'package:tsem/models/assetmaster.dart';
import 'package:tsem/models/dmlmessage.dart';
import 'package:tsem/services/asset_api.dart';

class AssetProvider {
  AssetApi api = AssetApi();

  Future<AssetMaster> getAssetMaster({String outletid, String qrid}) async {
    return api.fetchAssetMaster(outletid: outletid, qrid: qrid);
  }

  Future<DmLmessage> updateAsset(
      {String stickerid,
        String outletid,
        String assetcategory,
        String assetstatus,
        String assetsno,
        String assetjdeno,
        String assetremark,
        int assetquantity}) async {
    return api.updateAsset(
        stickerid: stickerid,
        outletid: outletid,
        assetcategory: assetcategory,
        assetstatus: assetstatus,
        assetsno: assetsno,
        assetjdeno: assetjdeno,
        assetremark: assetremark,
        assetquantity: assetquantity);
  }
}