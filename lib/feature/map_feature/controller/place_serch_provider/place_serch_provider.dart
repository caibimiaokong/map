import 'dart:convert';

import 'package:flutter/material.dart';

//pubdev libraries
import 'package:geocoding/geocoding.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:google_maps_webservice/places.dart';

//local libraries

////存在的几个问题
///1. response的结构体不清楚
///2. 路由问题
class PlaceSearchProvider extends ChangeNotifier {
  final Placemark _pickPlaceMark = Placemark();
  Placemark get pickPlaceMark => _pickPlaceMark;

  List<Prediction> _predictionList = [];

  Future<List<Prediction>> searchLocation(
      BuildContext context, String text) async {
    // ignore: unnecessary_null_comparison
    if (text != null && text.isNotEmpty) {
      http.Response response = await getLocationData(text);
      var data = jsonDecode(response.body.toString());
      if (data['status'] == 'OK') {
        _predictionList = [];
        data['predictions'].forEach((prediction) =>
            _predictionList.add(Prediction.fromJson(prediction)));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['error_message']),
          ),
        );
      }
    }
    return _predictionList;
  }

  Future<http.Response> getLocationData(String text) async {
    http.Response response;

    response = await http.get(Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$text&key=YOUR_API_KEY')

        // Uri.parse("http://mvs.bslmeiyu.com/api/v1/config/place-api-autocomplete?search_text=$text"),
        //   headers: {"Content-Type": "application/json"},
        );

    debugPrint(jsonDecode(response.body));
    return response;
  }
}
