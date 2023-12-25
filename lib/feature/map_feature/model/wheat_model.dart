//pubdev libraries
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';

class DisplyPoint with ClusterItem {
  final int id;
  final int type;
  final double longitude;
  final double latitude;

  DisplyPoint({
    required this.id,
    required this.type,
    required this.longitude,
    required this.latitude,
  });

  static List<DisplyPoint> pointFromData({required List<dynamic> data}) {
    return data
        .map<DisplyPoint>((row) => DisplyPoint(
              id: row['id'],
              type: row['type'],
              latitude: row['lat'],
              longitude: row['long'],
            ))
        .toList();
  }

  @override
  LatLng get location => LatLng(latitude, longitude);
}
