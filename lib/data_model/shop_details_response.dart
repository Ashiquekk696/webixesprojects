// To parse this JSON data, do
//
//     final shopDetailsResponse = shopDetailsResponseFromJson(jsonString);
// https://app.quicktype.io/
import 'dart:convert';

ShopDetailsResponse shopDetailsResponseFromJson(String str) =>
    ShopDetailsResponse.fromJson(json.decode(str));

//String shopDetailsResponseToJson(ShopDetailsResponse data) => json.encode(data.toJson());

class ShopDetailsResponse {
  ShopDetailsResponse({
    this.shops,
    this.success,
    this.status,
  });

  List<Shop>? shops;
  bool? success;
  int? status;

  factory ShopDetailsResponse.fromJson(Map<String, dynamic> json) =>
      ShopDetailsResponse(
        shops: List<Shop>.from(json["data"].map((x) => Shop.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );
}

class Shop {
  Shop({
    this.id,
    this.user_id,
    this.name,
    this.logo,
    this.sliders,
    this.address,
    this.facebook,
    this.google,
    this.twitter,
    this.true_rating,
    this.rating,
  });

  int? id;
  int? user_id;
  String? name;
  String? logo;
  List<String>? sliders;
  String? address;
  String? facebook;
  String? google;
  String? twitter;
  int? true_rating;
  int? rating;

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json["id"],
        user_id: json["user_id"],
        name: json["name"],
        logo: json["logo"],
        sliders: List<String>.from(json["sliders"].map((x) => x)),
        address: json["address"] == null ? null : json["address"],
        facebook: json["facebook"] == null ? null : json["facebook"],
        google: json["google"] == null ? null : json["google"],
        twitter: json["twitter"] == null ? null : json["twitter"],
        true_rating: json["true_rating"],
        rating: json["rating"],
      );
}
