class CouponInstance {
  final String id;
  final String offerId;
  final String issuerShopId;
  final String distributorShopId;
  final String state; // issued|redeemed|expired|void
  CouponInstance({required this.id, required this.offerId, required this.issuerShopId,
    required this.distributorShopId, required this.state});
  factory CouponInstance.fromJson(Map<String,dynamic> j)=>CouponInstance(
    id:j['id'], offerId:j['offer_id'], issuerShopId:j['issuer_shop_id'],
    distributorShopId:j['distributor_shop_id'], state:j['state']);
}
