import '../api/client.dart';
class CouponRepo {
  final ApiClient api;
  CouponRepo(this.api);
  Future<Map<String,dynamic>> distribute(String distributorShopId, String offerId) =>
    api.postJson('/distribute', {'distributor_shop_id': distributorShopId, 'offer_id': offerId});
  Future<Map<String,dynamic>> redeem(String token, String shopId, {double? billAmount}) =>
    api.postJson('/redeem', {'token': token, 'shop_id': shopId, if (billAmount!=null) 'bill_amount': billAmount});
}
