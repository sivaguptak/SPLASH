class RedemptionModel {
  final String id;
  final String couponInstanceId;
  final String shopId;
  final double? billAmount;
  RedemptionModel({required this.id, required this.couponInstanceId, required this.shopId, this.billAmount});
  factory RedemptionModel.fromJson(Map<String,dynamic> j)=>RedemptionModel(
    id:j['id'], couponInstanceId:j['coupon_instance_id'], shopId:j['shop_id'],
    billAmount:(j['bill_amount'] as num?)?.toDouble());
}
