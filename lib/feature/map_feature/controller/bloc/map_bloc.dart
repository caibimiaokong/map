import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';

import 'package:wheatmap/feature/map_feature/model/wheat_model.dart';
import 'package:wheatmap/feature/map_feature/model/search_model.dart';
import 'package:wheatmap/feature/map_feature/respository/respository.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final _levels = const [1.0, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5];

  GoogleMapController? mapController;
  final MapRespository mapRespository;
  MapBloc(this.mapRespository) : super(const MapState()) {
    on<InitFetchByLocation>((event, emit) {
      _initFetchByLocation(event, emit);
    });
    on<FetchPointByBounds>((event, emit) {
      _fetchPointByBounds(event, emit);
    });
    on<ChangeMapTypeEvent>((event, emit) {
      _onChangeMapType(event, emit);
    });
    on<LocationRequestedEvent>((event, emit) {
      _onLocationRequested(event, emit);
    });
    on<SearchQueryChangedEvent>((event, emit) {
      _onSearchQueryChanged(event, emit);
    });
    on<PlaceSelectedViaSearchEvent>((event, emit) {
      _placeSelectedViaSearch(event, emit);
    });
  }

  //init mapController
  void initMapController(GoogleMapController controller) {
    mapController = controller;
  }

  //fetch user location
  void _initFetchByLocation(
      InitFetchByLocation event, Emitter<MapState> emit) async {
    emit(state.copyWith(
      status: MapStatus.loading,
    ));
    try {
      final point = await mapRespository.determinePosition();
      List<DisplayPoint> displaypoint =
          await mapRespository.getDisplayPointsByLocation(
              longitude: point.longitude, latitude: point.latitude);
      emit(state.copyWith(
        status: MapStatus.loaded,
        cameraPosition: CameraPosition(
          target: point,
          zoom: _levels[4],
        ),
        displayPoint: displaypoint,
      ));
    } catch (e) {
      debugPrint("an error occur $e");
      // emit(state.copyWith(status: MapStatus.error));
    }
  }

  void _fetchPointByBounds(
      FetchPointByBounds event, Emitter<MapState> emit) async {
    try {
      emit(state.copyWith(
        status: MapStatus.loading,
      ));
      var bounds = await mapController!.getVisibleRegion();
      debugPrint(bounds.toString());
      List<DisplayPoint> dispoint =
          await mapRespository.getDisplayPointsByBounds(bounds: bounds);
      debugPrint(dispoint.toString());
      emit(state.copyWith(
        status: MapStatus.loaded,
        displayPoint: dispoint,
      ));
      // emit(state.copyWith(status: MapStatus.loaded, displayPoint: dispoint));
    } on Exception catch (e) {
      debugPrint("an error occur $e");
      emit(state.copyWith(status: MapStatus.error));
    }
  }

  //change map type
  void _onChangeMapType(
      ChangeMapTypeEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(
      mapType: event.mapType,
    ));
  }

  //get user location
  void _onLocationRequested(
      LocationRequestedEvent event, Emitter<MapState> emit) async {
    try {
      final searchLocation = await mapRespository.determinePosition();
      debugPrint('searchLocation: $searchLocation');
      mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: searchLocation,
          zoom: _levels[4],
        ),
      ));
    } catch (e) {
      emit(state.copyWith(status: MapStatus.error));
    }
  }

  //search query
  void _onSearchQueryChanged(
      SearchQueryChangedEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(
      isSerachFocus: true,
    ));
    if (event.searchQuery.isNotEmpty) {
      try {
        final searchResult =
            await mapRespository.searchPlace(event.searchQuery);
        emit(state.copyWith(
          searchResult: searchResult,
          isSerachFocus: false,
        ));
      } catch (e) {
        // emit(state.copyWith(
        //   searchResult: [],
        // ));
        debugPrint("an error occur $e");
      }
    }
  }

  void _placeSelectedViaSearch(
      PlaceSelectedViaSearchEvent event, Emitter<MapState> emit) async {
    mapController!.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: event.selectedPlace.point!.coordinates!,
        zoom: _levels[4],
      ),
    ));
  }
}
