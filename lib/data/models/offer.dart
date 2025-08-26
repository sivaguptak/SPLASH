class OfferModel {
  final String id;
  final String shopId;
  final String title;
  final String pricingMode; // actual_offer|flat|percent
  final double? actualPrice, offerPrice, flatOffAmount, minPurchaseAmt;
  final int? percentOff;
  OfferModel({required this.id, required this.shopId, required this.title, required this.pricingMode,
    this.actualPrice, this.offerPrice, this.flatOffAmount, this.percentOff, this.minPurchaseAmt});
  factory OfferModel.fromJson(Map<String, dynamic> j)=>OfferModel(
    id:j['id'], shopId:j['shop_id'], title:j['title'], pricingMode:j['pricing_mode'],
    actualPrice:(j['actual_price'] as num?)?.toDouble(),
    offerPrice:(j['offer_price'] as num?)?.toDouble(),
    flatOffAmount:(j['flat_off_amount'] as num?)?.toDouble(),
    percentOff:j['percent_off'],
    minPurchaseAmt:(j['min_purchase_amt'] as num?)?.toDouble(),
  );
}
