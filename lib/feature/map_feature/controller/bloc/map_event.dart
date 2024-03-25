part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();
  @override
  List<Object> get props => [];
}

class InitFetchByLocation extends MapEvent {}

class FetchPointByBounds extends MapEvent {}

class ClusterPointTappedEvent extends MapEvent {
  final Cluster<ClusterItem> cluster;
  const ClusterPointTappedEvent({required this.cluster});
}

class ChangeMapTypeEvent extends MapEvent {
  final MapType mapType;
  const ChangeMapTypeEvent(this.mapType);
}

class LocationRequestedEvent extends MapEvent {}

class PermissionRequestEvent extends MapEvent {}

class RemoveSelectedStationEvent extends MapEvent {}

class SearchQueryChangedEvent extends MapEvent {
  final String searchQuery;
  const SearchQueryChangedEvent(this.searchQuery);
}

class PlaceSelectedViaSearchEvent extends MapEvent {
  final Resources selectedPlace;
  const PlaceSelectedViaSearchEvent(this.selectedPlace);
}

class OnCameraMoveEvent extends MapEvent {
  final CameraPosition cameraPosition;
  const OnCameraMoveEvent(this.cameraPosition);
}
