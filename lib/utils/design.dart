import 'package:flutter/material.dart';

import 'colors.dart';

const globalPadding = 16.0;
const buttonHeight = 46.0;

const appBarShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)));

const bottomSheetShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(16)));

const uiBorderRadius = BorderRadius.all(Radius.circular(12));

Widget AuthCard({required List<Widget> children}) {
  return Card(
    elevation: 6,
    margin: const EdgeInsets.all(12),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
    child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: mainColor,
                )),
            //empty container to make space between google button and weird circle
            Container(),
            ...children,
          ],
        )),
  );
}

Widget ButtonContainer({required Widget child}) {
  return SizedBox(
    height: buttonHeight,
    width: double.infinity,
    child: child,
  );
}
