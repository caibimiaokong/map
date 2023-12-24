//flutter lbraries
import 'package:flutter/material.dart';

//pubdev libraries
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wheatmap/feature/map_feature/controller/place_serch_provider/place_serch_provider.dart';

//local libraries

class LocationSearchBox extends StatelessWidget {
  const LocationSearchBox({super.key, required this.mapController});

  final GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Container(
      margin: const EdgeInsets.only(top: 150),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: SizedBox(
          width: 350,
          child: TypeAheadField(
            controller: searchController,
            //TextField
            builder: (context, controller, focusNode) {
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                textInputAction: TextInputAction.search,
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration(
                    hintText: 'Search for a location',
                    prefixIcon: Icon(Icons.location_on),
                    suffixIcon: Icon(Icons.search),
                    border: InputBorder.none),
              );
            },
            //suggestions
            suggestionsCallback: (pattern) async {
              return context
                  .watch<PlaceSearchProvider>()
                  .searchLocation(context, searchController.text.toString());
            },
            //itemBuilder
            itemBuilder: (context, suggestion) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Row(children: [
                  const Icon(Icons.location_on),
                  Expanded(
                    child: Text(suggestion.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: 20,
                            )),
                  ),
                ]),
              );
            },
            //onSlected
            onSelected: (suggestion) {
              return;
            },
          ),
        ),
      ),
    );
  }
}
