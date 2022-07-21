import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:webixes/app_config.dart';
import 'package:webixes/helpers/shared_value_helper.dart';

class SellerPolicy extends StatefulWidget {
  int? id;

  SellerPolicy({Key? key, this.id}) : super(key: key);

  @override
  _SellerPolicyState createState() => _SellerPolicyState();
}

class _SellerPolicyState extends State<SellerPolicy> {
  var data;
  var title;
  var api;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    api = getSellerPolicy(widget.id ?? 0).then((value) {
      var decode = json.decode(value);

      if (decode["message"] != "no data found") {
        // title=decode["data"]["title"];
        data = decode["data"]["content"];
        print("title-->$title");
        print("title-->$data");
        if (data == null) {
          //data="No data found";
          return null;
        } else {
          return data;
        }
      } else {
        return null;
        //data="No data found";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
        future: api,
        builder: (context, snapshot) {
          print("sNN-->$snapshot");
          if (ConnectionState == ConnectionState.done && snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Seller policy page",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                Html(
                  style: {
                    'h1': Style(color: Colors.red),
                  },
                  data: data,
                  shrinkWrap: true,
                ),
              ],
            );
          } else {
            return Center(child: Text("No policy found"));
          }

          return Center(child: CircularProgressIndicator());
        },
      )

          /*data!=null?

             Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                data!="No data found"?
                Column(
                 children: [
                   SizedBox(height: 20,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text(title,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),)
                     ],
                   ),
                   Html(
                     style: {
                       'h1': Style(color: Colors.red),


                     },
                     data: data,shrinkWrap: true,
                   ),
                 ],
                ):Center(child: Text("No data found")
                )
             ]):Center(child: CircularProgressIndicator()),*/

          ),
    );
  }

  Future getSellerPolicy(int id) async {
    print("seller policy");
//https://citydeal.co.in/city/api/v2/policies/shop?type=seller_policy&shop_id=3
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/policies/shop?type=seller_policy&shop_id=$id");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print("Seller url-->$url");
    print("Seller policy res-->${response.body}");
    return response.body;
  }
}
