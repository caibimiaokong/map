import 'package:flutter/material.dart';

//pubdev libraries
import 'package:flutter_bloc/flutter_bloc.dart';

//local libraries
import 'package:wheatmap/feature/map_feature/controller/bloc/bloc_bloc.dart';
import 'package:wheatmap/feature/map_feature/respository/respository.dart';
import 'package:wheatmap/feature/map_feature/widget/google_map.dart';

class MapTab extends StatelessWidget {
  const MapTab({super.key});

  static Widget create() {
    return BlocProvider<MapBloc>(
      create: (context) => MapBloc(
          mapRespository: RepositoryProvider.of<MapRespository>(context))
        ..add(FetchByLocation()),
      child: const MapTab(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        switch (state.status) {
          case MapStatus.initial:
            return const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 111, 223, 115))),
            );
          case MapStatus.loading:
            return const MapView();
          case MapStatus.loaded:
            return MapView(points: state.displayPoints);
          case MapStatus.error:
            return const Center(child: Text('failed to fetch data'));
        }
      },
    );
  }
}
