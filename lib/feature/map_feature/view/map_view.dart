import 'package:flutter/material.dart';

//pubdev libraries
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//local libraries
import 'package:wheatmap/feature/map_feature/controller/bloc/map_bloc.dart';
import 'package:wheatmap/feature/map_feature/respository/respository.dart';
import 'package:wheatmap/feature/map_feature/widget/google_map.dart';
import 'package:wheatmap/feature/map_feature/widget/map_controller_icon.dart';
import 'package:wheatmap/feature/map_feature/widget/map_type_bottom_sheet.dart';
// import 'package:wheatmap/feature/map_feature/widget/map_search_bar.dart';

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
              ..add(FetchPointByLocation()),
        child: Builder(builder: (context) {
          final MapBloc mapBloc = context.read<MapBloc>();

          void showBottomSheet(BuildContext context) {
            showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              context: context,
              builder: (_) => MapBottomSheet(
                onStationTypeSelected: (type) {
                  context.read<MapBloc>().add(ChangeMapTypeEvent(type));
                },
                currentMapType: context.read<MapBloc>().state.mapType,
              ),
            );
          }

          return Stack(children: [
            BlocBuilder<MapBloc, MapState>(
              builder: (context, state) {
                switch (state.status) {
                  case MapStatus.initial:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case MapStatus.loading:
                    return const MapView();
                  case MapStatus.loaded:
                    return MapView(points: state.displayPoint);
                  case MapStatus.error:
                    return const Center(child: Text('failed to fetch data'));
                }
              },
            ),
            //layer button
            Positioned(
                top: 150,
                right: 20,
                child: InkWell(
                  onTap: () {
                    showBottomSheet(context);
                  },
                  child: const MapControllerButton(
                    svgPath:
                        '<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 512 512"><path fill="#0284c7" d="M256 256c-13.47 0-26.94-2.39-37.44-7.17l-148-67.49C63.79 178.26 48 169.25 48 152.24s15.79-26 22.58-29.12l149.28-68.07c20.57-9.4 51.61-9.4 72.19 0l149.37 68.07c6.79 3.09 22.58 12.1 22.58 29.12s-15.79 26-22.58 29.11l-148 67.48C282.94 253.61 269.47 256 256 256Zm176.76-100.86Z"/><path fill="#0284c7" d="M441.36 226.81L426.27 220l-38.77 17.74l-94 43c-10.5 4.8-24 7.19-37.44 7.19s-26.93-2.39-37.42-7.19l-94.07-43L85.79 220l-15.22 6.84C63.79 229.93 48 239 48 256s15.79 26.08 22.56 29.17l148 67.63C229 357.6 242.49 360 256 360s26.94-2.4 37.44-7.19l147.87-67.61c6.81-3.09 22.69-12.11 22.69-29.2s-15.77-26.07-22.64-29.19Z"/><path fill="#0284c7" d="m441.36 330.8l-15.09-6.8l-38.77 17.73l-94 42.95c-10.5 4.78-24 7.18-37.44 7.18s-26.93-2.39-37.42-7.18l-94.07-43L85.79 324l-15.22 6.84C63.79 333.93 48 343 48 360s15.79 26.07 22.56 29.15l148 67.59C229 461.52 242.54 464 256 464s26.88-2.48 37.38-7.27l147.92-67.57c6.82-3.08 22.7-12.1 22.7-29.16s-15.77-26.07-22.64-29.2Z"/></svg>',
                  ),
                )),

            //current location button
            Positioned(
                top: 230,
                right: 20,
                child: InkWell(
                    onTap: () {
                      mapBloc
                          .add(LocationRequestedEvent(onLocationDenied: () {}));
                    },
                    child: const MapControllerButton(
                        svgPath:
                            '<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 24 24"><path fill="#0284c7" d="M11 22.95v-2q-3.125-.35-5.363-2.587T3.05 13h-2v-2h2q.35-3.125 2.588-5.363T11 3.05v-2h2v2q3.125.35 5.363 2.588T20.95 11h2v2h-2q-.35 3.125-2.587 5.363T13 20.95v2zM12 19q2.9 0 4.95-2.05T19 12q0-2.9-2.05-4.95T12 5Q9.1 5 7.05 7.05T5 12q0 2.9 2.05 4.95T12 19m0-3q-1.65 0-2.825-1.175T8 12q0-1.65 1.175-2.825T12 8q1.65 0 2.825 1.175T16 12q0 1.65-1.175 2.825T12 16"/></svg>'))),

            //if user is a farmer, show the add button
            const Positioned(
                bottom: 130,
                right: 20,
                child: MapControllerButton(
                  svgPath:
                      '<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 24 24"><path fill="#0284c7" d="M12 6.25a.75.75 0 0 1 .75.75v2h2a.75.75 0 0 1 0 1.5h-2v2a.75.75 0 1 1-1.5 0v-2h-2a.75.75 0 0 1 0-1.5h2V7a.75.75 0 0 1 .75-.75Z"/><path fill="#0284c7" fill-rule="evenodd" d="M11.784 1.25a8.288 8.288 0 0 0-8.26 7.607a8.943 8.943 0 0 0 1.99 6.396l4.793 5.861a2.187 2.187 0 0 0 3.386 0l4.793-5.861a8.944 8.944 0 0 0 1.99-6.396a8.288 8.288 0 0 0-8.26-7.607h-.432ZM5.02 8.98a6.788 6.788 0 0 1 6.765-6.23h.432a6.788 6.788 0 0 1 6.765 6.23a7.443 7.443 0 0 1-1.656 5.323l-4.793 5.862a.687.687 0 0 1-1.064 0l-4.793-5.862A7.443 7.443 0 0 1 5.02 8.98Z" clip-rule="evenodd"/></svg>',
                )),

            //if user is a harvester/rescue, show the navigator button
            const Positioned(
                bottom: 50,
                right: 20,
                child: MapControllerButton(
                    svgPath:
                        '<svg xmlns="http://www.w3.org/2000/svg" width="90" height="90" viewBox="0 0 256 256"><path fill="#0284c7" d="M240 113.58a15.76 15.76 0 0 1-11.29 15l-76.56 23.56l-23.56 76.56a15.77 15.77 0 0 1-15 11.29h-.3a15.77 15.77 0 0 1-15.07-10.67L33 53.41a1 1 0 0 1-.05-.16a16 16 0 0 1 20.3-20.35l.16.05l175.92 65.26A15.78 15.78 0 0 1 240 113.58Z"/></svg>')),
            // MapSearchBar(),
            Center(
              child: Column(
                children: [
                  Text(mapBloc.state.mapType.toString()),
                  ElevatedButton(
                      onPressed: () {
                        mapBloc.add(FetchPointByLocation());
                      },
                      child: const Text('change state'))
                ],
              ),
            )
          ]);
        }),
      ),
    );
  }
}
