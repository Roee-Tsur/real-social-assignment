import 'package:flutter/material.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:real_social_assignment/models/place.dart';
import 'package:real_social_assignment/models/user.dart';
import 'package:real_social_assignment/utils/design.dart';
import 'package:real_social_assignment/widgets/add_fav/add_fav_presenter.dart';
import 'package:real_social_assignment/widgets/add_fav/add_fav_view.dart';
import 'package:real_social_assignment/widgets/rs_text_field.dart';

import '../../utils/config.dart';

class AddFavWidget extends StatelessWidget implements AddFavView {
  AddFavWidget({super.key, required this.user});

  final User user;

  final presenter = AddFavPresenter();
  final placeController = TextEditingController();
  final placeSearch = PlacesSearch(
    apiKey: Config.MAP_BOX_PUBLIC_API_KEY,
  );

  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    presenter.view = this;
    this.context = context;

    return DraggableScrollableSheet(
        initialChildSize: 1,
        builder: ((context, scrollController) =>
            Column(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(
                height: globalPadding,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Autocomplete<MapBoxPlace>(
                    optionsBuilder: ((textEditingValue) async {
                      final places =
                          await placeSearch.getPlaces(textEditingValue.text);
                      return places ?? [];
                    }),
                    onSelected: ((option) => presenter.placeSelected(
                        place: option, userId: user.id)),
                    fieldViewBuilder: ((context, textEditingController,
                        focusNode, onFieldSubmitted) {
                      return RSTextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          label: "Search",
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.4));
                    }),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                        onPressed: (() {}), child: const Text("Add from map")),
                  )
                ],
              ),
              const Divider(
                  color: Colors.black,
                  thickness: 1,
                  endIndent: globalPadding,
                  indent: globalPadding),
              Expanded(
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(user.places[index].name),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: Colors.black,
                        thickness: 1,
                        endIndent: 30,
                        indent: 30,
                      );
                    },
                    itemCount: user.places.length),
              )
            ])));
  }

  @override
  void closeSheet(Place newPlace) {
    Navigator.pop(context, newPlace);
  }
}
