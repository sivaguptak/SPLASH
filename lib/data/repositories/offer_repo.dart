import '../api/client.dart';
class OfferRepo {
  final ApiClient api;
  OfferRepo(this.api);
  Future<Map<String,dynamic>> createOffer(Map<String,dynamic> body) => api.postJson('/offers', body);
  Future<Map<String,dynamic>> listOffers() => api.getJson('/offers');
}
