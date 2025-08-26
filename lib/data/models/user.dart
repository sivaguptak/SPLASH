class UserModel {
  final String id;
  final String phone;
  final String role; // customer|shop_owner|admin
  UserModel({required this.id, required this.phone, required this.role});
  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
    id: j['id'], phone: j['phone'], role: j['role']
  );
  Map<String, dynamic> toJson()=>{'id':id,'phone':phone,'role':role};
}
