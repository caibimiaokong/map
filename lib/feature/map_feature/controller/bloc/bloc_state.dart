part of 'bloc_bloc.dart';

enum MapStatus { initial, loading, loaded, error }

class MapState extends Equatable {
  final MapStatus status;
  final LatLng searchLocation;
  final List<DisplyPoint> displayPoints;
  final LatLngBounds? bounds;
  final MapType mapType;
  final bool iswheatDisplay;
  final bool isRescueDisplay;
  final bool isHarvestDisplay;
  final CameraPosition cameraPosition;
  final DisplyPoint? selectedPoint;
  final String searchQuery;
  final bool isSerachFocus;
  final List<Resources> recentSearches;
  final List<Resources> resources;

  const MapState({
    this.status = MapStatus.initial,
    this.searchLocation = const LatLng(37.43296265331129, -122.08832357078792),
    this.bounds,
    this.displayPoints = const <DisplyPoint>[],
    this.mapType = MapType.normal,
    this.iswheatDisplay = true,
    this.isRescueDisplay = true,
    this.isHarvestDisplay = true,
    this.cameraPosition = const CameraPosition(
      target: LatLng(47.808376, 14.373285),
      zoom: 8,
    ),
    this.selectedPoint, //selectedPoint is used to display bottom sheet
    this.searchQuery = '',
    this.isSerachFocus = false,
    this.recentSearches = const <Resources>[],
    this.resources = const <Resources>[],
  });

  MapState copyWith({
    MapStatus? status,
    LatLng? searchLocation,
    LatLngBounds? bounds,
    List<DisplyPoint>? stations,
    MapType? mapType,
    bool? iswheatDisplay,
    bool? isRescueDisplay,
    bool? isHarvestDisplay,
    CameraPosition? cameraPosition,
    DisplyPoint? selectedPoint,
    bool? clearSelectedPoint = false,
    String? searchQuery,
    bool? isSerachFocus = false,
    List<Resources>? recentSearches,
    List<Resources>? resources,
  }) {
    return MapState(
      status: status ?? this.status,
      bounds: bounds ?? this.bounds,
      searchLocation: searchLocation ?? this.searchLocation,
      displayPoints: stations ?? displayPoints,
      mapType: mapType ?? this.mapType,
      iswheatDisplay: iswheatDisplay ?? this.iswheatDisplay,
      isRescueDisplay: isRescueDisplay ?? this.isRescueDisplay,
      isHarvestDisplay: isHarvestDisplay ?? this.isHarvestDisplay,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      selectedPoint: selectedPoint ?? this.selectedPoint,
      searchQuery: searchQuery ?? this.searchQuery,
      isSerachFocus: isSerachFocus ?? this.isSerachFocus,
      recentSearches: recentSearches ?? this.recentSearches,
      resources: resources ?? this.resources,
    );
  }

  @override
  List<Object?> get props => [
        status,
        bounds,
        displayPoints,
        mapType,
        iswheatDisplay,
        isRescueDisplay,
        isHarvestDisplay,
        cameraPosition,
        selectedPoint,
        searchQuery,
        isSerachFocus,
        recentSearches,
        resources,
      ];
}
