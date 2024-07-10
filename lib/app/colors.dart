import 'package:budsy/entries/model/journal_entry.dart';
import 'package:budsy/entries/model/product.dart';
import 'package:budsy/entries/model/terpene.dart';
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
      return Colors.orange;
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

Color getColorForTerpene(Terpene terpene) {
  switch (terpene.name) {
    case 'Myrcene':
      return Colors.red[600]!;
    case 'Limonene':
      return Colors.yellow;
    case 'Caryophyllene':
      return Colors.green[600]!;
    case 'Pinene':
      return Colors.brown;
    case 'Linalool':
      return Colors.deepOrangeAccent;
    case 'Humulene':
      return Colors.amber;
    case 'Ocimene':
      return Colors.purple;
    case 'Terpinolene':
      return Colors.pink;
    case 'Terpineol':
      return Colors.teal;
    default:
      return Colors.grey;
  }
}

Color getColorForProductCategory(ProductCategory category) {
  switch (category) {
    case ProductCategory.flower:
      return const Color.fromARGB(255, 65, 161, 36);
    case ProductCategory.concentrate:
      return Colors.lightBlue;
    case ProductCategory.edible:
      return Colors.blueAccent;
    case ProductCategory.cartridge:
      return Colors.deepOrangeAccent;
    // case ProductCategory.tincture:
    //   return Colors.deepOrangeAccent;
    case ProductCategory.topical:
      return Colors.amber;
    case ProductCategory.other:
      return Colors.purple;
    default:
      return Colors.grey;
  }
}
