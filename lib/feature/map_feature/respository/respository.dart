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
  final SupabaseClient _supabaseClient;
  MapRespository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  //receive current location
  Future<LatLng> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    final result = await Geolocator.requestPermission();
    if (result == LocationPermission.denied ||
        result == LocationPermission.deniedForever) {
      return const LatLng(37.43296265331129, -122.08832357078792);
    }

    //test location service whether enabled or not
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const LatLng(37.43296265331129, -122.08832357078792);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return const LatLng(37.43296265331129, -122.08832357078792);
      }
    }
    final position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  //request Permission
  Future requestPermission() async {
    if (!kIsWeb) {
      await Geolocator.openLocationSettings();
    }
  }

  Future getDisplayPointsByLocation(LatLng location, bool iswheatDisplay,
      bool isRescueDisplay, bool isHarvestDisplay) async {
    late final PostgrestResponse res;
    res = await _supabaseClient.rpc(
      'nearby_videos',
      params: <String, dynamic>{
        'location': 'POINT(${location.longitude} ${location.latitude})',
        'wheat': iswheatDisplay,
        'rescue': isRescueDisplay,
        'harvest': isHarvestDisplay,
      },
    ).limit(5);

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
      'videos_in_bounds',
      params: <String, dynamic>{
        'min_lng': '${bounds.southwest.longitude}',
        'min_lat': '${bounds.southwest.latitude}',
        'max_lng': '${bounds.northeast.longitude}',
        'max_lat': '${bounds.northeast.latitude}',
        'wheat': iswheatDisplay,
        'rescue': isRescueDisplay,
        'harvest': isHarvestDisplay,
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

  Future searchPlace(String query) async {
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
    return place.resourceSets;
  }
}
