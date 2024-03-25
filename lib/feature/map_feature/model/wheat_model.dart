//pubdev libraries
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';

class DisplayPoint with ClusterItem {
  final int id;
  final int type;
  final double longitude;
  final double latitude;

  DisplayPoint({
    required this.id,
    required this.type,
    required this.longitude,
    required this.latitude,
  });

  static List<DisplayPoint> pointFromData({required List<dynamic> data}) {
    final points = data
        .map<DisplayPoint>((row) => DisplayPoint(
              id: row['id'],
              type: row['type'],
              latitude: row['lat'],
              longitude: row['long'],
            ))
        .toList();
    debugPrint(points.toString());
    return points;
  }

  @override
  LatLng get location => LatLng(latitude, longitude);
}
