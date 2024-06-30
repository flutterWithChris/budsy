import 'package:budsy/entries/model/journal_entry.dart';
import 'package:flutter/material.dart';

Color getColorForFeeling(Feeling feeling) {
  switch (feeling) {
    case Feeling.happy:
      return Colors.green;
    case Feeling.creative:
      return Colors.blue;
    case Feeling.relaxed:
      return Colors.deepPurpleAccent;
    case Feeling.sleepy:
      return Colors.yellow;
    case Feeling.anxious:
      return Colors.red;
    case Feeling.hungry:
      return Colors.orange;
    case Feeling.energetic:
      return Colors.lightBlue;
    case Feeling.focus:
      return Colors.purple;
    case Feeling.social:
      return Colors.pink;
    case Feeling.calm:
      return Colors.teal;
    default:
      return Colors.grey;
  }
}
