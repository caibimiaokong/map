part of 'bloc_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();
  @override
  List<Object> get props => [];
}

class FetchByLocation extends MapEvent {}

class FetchByBounds extends MapEvent {}

class ClusterPointTappedEvent extends MapEvent {
  final Cluster<ClusterItem> cluster;
  const ClusterPointTappedEvent({required this.cluster});
}

class ChangeMapTypeEvent extends MapEvent {
  final MapType mapType;
  const ChangeMapTypeEvent(this.mapType);
}

class LocationRequestedEvent extends MapEvent {
  final void Function() onLocationDenied;

  const LocationRequestedEvent({required this.onLocationDenied});
}

class PermissionRequestEvent extends MapEvent {}

class SearchQueryChangedEvent extends MapEvent {
  final String searchQuery;
  const SearchQueryChangedEvent(this.searchQuery);
}

class AddToRecentSearchesEvent extends MapEvent {
  final Resources place;
  const AddToRecentSearchesEvent(this.place);
}

class ClearSearchQueryEvent extends MapEvent {}

class PlaceSelectedViaSearchEvent extends MapEvent {
  final Resources selectedPlace;
  const PlaceSelectedViaSearchEvent(this.selectedPlace);
}

class OnCameraMoveEvent extends MapEvent {
  final CameraPosition cameraPosition;
  const OnCameraMoveEvent(this.cameraPosition);
}
