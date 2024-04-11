import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/show_message.dart';

class SharedHelper {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static bool checkFirstTime() =>
      prefs.getBool(SharedKeys.isFirstTime.name) ?? true;

  static Future<void> editFirstTime() =>
      prefs.setBool(SharedKeys.isFirstTime.name, false);

  static bool checkLogin() => prefs.getBool(SharedKeys.isLogin.name) ?? false;

  static Future<void> editLogin() =>
      prefs.setBool(SharedKeys.isLogin.name, true);

  static Future<void> logout() => prefs.setBool(SharedKeys.isLogin.name, false);

  static String? getUserId() => prefs.getString(SharedKeys.userId.name);

  static Future<void> deleteCart() async {
    await prefs.remove(SharedKeys.cart.name);
  }

  static Future<void> setUserId(String id) =>
      prefs.setString(SharedKeys.userId.name, id);

  static List<Map> getCart() {
    var data = prefs.getStringList(SharedKeys.cart.name) ?? [];

    return data.map((e) => jsonDecode(e) as Map).toList();
  }

  static Future<void> setProductToCart(
      Map product, BuildContext context) async {
    List<String> data = prefs.getStringList(SharedKeys.cart.name) ?? [];
    var products = data.map((e) => jsonDecode(e) as Map).toList();

    if (products
        .where((element) => element["name"] == product["name"])
        .isEmpty) {
      data.add(jsonEncode(product));
      await prefs.setStringList(SharedKeys.cart.name, data).then((value) {
        ShowMessage.showMessage(context, "${product["name"]} added to Cart");
      });
    } else {
      ShowMessage.showMessage(
          context, "${product["name"]} already added to Cart");
    }
  }
}

enum SharedKeys {
  isFirstTime,
  isLogin,
  userId,
  cart,
}
