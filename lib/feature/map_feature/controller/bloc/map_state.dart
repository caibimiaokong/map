part of 'map_bloc.dart';

enum MapStatus { initial, loading, loaded, error }

class MapState extends Equatable {
  final MapStatus status;
  final List<DisplayPoint> displayPoint;
  final MapType mapType;
  final CameraPosition cameraPosition;
  final DisplayPoint? selectedPoint;
  final String searchQuery;
  final List<Resources> searchResult;
  final List<Resources> recentSearches;
  final bool isWheatDisplay;
  final bool isHarvestDisplay;
  final bool isRescueDisplay;
  final bool isSerachFocus;

  const MapState({
    this.status = MapStatus.initial,
    this.displayPoint = const <DisplayPoint>[],
    this.mapType = MapType.normal,
    this.cameraPosition = const CameraPosition(
      target: LatLng(47.808376, 14.373285),
      zoom: 8,
    ),
    this.selectedPoint,
    this.searchQuery = '',
    this.searchResult = const <Resources>[],
    this.recentSearches = const <Resources>[],
    this.isWheatDisplay = true,
    this.isHarvestDisplay = true,
    this.isRescueDisplay = true,
    this.isSerachFocus = false,
  });

  MapState copyWith({
    MapStatus? status,
    List<DisplayPoint>? displayPoint,
    MapType? mapType,
    CameraPosition? cameraPosition,
    DisplayPoint? selectedPoint,
    bool clearSelectedStation = false,
    String? searchQuery,
    List<Resources>? searchResult,
    List<Resources>? recentSearches,
    bool? isWheatDisplay,
    bool? isHarvestDisplay,
    bool? isRescueDisplay,
    bool? isSerachFocus,
  }) {
    return MapState(
      status: status ?? this.status,
      displayPoint: displayPoint ?? this.displayPoint,
      mapType: mapType ?? this.mapType,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      selectedPoint:
          clearSelectedStation ? null : selectedPoint ?? this.selectedPoint,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResult: searchResult ?? this.searchResult,
      recentSearches: recentSearches ?? this.recentSearches,
      isWheatDisplay: isWheatDisplay ?? this.isWheatDisplay,
      isHarvestDisplay: isHarvestDisplay ?? this.isHarvestDisplay,
      isRescueDisplay: isRescueDisplay ?? this.isRescueDisplay,
      isSerachFocus: isSerachFocus ?? this.isSerachFocus,
    );
  }

  @override
  List<Object?> get props => [
        status,
        List.from(displayPoint),
        mapType,
        cameraPosition,
        selectedPoint,
        searchQuery,
        List.from(searchResult),
        List.from(recentSearches),
        isWheatDisplay,
        isHarvestDisplay,
        isRescueDisplay,
        isSerachFocus,
      ];
}
