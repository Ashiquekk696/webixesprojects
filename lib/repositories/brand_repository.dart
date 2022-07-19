import 'package:webixes/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:webixes/data_model/brand_response.dart';
import 'package:webixes/helpers/shared_value_helper.dart';

class BrandRepository {

  Future<BrandResponse> getFilterPageBrands() async {
    // https://citydeal.co.in/city/api/v2/filter/brands?seller_id=10
    Uri url = Uri.parse("${AppConfig.BASE_URL}/filter/brands");
    final response =
    await http.get(url,headers: {
      "App-Language": app_language.$,
    });
    return brandResponseFromJson(response.body);
  }

  Future<BrandResponse> getFilterSellerBrands({id=0}) async {
    // https://citydeal.co.in/city/api/v2/filter/brands?seller_id=10
    Uri url = Uri.parse("${AppConfig.BASE_URL}/filter/brands?seller_id=$id");
    print(url);
    final response =
    await http.get(url,headers: {
      "App-Language": app_language.$,
    });
    print("shop brand-->${response.body}");
    return brandResponseFromJson(response.body);
  }


  Future<BrandResponse> getBrands({name = "", page = 1}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/brands"+
        "?page=${page}&name=${name}");
    final response =
    await http.get(url,headers: {
      "App-Language": app_language.$,
    });
    return brandResponseFromJson(response.body);
  }



}
