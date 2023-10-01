class User {
  int id;
  String username;
  String userEmail;
  int age;
  DateTime createdAt;
  DateTime updatedAt;
  bool isActive;
  String notes;
  String orderId;
  String tokenId;
  List<String> address;
  String phone;
  String billingAddress;
  String billingCity;
  String billingRegion;
  String billingPostcode;
  int role;
  int userStatus;

  User({
    required this.id,
    required this.username,
    required this.userEmail,
    required this.age,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.notes,
    required this.orderId,
    required this.tokenId,
    required this.address,
    required this.phone,
    required this.billingAddress,
    required this.billingCity,
    required this.billingRegion,
    required this.billingPostcode,
    required this.role,
    required this.userStatus,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      userEmail: json['userEmail'],
      age: json['age'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isActive: json['isActive'] == 1,
      notes: json['notes'],
      orderId: json['orderId'],
      tokenId: json['tokenId'],
      address: List<String>.from(json['address']),
      phone: json['phone'],
      billingAddress: json['billingAddress'],
      billingCity: json['billingCity'],
      billingRegion: json['billingRegion'],
      billingPostcode: json['billingPostcode'],
      role: json['role'],
      userStatus: json['userStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'userEmail': userEmail,
      'age': age,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive ? 1 : 0,
      'notes': notes,
      'orderId': orderId,
      'tokenId': tokenId,
      'address': address,
      'phone': phone,
      'billingAddress': billingAddress,
      'billingCity': billingCity,
      'billingRegion': billingRegion,
      'billingPostcode': billingPostcode,
      'role': role,
      'userStatus': userStatus,
    };
  }
}
