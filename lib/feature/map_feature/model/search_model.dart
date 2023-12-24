import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchPlace {
  List<ResourceSets>? resourceSets;
  int? statusCode;

  SearchPlace({
    this.resourceSets,
    this.statusCode,
  });

  SearchPlace.fromJson(Map<String, dynamic> json) {
    if (json['resourceSets'] != null) {
      resourceSets = <ResourceSets>[];
      json['resourceSets'].forEach((v) {
        resourceSets!.add(ResourceSets.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (resourceSets != null) {
      data['resourceSets'] = resourceSets!.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = statusCode;
    return data;
  }
}

class ResourceSets {
  List<Resources>? resources;

  ResourceSets({this.resources});

  ResourceSets.fromJson(Map<String, dynamic> json) {
    if (json['resources'] != null) {
      resources = <Resources>[];
      json['resources'].forEach((v) {
        resources!.add(Resources.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (resources != null) {
      data['resources'] = resources!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Resources {
  Point? point;
  Address? address;

  Resources({
    this.point,
    this.address,
  });

  Resources.fromJson(Map<String, dynamic> json) {
    point = json['point'] != null ? Point.fromJson(json['point']) : null;
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (point != null) {
      data['point'] = point!.toJson();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class Point {
  LatLng? coordinates;

  Point({this.coordinates});

  Point.fromJson(Map<String, dynamic> json) {
    coordinates = LatLng(json['coordinates']![0], json['coordinates'][1]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coordinates'] = coordinates;
    return data;
  }
}

class Address {
  //formattedAddress
  //locality-->adminDistrict-->countryRegion
  String? adminDistrict;
  String? countryRegion;
  String? formattedAddress;
  String? locality;

  Address({
    this.adminDistrict,
    this.countryRegion,
    this.formattedAddress,
    this.locality,
  });

  Address.fromJson(Map<String, dynamic> json) {
    adminDistrict = json['adminDistrict'];
    countryRegion = json['countryRegion'];
    formattedAddress = json['formattedAddress'];
    locality = json['locality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adminDistrict'] = adminDistrict;
    data['countryRegion'] = countryRegion;
    data['formattedAddress'] = formattedAddress;
    data['locality'] = locality;
    return data;
  }
}
