import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:wheatmap/feature/map_feature/model/wheat_model.dart';
import 'package:wheatmap/feature/map_feature/model/search_model.dart';

class MapRespository {
  MapRespository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;
  final SupabaseClient _supabaseClient;

  //receive current location
  Future<LatLng> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition().then((value) {
      return LatLng(value.latitude, value.longitude);
    });
  }

  //request Permission
  Future requestPermission() async {
    if (!kIsWeb) {
      await Geolocator.openLocationSettings();
    }
  }

  Future getDisplayPointsByLocation(
      {required double longitude,
      required double latitude,
      bool? iswheatDisplay = true,
      bool? isRescueDisplay = true,
      bool? isHarvestDisplay = true}) async {
    late final PostgrestResponse res;
    res = await _supabaseClient.rpc(
      'display_point',
      params: <String, dynamic>{
        'long': longitude,
        'lat': latitude,
        'iswheat': iswheatDisplay,
        'isharvest': isHarvestDisplay,
        'isrescue': isRescueDisplay,
      },
    );

    final status = res.status;
    final data = res.data;
    if (status != 200) {
      throw PlatformException(code: 'getVideosFromLocation error');
    } else if (data == null) {
      throw PlatformException(code: 'getVideosFromLocation error null data');
    }
    final points = DisplyPoint.pointFromData(
      data: data,
    );
    return points;
  }

  Future getDisplayPointsByBounds(LatLngBounds bounds, bool iswheatDisplay,
      bool isRescueDisplay, bool isHarvestDisplay) async {
    late final PostgrestResponse res;
    res = await _supabaseClient.rpc(
      'points_in_view',
      params: <String, dynamic>{
        'min_long': bounds.southwest.longitude,
        'min_lat': bounds.southwest.latitude,
        'max_long': bounds.northeast.longitude,
        'max_lat': bounds.northeast.latitude,
        'iswheat': iswheatDisplay,
        'isrescue': isRescueDisplay,
        'isharvest': isHarvestDisplay,
      },
    );

    final status = res.status;
    final data = res.data;
    if (status != 200) {
      throw PlatformException(code: 'getVideosFromLocation error');
    } else if (data == null) {
      throw PlatformException(code: 'getVideosFromLocation error null data');
    }
    final points = DisplyPoint.pointFromData(
      data: data,
    );
    return points;
  }

  Future<List<Resources>> searchPlace(String query) async {
    //write a http request to get the data
    final url = Uri.parse(
        'http://dev.virtualearth.net/REST/v1/Locations?q=$query&key=AtcygPzKZ_FIljRVWMdfKhcusLrvAg-JJ2Te1UOlObrPTAj8C0stK9CLNdFoOzJK');
    final response = await http.get(url);
    SearchPlace place = SearchPlace.fromJson(jsonDecode(response.body));
    if (place.statusCode != 200) {
      throw PlatformException(code: 'searchPlace error');
    } else if (place.resourceSets == null) {
      throw PlatformException(code: 'searchPlace error null data');
    }
    return place.resourceSets!.first.resources!;
  }
}
