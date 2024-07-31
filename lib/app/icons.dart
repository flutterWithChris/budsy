import 'package:canjo/journal/model/feeling.dart';
import 'package:canjo/stash/model/product.dart';
import 'package:canjo/stash/model/terpene.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

Map<ProductCategory, IconData> categoryDuotoneIcons = {
  ProductCategory.flower: PhosphorIcons.plant(PhosphorIconsStyle.duotone),
  ProductCategory.edible: PhosphorIcons.cookie(PhosphorIconsStyle.duotone),
  ProductCategory.concentrate: PhosphorIcons.drop(PhosphorIconsStyle.duotone),
  ProductCategory.cartridge: PhosphorIcons.cloud(PhosphorIconsStyle.duotone),
  ProductCategory.topical: PhosphorIcons.jarLabel(PhosphorIconsStyle.duotone),
};

Map<ProductCategory, IconData> categoryIcons = {
  ProductCategory.flower: PhosphorIcons.plant(),
  ProductCategory.edible: PhosphorIcons.cookie(),
  ProductCategory.concentrate: PhosphorIcons.drop(),
  ProductCategory.cartridge: PhosphorIcons.cloud(),
  ProductCategory.topical: PhosphorIcons.jarLabel(),
};

IconData getIconForCategory(ProductCategory category) {
  return categoryIcons[category]!;
}

IconData getDuotoneIconForCategory(ProductCategory category) {
  return categoryDuotoneIcons[category]!;
}

Map<ProductCategory, IconData> boldCategoryIcons = {
  ProductCategory.flower: PhosphorIcons.plant(PhosphorIconsStyle.bold),
  ProductCategory.edible: PhosphorIcons.cookie(PhosphorIconsStyle.bold),
  ProductCategory.concentrate: PhosphorIcons.drop(PhosphorIconsStyle.bold),
  ProductCategory.cartridge: PhosphorIcons.cloud(PhosphorIconsStyle.bold),
  ProductCategory.topical: PhosphorIcons.jarLabel(PhosphorIconsStyle.bold),
};

IconData getBoldIconForCategory(ProductCategory category) {
  return boldCategoryIcons[category]!;
}

Map<ProductCategory, IconData> filledCategoryIcons = {
  ProductCategory.flower: PhosphorIcons.plant(PhosphorIconsStyle.fill),
  ProductCategory.edible: PhosphorIcons.cookie(PhosphorIconsStyle.fill),
  ProductCategory.concentrate: PhosphorIcons.drop(PhosphorIconsStyle.fill),
  ProductCategory.cartridge: PhosphorIcons.cloud(PhosphorIconsStyle.fill),
  ProductCategory.topical: PhosphorIcons.jarLabel(PhosphorIconsStyle.fill),
};

IconData getFilledIconForCategory(ProductCategory category) {
  return filledCategoryIcons[category]!;
}

// Map<Feeling, IconData> feelingIcons = {
//   Feeling.happy: PhosphorIcons.smiley(),
//   Feeling.creative: PhosphorIcons.paintBrush(),
//   Feeling.sleepy: PhosphorIcons.moon(),
//   Feeling.anxious: PhosphorIcons.smileyNervous(),
//   Feeling.hungry: PhosphorIcons.bowlFood(),
//   Feeling.energetic: PhosphorIcons.lightning(),
//   Feeling.focus: PhosphorIcons.eye(),
//   Feeling.social: PhosphorIcons.users(),
//   Feeling.calm: PhosphorIcons.waveSine(),
// };

IconData getIconForFeeling(Feeling feeling,
    {bool filled = false, bool duoTone = false}) {
  if (feeling.icon == null) {
    return PhosphorIcons.smiley();
  }

  List<String> parts = feeling.icon!.split(':');
  if (parts.length < 2) {
    return PhosphorIcons.questionMark();
  }
  // ignore: unused_local_variable
  String fontFamily = parts[0];
  int codePoint = int.parse(parts[1]);

  if (duoTone) {
    return PhosphorIconData(codePoint, 'Duotone');
  }

  if (filled) {
    return PhosphorIconData(codePoint, 'Fill');
  }

  return PhosphorIconData(codePoint, 'Regular');
}

