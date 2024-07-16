import 'package:budsy/journal/model/feeling.dart';
import 'package:budsy/stash/model/cannabinoid.dart';
import 'package:budsy/journal/model/journal_entry.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:budsy/stash/model/terpene.dart';
import 'package:color_hex/class/hex_to_color.dart';
import 'package:flutter/material.dart';

Color getColorForFeeling(Feeling feeling) {
  if (feeling.color == null) {
    return Colors.grey;
  }
  return hexToColor(feeling.color!);
}

Color getColorForTerpene(Terpene terpene) {
  switch (terpene.name) {
    case 'Myrcene':
      return Colors.red[600]!;
    case 'Limonene':
      return Colors.yellowAccent;
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

Color getColorForCannabinoid(Cannabinoid cannabinoid) {
  switch (cannabinoid.name) {
    case 'THC':
      return Colors.green;
    case 'CBD':
      return Colors.lightBlue;
    case 'CBN':
      return Colors.deepPurple;
    case 'CBG':
      return Colors.red;
    case 'THCV':
      return Colors.deepOrangeAccent;
    case 'CBC':
      return Colors.orange;
    case 'Delta-8-THC':
      return Colors.purple;
    case 'Delta-9-THC':
      return Colors.pink;
    case 'THCA':
      return Colors.teal;
    default:
      return Colors.grey;
  }
}
