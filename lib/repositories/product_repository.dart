import 'package:webixes/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:webixes/data_model/product_mini_response.dart';
import 'package:webixes/data_model/product_details_response.dart';
import 'package:webixes/data_model/variant_response.dart';
import 'package:flutter/foundation.dart';
import 'package:webixes/helpers/shared_value_helper.dart';

class ProductRepository {
  Future<ProductMiniResponse> getFeaturedProducts({page = 1}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/featured?page=${page}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBestSellingProducts() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/best-seller");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTodaysDealProducts() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/todays-deal");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFlashDealProducts(
      {@required int id = 0}) async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}/flash-deal-products/" + id.toString());
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getCategoryProducts(
      {@required int id = 0, name = "", page = 1}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/category/" +
        id.toString() +
        "?page=${page}&name=${name}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getCategoryWiseProducts(
      {apiUrl, page = 1}) async {
    print("API CALLing 23");

    print("url-->${apiUrl}");
    Uri url = Uri.parse("$apiUrl");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });

    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getShopProducts(
      {@required int id = 0, name = "", page = 1}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/seller/" +
        id.toString() +
        "?page=${page}&name=${name}");

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });

    return productMiniResponseFromJson(response.body);
  }

//api for filter shop product
  Future<ProductMiniResponse> getShopCatWiseProductsFilter(
      {int id = 0, int catID = 0, name = "", page = 1}) async {
    //https://citydeal.co.in/city/api/v2/products/seller/3?page=1&category_id=249&brand_id=230
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/products/seller/${id.toString()}?page=${page}&category_id=${catID}");
    print("url-->$url");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print("filter pp-->${response.body}");
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getShopBrandWiseProductsFilter(
      {int id = 0, int brandID = 0, name = "", page = 1}) async {
    //https://citydeal.co.in/city/api/v2/products/seller/3?page=1&category_id=249&brand_id=230
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/products/seller/${id.toString()}?page=${page}&brand_id=$brandID");
    print("url-->$url");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print("filter pp-->${response.body}");
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> catBrandFilter(
      {int id = 0, int catID = 0, int brandID = 0, name = "", page = 1}) async {
    //https://citydeal.co.in/city/api/v2/products/seller/3?page=1&category_id=249&brand_id=230
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/products/seller/${id.toString()}?page=${page}&category_id=${catID}&brand_id=$brandID");
    print("url-->$url");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print("filter pp-->${response.body}");
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBrandProducts(
      {@required int id = 0, name = "", sort_key = "", page = 1}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/brand/" +
        id.toString() +
        "?page=${page}&name=${name}&selectedSort=${sort_key}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFilteredProducts(
      {name = "",
      sort_key = "",
      page = 1,
      brands = "",
      categories = "",
      min = "",
      max = ""}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/search" +
        "?page=${page}&name=${name}&sort_key=${sort_key}&brands=${brands}&categories=${categories}&min=${min}&max=${max}");

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print("product url-->$url");
    print("product res-->${response.body}");
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductDetailsResponse> getProductDetails(
      {@required int id = 0}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/" + id.toString());
    print(url.toString());
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print(response.body.toString());

    print("product details are ${response.body}");
    return productDetailsResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getRelatedProducts({@required int id = 0}) async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}/products/related/" + id.toString());
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTopFromThisSellerProducts(
      {@required int id = 0}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/products/top-from-seller/" + id.toString());
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<VariantResponse> getVariantWiseInfo(
      {int id = 0, color = '', variants = ''}) async {
    String encodeVariant = "$variants";
    var parsedData = Uri.encodeComponent(encodeVariant);
    print("parsedData-->$parsedData");
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/products/variant/price?id=${id.toString()}&color=${color}&variants=${parsedData}");

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });

    print("url-->$url");
    print("varient res-->${response.body}");
    return variantResponseFromJson(response.body);
  }
}