// Map<Feeling, IconData> feelingDuotoneIcons = {
//   switch (feeling.name) {

//   }
//   Feeling.happy: PhosphorIcons.smiley(PhosphorIconsStyle.duotone),
//   Feeling.creative: PhosphorIcons.paintBrush(PhosphorIconsStyle.duotone),
//   Feeling.sleepy: PhosphorIcons.moon(PhosphorIconsStyle.duotone),
//   Feeling.anxious: PhosphorIcons.smileyNervous(PhosphorIconsStyle.duotone),
//   Feeling.hungry: PhosphorIcons.bowlFood(PhosphorIconsStyle.duotone),
//   Feeling.energetic: PhosphorIcons.lightning(PhosphorIconsStyle.duotone),
//   Feeling.focus: PhosphorIcons.eye(PhosphorIconsStyle.duotone),
//   Feeling.social: PhosphorIcons.users(PhosphorIconsStyle.duotone),
//   Feeling.calm: PhosphorIcons.waveSine(PhosphorIconsStyle.duotone),
// };

IconData getDuotoneIconForFeeling(Feeling feeling) {
  switch (feeling.name) {
    case 'happy':
      return PhosphorIcons.smiley(PhosphorIconsStyle.duotone);
    case 'creative':
      return PhosphorIcons.paintBrush(PhosphorIconsStyle.duotone);
    case 'sleepy':
      return PhosphorIcons.moon(PhosphorIconsStyle.duotone);
    case 'anxious':
      return PhosphorIcons.smileyNervous(PhosphorIconsStyle.duotone);
    case 'hungry':
      return PhosphorIcons.bowlFood(PhosphorIconsStyle.duotone);
    case 'energetic':
      return PhosphorIcons.lightning(PhosphorIconsStyle.duotone);
    case 'focus':
      return PhosphorIcons.eye(PhosphorIconsStyle.duotone);
    case 'social':
      return PhosphorIcons.users(PhosphorIconsStyle.duotone);
    case 'calm':
      return PhosphorIcons.waveSine(PhosphorIconsStyle.duotone);
    default:
      return PhosphorIcons.smiley(PhosphorIconsStyle.duotone);
  }
}

IconData getIconForTerpene(Terpene terpene) {
  switch (terpene.name) {
    case 'Myrcene':
      return PhosphorIcons.firstAid();
    case 'Limonene':
      return PhosphorIcons.orangeSlice();
    case 'Caryophyllene':
      return PhosphorIcons.leaf();
    case 'Pinene':
      return PhosphorIcons.treeEvergreen();
    case 'Linalool':
      return PhosphorIcons.flowerLotus();
    case 'Humulene':
      return PhosphorIcons.leaf();
    case 'Ocimene':
      return PhosphorIcons.leaf();
    case 'Terpinolene':
      return PhosphorIcons.leaf();
    case 'Terpineol':
      return PhosphorIcons.leaf();
    default:
      return PhosphorIcons.leaf();
  }
}

IconData getFilledIconForTerpene(Terpene terpene) {
  switch (terpene.name) {
    case 'Myrcene':
      return PhosphorIcons.firstAid(PhosphorIconsStyle.fill);
    case 'Limonene':
      return PhosphorIcons.orange(PhosphorIconsStyle.fill);
    case 'Caryophyllene':
      return PhosphorIcons.leaf(PhosphorIconsStyle.fill);
    case 'Pinene':
      return PhosphorIcons.treeEvergreen(PhosphorIconsStyle.fill);
    case 'Linalool':
      return PhosphorIcons.flowerLotus(PhosphorIconsStyle.fill);
    case 'Humulene':
      return PhosphorIcons.leaf(PhosphorIconsStyle.fill);
    case 'Ocimene':
      return PhosphorIcons.leaf(PhosphorIconsStyle.fill);
    case 'Terpinolene':
      return PhosphorIcons.leaf(PhosphorIconsStyle.fill);
    case 'Terpineol':
      return PhosphorIcons.leaf(PhosphorIconsStyle.fill);
    default:
      return PhosphorIcons.leaf(PhosphorIconsStyle.fill);
  }
}
