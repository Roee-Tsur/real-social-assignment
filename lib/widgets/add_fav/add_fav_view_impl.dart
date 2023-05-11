import 'package:flutter/material.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:real_social_assignment/widgets/add_fav/add_fav_presenter.dart';
import 'package:real_social_assignment/widgets/add_fav/add_fav_view.dart';

import '../../utils/config.dart';

class AddFavWidget extends StatelessWidget implements AddFavView {
  AddFavWidget({super.key, required this.userId});

  final String userId;

  final presenter = AddFavPresenter();
  final placeController = TextEditingController();
  final placeSearch = PlacesSearch(
    apiKey: Config.MAP_BOX_PUBLIC_API_KEY,
  );

  @override
  Widget build(BuildContext context) {
    presenter.view = this;

    return Scaffold(
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Autocomplete<MapBoxPlace>(
              optionsBuilder: ((textEditingValue) async {
                final places =
                    await placeSearch.getPlaces(textEditingValue.text);
                return places ?? [];
              }),
              onSelected: ((option) =>
                  presenter.placeSelected(place: option, userId: userId)),
              fieldViewBuilder: ((context, textEditingController, focusNode,
                  onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.4)),
                );
              }),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: ElevatedButton(
                  onPressed: (() {}), child: const Text("Add from map")),
            )
          ],
        )
      ]),
    );
  }
}
