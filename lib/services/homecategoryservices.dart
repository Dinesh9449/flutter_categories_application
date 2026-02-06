import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_categories_application/models/homecategorymodel.dart';

class Homecategoryservices {
  static const String baseUrl =
      'https://api.jsonbin.io/v3/b/68c1656c43b1c97be93db48e';

  static Future<HomeCategoriesModel?> fetchHomeCategories() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      /*  final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-Bin-Meta': 'false', // ✅ REQUIRED
        },
      );*/
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return HomeCategoriesModel.fromJson(jsonData);
      } else {
        print('Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return null;
    }

    /* try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return HomeCategoriesModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return null;
    }*/
  }
}
