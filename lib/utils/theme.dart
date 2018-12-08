import 'package:flutter/material.dart';

import 'package:atmonitor/utils/colors.dart';

ThemeData buildAtmTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: aOrange500,
    primaryColor: aBlue700,
    buttonColor: aOrange500,
    scaffoldBackgroundColor: aBackGroundWhite,
    cardColor: aWhite,
    textSelectionColor: aBlue700,
    errorColor: kShrineErrorRed,
    textTheme: _buildAtmTextTheme(base.textTheme),
    primaryTextTheme: _buildAtmTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildAtmTextTheme(base.accentTextTheme),
  );
}


TextTheme _buildAtmTextTheme(TextTheme base) {
  return base
      .copyWith(
          headline: base.headline.copyWith(
            fontWeight: FontWeight.w500,
          ),
          title: base.title.copyWith(
            fontSize: 18.0,
          ),
          caption: base.caption.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
          ),
          subhead: base.caption.copyWith(color: aBlue800))
      .apply(
        fontFamily: 'WorkSans',
      );
}
