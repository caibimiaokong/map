import 'package:flutter/material.dart';

//pubdev libraries
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//local libraries
import 'package:wheatmap/feature/map_feature/controller/bloc/map_bloc.dart';
import 'package:wheatmap/feature/map_feature/respository/respository.dart';
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
    final SupabaseClient supabaseClient = Supabase.instance.client;
    return RepositoryProvider(
      create: (context) => MapRespository(supabaseClient: supabaseClient),
      child: BlocProvider(
        create: (context) =>
            MapBloc(RepositoryProvider.of<MapRespository>(context))
              ..add(InitFetchByLocation()),
        child: Builder(builder: (context) {
          return BlocBuilder<MapBloc, MapState>(
            builder: (context, state) {
              switch (state.status) {
                case MapStatus.initial:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case MapStatus.loading:
                  return MapView(mapType: state.mapType);
                case MapStatus.loaded:
                  return MapView(
                    mapType: state.mapType,
                    userLocation: state.cameraPosition,
                  );
                case MapStatus.error:
                  return const Center(child: Text('failed to fetch data'));
              }
            },
          );
        }),
      ),
    );
  }
}
