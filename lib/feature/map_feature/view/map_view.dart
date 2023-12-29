import 'package:flutter/material.dart';

//pubdev libraries
import 'package:flutter_bloc/flutter_bloc.dart';

//local libraries
import 'package:wheatmap/feature/map_feature/controller/bloc/bloc_bloc.dart';
import 'package:wheatmap/feature/map_feature/widget/google_map.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
        create: (context) => MapBloc()..add(FetchByLocation()),
        child: Builder(builder: (context) {
          return BlocBuilder<MapBloc, MapState>(
            builder: (context, state) {
              switch (state.status) {
                case MapStatus.initial:
                  return const Center(child: Text('initial'));
                case MapStatus.loading:
                  return const Center(child: CircularProgressIndicator());
                case MapStatus.loaded:
                  return MapView(points: state.displayPoints);
                case MapStatus.error:
                  return const Center(child: Text('failed to fetch data'));
              }
            },
          );
        }));
  }
}
