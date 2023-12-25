import 'package:flutter/material.dart';

//pubdev libraries
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheatmap/feature/map_feature/controller/bloc/bloc_bloc.dart';
import 'package:wheatmap/feature/map_feature/widget/google_map.dart';

//local libraries

class MapTable extends StatelessWidget {
  const MapTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //map or other state widget
        BlocBuilder<MapBloc, MapState>(
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
        ),
        // //search bar
        // Positioned(top: 70, child: MapSearchBar()),
      ],
    );
  }
}
