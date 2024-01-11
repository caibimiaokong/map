import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    on<FetchPointByLocation>((event, emit) {
      _onFetchByLocation;
    });
    on<ChangeMapTypeEvent>((event, emit) {
      _onChangeMapType(event, emit);
    });
  }

  //init mapController
  void initMapController(GoogleMapController controller) {
    mapController = controller;
  }

  //fetch user location
  Future _onFetchByLocation(
      FetchPointByLocation event, Emitter<MapState> emit) async {
    emit(state.copyWith(
      status: MapStatus.loading,
    ));
    try {
      final searchLocation = await mapRespository.determinePosition();
      emit(state.copyWith(
        status: MapStatus.loaded,
        // displayPoint: points,
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
}
