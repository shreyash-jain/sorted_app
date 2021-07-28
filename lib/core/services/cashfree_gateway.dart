import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';



class CashFreeTest extends StatefulWidget {
  @override
  _CashFreeTestState createState() => _CashFreeTestState();
}

class _CashFreeTestState extends State<CashFreeTest> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    setState(() {});
  }

  void startNextScreen() {
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CFSDK Sample'),
        ),
        body: Center(
          child: RaisedButton(
            child: Text('DO PAYMENT'),
            onPressed: () {
              startNextScreen();
            },
          ),
        ),
      ),
    );
  }

  fetchPost() async {
    var order = new Order();
    print("order" + order.toString());
    var dio = Dio();
    final response = await dio
        .post(
            order.stage == "TEST"
                ? 'https://test.cashfree.com/api/v2/cftoken/order'
                : 'https://api.cashfree.com/api/v2/cftoken/order',
            options: Options(headers: {
              'x-client-id': order.appId,
              'x-client-secret': order.stage == "TEST"
                  ? 'aeef217006769ecacf02269f6c5b0c3dca9ab33b'
                  : '62f1476aee1c57c7bef6259e104f9a868b068ed6',
              'Content-Type': 'application/json'
            }),
            data: jsonEncode({
              'orderId': order.orderId,
              'orderAmount': order.orderAmount,
              'orderCurrency': order.orderCurrency,
            }));

    print("Token Gen Resp : " + response.data.toString());
    if (response.statusCode == 200) {
      order.tokenData = response.data['cftoken'];
      print('Token : ' + order.tokenData.toString());
      // If server returns an OK response, parse the JSON.
      var inputs = order.toMap();
      inputs.addAll(UIMeta().toMap());
      inputs.putIfAbsent('tokenData', () {
        return response.data['cftoken'];
      });
      inputs.forEach((key, value) {
        print("$key : $value");
      });
      CashfreePGSDK.doPayment(inputs)
          .then((value) => value?.forEach((key, value) {
        print("$key : $value");
      }));
    } else {
      // If that response was not OK, throw an error.
      print('Failed to generate token');
    }
  }
}

class Token {
  final String cfToken;

  Token({this.cfToken});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      cfToken: json['cftoken'],
    );
  }
}

class Order {
  Order() {
    appId = stage == "TEST"
        ? "863400fec37f2a501d940cd6e04368"
        : "1848d0ce8441fb8ffa258bc98481";
  }

  String stage = "TEST";
  String orderId = getRandomNo();
  String orderAmount = "1000";
  String tokenData = "";
  String customerName = "Arjun";
  String orderNote = "Order Note";
  String orderCurrency = "INR";
  String appId;
  String customerPhone = "9425677707";
  String customerEmail = "sample@gmail.com";
  String notifyUrl = "https://test.gocashfree.com/notify";

  static String getRandomNo() {
    var rng = new Random();
    return 'order ${rng.nextInt(1000000)}';
  }

  Map<String, dynamic> toMap() {
    return {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl
    };
  }

  String toString() {
    return " \norderId" +
        orderId +
        " \norderAmount " +
        orderAmount +
        " \ncustomerName " +
        customerName +
        " \norderNote " +
        orderNote +
        " \norderCurrency " +
        orderCurrency +
        " \nappId " +
        appId +
        " \ncustomerPhone " +
        customerPhone +
        " \ncustomerEmail " +
        customerEmail +
        " \nstage " +
        stage +
        " \nnotifyUrl " +
        notifyUrl+
        " \ntokenData " +
        tokenData;
  }
}

class UIMeta {
  String color1 = "#FF233F";
  String color2 = "#033400";
  String hideOrderId = "false";

  static String getRandomNo() {
    var rng = new Random();
    return 'order ${rng.nextInt(1000000)}';
  }

  Map<String, dynamic> toMap() {
    return {"color1": color1, "color2": color2};
  }

  String toString() {
    return " \ncolor1 $color1 \ncolor1  $color2  \nhideOrderId $hideOrderId";
  }
}