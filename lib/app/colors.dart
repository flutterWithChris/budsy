import 'package:budsy/entries/model/journal_entry.dart';
import 'package:flutter/material.dart';

Color getColorForFeeling(Feeling feeling) {
  switch (feeling) {
    case Feeling.happy:
      return Colors.green;
    case Feeling.creative:
      return Colors.lightBlue;
    case Feeling.sleepy:
      return Colors.deepPurple;
    case Feeling.anxious:
      return Colors.red;
    case Feeling.hungry:
      return Colors.deepOrangeAccent;
    case Feeling.energetic:
      return Colors.amber;
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
