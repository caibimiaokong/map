//search Bar
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

import 'package:wheatmap/feature/map_feature/controller/bloc/map_bloc.dart';

class MapSearchBar extends StatelessWidget {
  MapSearchBar({
    super.key,
  });
  final FloatingSearchBarController controller = FloatingSearchBarController();

  @override
  Widget build(BuildContext context) {
    final mapBloc = context.watch<MapBloc>();
    return FloatingSearchBar(
      automaticallyImplyBackButton: false,
      controller: controller,
      hint: 'Search...',
      iconColor: Colors.grey,
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOutCubic,
      physics: const BouncingScrollPhysics(),
      axisAlignment: MediaQuery.of(context).orientation == Orientation.portrait
          ? 0.0
          : -1.0,
      openAxisAlignment: 0.0,
      actions: [
        FloatingSearchBarAction(
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {
              controller.clear();
            },
          ),
        ),
        FloatingSearchBarAction.searchToClear(),
      ],
      progress: mapBloc.state.isSerachFocus,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        mapBloc.add(SearchQueryChangedEvent(query));
      },
      //monitor keyboard event,check weather the tapkey is escape key,if yes then clear the search query
      onKeyEvent: (KeyEvent value) {
        if (value.logicalKey == LogicalKeyboardKey.escape) {
          controller.query = '';
          controller.close();
        }
      },
      transition: CircularFloatingSearchBarTransition(spacing: 16),
      scrollPadding: EdgeInsets.zero,
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                mapBloc.state.searchResult.length,
                (index) => ListTile(
                  leading: const Icon(Icons.place),
                  title: Text(
                    '${mapBloc.state.searchResult[index].address!.formattedAddress}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${mapBloc.state.searchResult[index].address!.locality} ${mapBloc.state.searchResult[index].address!.adminDistrict} ${mapBloc.state.searchResult[index].address!.countryRegion}',
                    style: const TextStyle(fontSize: 10),
                  ),
                  onTap: () {
                    context.read<MapBloc>().add(PlaceSelectedViaSearchEvent(
                        mapBloc.state.searchResult[index]));
                    controller.close();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
