import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';

import 'package:wheatmap/feature/map_feature/model/wheat_model.dart';
import 'package:wheatmap/feature/map_feature/model/search_model.dart';
import 'package:wheatmap/feature/map_feature/respository/respository.dart';

part 'bloc_event.dart';
part 'bloc_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final _levels = const [1.0, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5];
  final MapRespository _mapRespository;
  GoogleMapController? _mapController;
  MapBloc({required MapRespository mapRespository})
      : _mapRespository = mapRespository,
        super(const MapState()) {
    on<FetchByLocation>((event, emit) {
      _onFetchByLocation;
    });
    on<FetchByBounds>((event, emit) {
      _onFetchByBounds;
    });
    on<ClusterPointTappedEvent>((event, emit) {
      _onClusterPointTappedEvent;
    });
    on<ChangeMapTypeEvent>((event, emit) {
      _onChangeMapTypeEvent;
    });
    on<LocationRequestedEvent>((event, emit) {
      _onLocationRequestedEvent;
    });
    on<PermissionRequestEvent>((event, emit) {
      _onPermissionRequestEvent;
    });
    on<SearchQueryChangedEvent>((event, emit) {
      _onSearchQueryChangedEvent;
    });
    on<AddToRecentSearchesEvent>((event, emit) {
      _onAddToRecentSearchesEvent;
    });
    on<ClearSearchQueryEvent>((event, emit) {
      _onClearSearchQueryEvent;
    });
    on<PlaceSelectedViaSearchEvent>((event, emit) {
      _placeSelectedViaSearchEvent;
    });
    on<OnCameraMoveEvent>((event, emit) {
      _onOnCameraMoveEvent;
    });
  }

  //init mapController
  void initMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  //fetch display points from supabase by location
  Future _onFetchByLocation(
      FetchByLocation event, Emitter<MapState> emit) async {
    try {
      final searchLocation = await _mapRespository.determinePosition();
      emit(state.copyWith(
        status: MapStatus.loading,
      ));
      final points = await _mapRespository.getDisplayPointsByLocation(
          longitude: searchLocation.longitude,
          latitude: searchLocation.latitude,
          iswheatDisplay: state.iswheatDisplay,
          isHarvestDisplay: state.isHarvestDisplay,
          isRescueDisplay: state.isRescueDisplay);
      emit(state.copyWith(
        status: MapStatus.loaded,
        stations: points,
        cameraPosition: CameraPosition(
          target: searchLocation,
          zoom: _levels[0],
        ),
      ));
    } catch (e) {
      emit(state.copyWith(status: MapStatus.error));
    }
  }

  //fetch display points from supabase by bounds
  Future _onFetchByBounds(FetchByBounds event, Emitter<MapState> emit) async {
    try {
      emit(state.copyWith(status: MapStatus.loading));
      final visibleRegion = await _mapController!.getVisibleRegion();
      final points = await _mapRespository.getDisplayPointsByBounds(
          visibleRegion,
          state.iswheatDisplay,
          state.isHarvestDisplay,
          state.isRescueDisplay);
      emit(state.copyWith(
        status: MapStatus.loaded,
        stations: points,
      ));
    } catch (e) {
      emit(state.copyWith(status: MapStatus.error));
    }
  }

  //when cluster point tapped,if cluster has only one point,animate camera to that point;
  //if cluster has more than one point,animate camera to next level
  Future _onClusterPointTappedEvent(
      ClusterPointTappedEvent event, Emitter<MapState> emit) async {
    final Iterable<DisplyPoint> disPlayPoints =
        event.cluster.items.cast<DisplyPoint>();
    if (disPlayPoints.length == 1) {
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: event.cluster.location,
          zoom: _levels.last,
        ),
      ));
      final station = disPlayPoints.first;
      emit(state.copyWith(selectedPoint: station));
    } else {
      final zoomLevel = await _mapController?.getZoomLevel();
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: event.cluster.location,
          zoom: _getNextLevel(zoomLevel!, _levels),
        ),
      ));
    }
  }

  //change map type
  Future _onChangeMapTypeEvent(
      ChangeMapTypeEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(
      mapType: event.mapType,
    ));
  }

  //return user current location
  Future _onLocationRequestedEvent(
      LocationRequestedEvent event, Emitter<MapState> emit) async {
    final location = await _mapRespository.determinePosition();
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: location,
        zoom: 10,
      ),
    ));
  }

  //request location permission
  Future _onPermissionRequestEvent(
      PermissionRequestEvent event, Emitter<MapState> emit) async {
    await _mapRespository.requestPermission();
  }

  Future _onSearchQueryChangedEvent(
      SearchQueryChangedEvent event, Emitter<MapState> emit) async {
    final searchResults = await _mapRespository.searchPlace(event.searchQuery);
    emit(state.copyWith(resources: searchResults));
  }

  Future _onAddToRecentSearchesEvent(
      AddToRecentSearchesEvent event, Emitter<MapState> emit) async {
    final recentSearches = [...state.recentSearches];
    if (recentSearches.contains(event.place)) {
      return;
    } else {
      recentSearches.add(event.place);
      emit(state.copyWith(recentSearches: recentSearches));
    }
  }

  Future _onClearSearchQueryEvent(
      ClearSearchQueryEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(searchQuery: ''));
  }

  Future _placeSelectedViaSearchEvent(
      PlaceSelectedViaSearchEvent event, Emitter<MapState> emit) async {
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: event.selectedPlace.point!.coordinates!,
        zoom: 16,
      ),
    ));
  }

  Future _onOnCameraMoveEvent(
      OnCameraMoveEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(cameraPosition: event.cameraPosition));
  }

  //////////Helper functions
  //get next level
  double _getNextLevel(double value, List<double> levels) {
    double result = 0.0;
    final index = levels.indexOf(
        levels.firstWhere((val) => val > value, orElse: () => levels.last));
    if (index == levels.length - 1) {
      result = levels[index];
    } else {
      result = levels[index];
    }
    return result;
  }
}
