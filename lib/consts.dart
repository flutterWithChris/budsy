import 'package:budsy/journal/model/feeling.dart';
import 'package:budsy/stash/model/cannabinoid.dart';
import 'package:budsy/journal/model/journal_entry.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:budsy/stash/model/terpene.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

List<Terpene> _terpenes = [
  Terpene(
    id: '1',
    name: 'Myrcene',
    icon: '🍋',
    //color: Colors.red,
    amount: 0.0,
  ),
  Terpene(
    id: '2',
    name: 'Limonene',
    icon: '🍋',
    //   color: Colors.orange,
    amount: 0.0,
  ),
  Terpene(
    id: '3',
    name: 'Pinene',
    icon: '🌲',
    //  color: Colors.green,
    amount: 0.0,
  ),
  Terpene(
    id: '4',
    name: 'Caryophyllene',
    icon: '🍂',
    //  color: Colors.brown,
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
