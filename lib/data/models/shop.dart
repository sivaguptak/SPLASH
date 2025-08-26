class ShopModel {
  final String id;
  final String name;
  final String? city;
  final bool approved;
  ShopModel({required this.id, required this.name, this.city, this.approved=false});
  factory ShopModel.fromJson(Map<String, dynamic> j)=>ShopModel(
    id: j['id'], name: j['name'], city: j['city'], approved: j['approved']??false
  );
  Map<String, dynamic> toJson()=>{'id':id,'name':name,'city':city,'approved':approved};
}
