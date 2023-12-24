//pubdev libraries
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';

class DisplyPoint with ClusterItem {
  final int id;
  final LatLng position;
  final int type;

  DisplyPoint({
    required this.id,
    required this.position,
    required this.type,
  });

  static List<DisplyPoint> pointFromData({required List<dynamic> data}) {
    return data
        .map<DisplyPoint>((row) => DisplyPoint(
              id: row['id'],
              position: LatLng(row['lat'], row['lng']),
              type: row['type'],
            ))
        .toList();
  }

  @override
  LatLng get location => position;
}
