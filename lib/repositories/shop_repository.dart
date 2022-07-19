import 'dart:convert';

import 'package:webixes/app_config.dart';
import 'package:webixes/data_model/shop_info_by_slug.dart';
import 'package:http/http.dart' as http;
import 'package:webixes/data_model/shop_response.dart';
import 'package:webixes/data_model/shop_details_response.dart';
import 'package:webixes/data_model/product_mini_response.dart';
import 'package:flutter/foundation.dart';
import 'package:webixes/helpers/shared_value_helper.dart';

class ShopRepository {
  Future<ShopResponse> getShops({name = "", page = 1}) async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}/shops" + "?page=${page}&name=${name}");
   // Uri.parse("${AppConfig.BASE_URL}/shops" + "?page=${page}&lat=18.520430&lag=73.856743");
    print("shop url-->$url");
    final response = await http.get(url,
      headers: {
        "App-Language": app_language.$,
      },);
    print("shop res-->${response.body}");
    return shopResponseFromJson(response.body);
  }

  Future<ShopResponse> getNearByShops({lat = 0,lag=0}) async {
    Uri url =
    //Uri.parse("${AppConfig.BASE_URL}/shops" + "?page=${page}&name=${name}");
    Uri.parse("${AppConfig.BASE_URL}/shops?lat=${lat}&lag=${lag}");
    print("Near by shop url-->$url");
    final response = await http.get(url,
      headers: {
        "App-Language": app_language.$,
      },);
    return shopResponseFromJson(response.body);
  }
  Future<ShopDetailsResponse> getShopInfo({@required id = 0}) async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/shops/details/${id}");
    final response =
        await http.get(url,
          headers: {
            "App-Language": app_language.$,
          },);
    print("shop details-->${response.body}");
    return shopDetailsResponseFromJson(response.body);
  }
  Future getShopLike({@required id = 0}) async {
//https://citydeal.co.in/city/api/v2/get_shop_likes?shop_id=2;
    Uri url =  Uri.parse("${AppConfig.BASE_URL}/get_shop_likes?shop_id=${id}");

    final response =
    await http.get(url,
      headers: {
        "App-Language": app_language.$,
      },);

   // var decodedRes=json.decode(response.body);
    return response.body;
  }

  Future getSocialLinks({@required id = 0}) async {
// https://citydeal.co.in/city/api/v2/get_socail_links?shop_id=2;
    Uri url =  Uri.parse("${AppConfig.BASE_URL}/get_socail_links?shop_id=${id}");

    final response =
    await http.get(url,
      headers: {
        "App-Language": app_language.$,
      },);

    // var decodedRes=json.decode(response.body);
    return response.body;
  }

  Future postLikes({@required id = 0,@required userId =0}) async {
    //https://citydeal.co.in/city/api/v2/post_shop_likes
    //https://citydeal.co.in/city/api/v2/post_shop_likes?shop_id=2&user_id=10
    Uri url =  Uri.parse("${AppConfig.BASE_URL}/post_shop_likes?shop_id=${id}&user_id=${user_id.$}");
  /*  var post_body = jsonEncode({
      "shop_id": "${id}",
      "user_id": "${user_id.$}",

    });
    print(post_body);*/
    final response = await http.post(url,
      headers: {
        "App-Language": app_language.$,
      },);
     print("ress-->${response.body}");
    // var decodedRes=json.decode(response.body);
    return response.body;
  }

  Future<ShopInfoBySlug> getShopInfobySlug({@required shopName = ""}) async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/shops/slug/${shopName}");
    final response =
    await http.get(url,
      headers: {
        "App-Language": app_language.$,
      },);
    print(response.body);
    return shopDetailsInfoBySlugResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTopFromThisSellerProducts({int id = 0}) async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/shops/products/top/" + id.toString());
    final response = await http
        .get(url,
      headers: {
        "App-Language": app_language.$,
      },);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getNewFromThisSellerProducts({int id = 0}) async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/shops/products/new/" + id.toString());
    final response = await http
        .get(url,
      headers: {
        "App-Language": app_language.$,
      },);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getfeaturedFromThisSellerProducts(
      {int id = 0}) async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/shops/products/featured/" + id.toString());
    final response = await http
        .get(url,
      headers: {
        "App-Language": app_language.$,
      },);
    return productMiniResponseFromJson(response.body);
  }
}
