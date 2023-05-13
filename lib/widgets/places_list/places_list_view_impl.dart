import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:real_social_assignment/models/place.dart';
import 'package:real_social_assignment/models/user.dart';
import 'package:real_social_assignment/screens/place_selector_screen.dart';
import 'package:real_social_assignment/utils/colors.dart';
import 'package:real_social_assignment/utils/design.dart';
import 'package:real_social_assignment/widgets/places_list/places_list_presenter.dart';
import 'package:real_social_assignment/widgets/places_list/places_list_view.dart';
import 'package:real_social_assignment/widgets/rs_text_field.dart';

import '../../utils/config.dart';

class PlacesListWidget extends StatefulWidget {
  const PlacesListWidget(
      {super.key,
      required this.user,
      required this.currentLocation,
      required this.onPlaceAdded,
      required this.onPlaceRemoved});

  final User user;
  final LocationData currentLocation;
  final void Function(Place) onPlaceAdded, onPlaceRemoved;

  @override
  State<PlacesListWidget> createState() => _PlacesListWidgetState();
}

class _PlacesListWidgetState extends State<PlacesListWidget>
    implements PlacesListView {
  final presenter = PlacesListPresenter();
  final placeController = TextEditingController();
  final placeSearch = PlacesSearch(
    apiKey: Config.MAP_BOX_PUBLIC_API_KEY,
  );

  @override
  void initState() {
    presenter.view = this;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 1,
        builder: ((context, scrollController) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: globalPadding),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(
                  height: globalPadding,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Autocomplete<MapBoxPlace>(
                        optionsBuilder: ((textEditingValue) async {
                          final places = await placeSearch
                              .getPlaces(textEditingValue.text);
                          return places ?? [];
                        }),
                        onSelected: ((option) => presenter.placeSelected(
                            mapBoxPlace: option, userId: widget.user.id)),
                        fieldViewBuilder: ((context, textEditingController,
                            focusNode, onFieldSubmitted) {
                          return RSTextField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              label: "Search",
                              suffixIcon: const Icon(Icons.search, size: 32),
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.4));
                        }),
                      ),
                    ),
                    const SizedBox(
                      width: globalPadding,
                    ),
                    Expanded(
                      child: ButtonContainer(
                        child: ElevatedButton(
                            style: const ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: uiBorderRadius)),
                                backgroundColor:
                                    MaterialStatePropertyAll(mainColor)),
                            onPressed: (() async {
                              Place? place = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlaceSelectorScreen(
                                            currentLocation:
                                                widget.currentLocation,
                                          )));
                              if (place == null) {
                                return;
                              }
                              presenter.placeSelected(
                                  place: place, userId: widget.user.id);
                            }),
                            child: const Text(
                              "Add from map",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )),
                      ),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(
                      color: Colors.black,
                      thickness: 1.4,
                      endIndent: globalPadding,
                      indent: globalPadding),
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final place = widget.user.places[index];
                        return Card(
                          margin: index == widget.user.places.length - 1
                              ? const EdgeInsets.only(bottom: 150)
                              : null,
                          child: ListTile(
                            title: Text(place.name),
                            trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    widget.user.places.remove(place);
                                  });
                                  presenter.deletePlaceClicked(
                                      place: place, userId: widget.user.id);
                                },
                                icon: const Icon(Icons.delete)),
                          ),
                        );
                      },
                      itemCount: widget.user.places.length),
                )
              ]),
            )));
  }

  @override
  void placeAdded(Place place) {
    widget.onPlaceAdded(place);
  }

  @override
  void placeRemoved(Place place) {
    widget.onPlaceRemoved(place);
  }
}
