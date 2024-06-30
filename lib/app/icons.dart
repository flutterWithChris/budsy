import 'package:budsy/entries/model/journal_entry.dart';
import 'package:budsy/entries/model/product.dart';
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

Map<Feeling, IconData> feelingIcons = {
  Feeling.happy: PhosphorIcons.smiley(),
  Feeling.creative: PhosphorIcons.paintBrush(),
  Feeling.relaxed: PhosphorIcons.personArmsSpread(),
  Feeling.sleepy: PhosphorIcons.moon(),
  Feeling.anxious: PhosphorIcons.smileyNervous(),
  Feeling.hungry: PhosphorIcons.bowlFood(),
  Feeling.energetic: PhosphorIcons.lightning(),
  Feeling.focus: PhosphorIcons.eye(),
  Feeling.social: PhosphorIcons.users(),
  Feeling.calm: PhosphorIcons.waveSine(),
};

IconData getIconForFeeling(Feeling feeling) {
  return feelingIcons[feeling]!;
}

Map<Feeling, IconData> feelingDuotoneIcons = {
  Feeling.happy: PhosphorIcons.smiley(PhosphorIconsStyle.duotone),
  Feeling.creative: PhosphorIcons.paintBrush(PhosphorIconsStyle.duotone),
  Feeling.relaxed: PhosphorIcons.personArmsSpread(PhosphorIconsStyle.duotone),
  Feeling.sleepy: PhosphorIcons.moon(PhosphorIconsStyle.duotone),
  Feeling.anxious: PhosphorIcons.smileyNervous(PhosphorIconsStyle.duotone),
  Feeling.hungry: PhosphorIcons.bowlFood(PhosphorIconsStyle.duotone),
  Feeling.energetic: PhosphorIcons.lightning(PhosphorIconsStyle.duotone),
  Feeling.focus: PhosphorIcons.eye(PhosphorIconsStyle.duotone),
  Feeling.social: PhosphorIcons.users(PhosphorIconsStyle.duotone),
  Feeling.calm: PhosphorIcons.waveSine(PhosphorIconsStyle.duotone),
};

IconData getDuotoneIconForFeeling(Feeling feeling) {
  return feelingDuotoneIcons[feeling]!;
}
