import 'package:budsy/journal/model/feeling.dart';
import 'package:budsy/stash/model/cannabinoid.dart';
import 'package:budsy/journal/model/journal_entry.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:budsy/stash/model/terpene.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

GlobalKey<ScaffoldMessengerState> scaffoldKey =
    GlobalKey<ScaffoldMessengerState>();

List<Terpene> _terpenes = [
  Terpene(
    id: '1',
    name: 'Myrcene',
    icon: 'PhosphorIcons.orangeSlice',
    color: '0xFF45G223',
    amount: 0.0,
  ),
  Terpene(
    id: '2',
    name: 'Limonene',
    icon: 'PhosphorIcons.orangeSlice',
    color: '0xFF45G223',
    amount: 0.0,
  ),
  Terpene(
    id: '3',
    name: 'Pinene',
    icon: 'PhoshorIcons.evergreen',
    color: '0xFF45G223',
    amount: 0.0,
  ),
  Terpene(
    id: '4',
    name: 'Caryophyllene',
    icon: 'PhoshorIcons.evergreen',
    color: '0xFF45G223',
    amount: 0.0,
  ),
];

List<Terpene> get terpenes => _terpenes;

double calculateCircleAvatarRadius(int feelingCount) {
  if (feelingCount == 1) {
    return 20;
  }
  if (feelingCount == 2) {
    return 14;
  } else {
    return 12;
  }
}

double calculateIconRadius(int feelingCount) {
  if (feelingCount == 1) {
    return 24;
  } else if (feelingCount == 2) {
    return 18;
  } else {
    return 16;
  }
}

// Put together the feeling summary string using commas if longer than 2 and an '&' for the last feeling.
String composeFeelingSummaryString(List<Feeling> feelings) {
  String feelingSummaryString = '';
  for (int i = 0; i < feelings.length; i++) {
    if (i == 0) {
      feelingSummaryString += feelings[i].name!.capitalize;
    } else if (i == feelings.length - 1) {
      feelingSummaryString += ' & ${feelings[i].name!.capitalize}';
    } else {
      feelingSummaryString += ', ${feelings[i].name!.capitalize}';
    }
  }
  return feelingSummaryString;
}
