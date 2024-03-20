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
    on<InitFetchByLocation>((event, emit) async {
      await _initFetchByLocation(event, emit);
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
  }

  //init mapController
  void initMapController(GoogleMapController controller) {
    mapController = controller;
  }

  //fetch user location
  Future<void> _initFetchByLocation(
      InitFetchByLocation event, Emitter<MapState> emit) async {
    emit(state.copyWith(
      status: MapStatus.loading,
    ));
    try {
      final searchLocation = await mapRespository.determinePosition();
      debugPrint('searchLocation: $searchLocation');
      emit(state.copyWith(
        status: MapStatus.loaded,
        cameraPosition: CameraPosition(
          target: searchLocation,
          zoom: _levels[4],
        ),
      ));
    } catch (e) {
      emit(state.copyWith(status: MapStatus.error));
    }
  }

  //change map type
  Future _onChangeMapType(
      ChangeMapTypeEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(
      mapType: event.mapType,
    ));
  }

  //get user location
  Future _onLocationRequested(
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
  Future _onSearchQueryChanged(
      SearchQueryChangedEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(
      searchQuery: event.searchQuery,
      isSerachFocus: true,
    ));
    if (event.searchQuery.isNotEmpty) {
      final searchResult = await mapRespository.searchPlace(event.searchQuery);
      emit(state.copyWith(
        recentSearches: searchResult,
      ));
    }
  }
}
