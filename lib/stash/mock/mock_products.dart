// import 'package:budsy/consts.dart';
// import 'package:budsy/stash/model/cannabinoid.dart';
// import 'package:budsy/stash/model/product.dart';
// import 'package:budsy/stash/model/terpene.dart';

// List<Product> mockProducts = [
//   Product(
//     id: '1',
//     name: 'Jah\'spresso',
//     images: null,
//     description:
//         'Blue Dream is a sativa-dominant hybrid marijuana strain made by crossing Blueberry with Haze. Blue Dream produces a balancing high accompanied by full-body relaxation with gentle cerebral invigoration. Novice and veteran consumers alike enjoy the calming and euphoric effects that Blue Dream provides. Consumers also love the flavor - which smells and tastes just like sweet berries. Medical marijuana patients say Blue Dream delivers swift relief from symptoms associated with pain, depression, and nausea. Growers say this strain is best suited to the Sea of Green Method and has an average flowering time of 67 days. Fun fact: Blue Dream originated in California and has achieved legendary status among West Coast strains.',
//     category: ProductCategory.flower,
//     type: FlowerType.hybrid,
//     price: 10.00,
//     weight: 1.0,
//     unit: FlowerUnit.gram,
//     dispensary: 'The Green Door',
//     brand: 'Budsy Farms',
//     cannabinoids: [
//       cannabinoids[0].copyWith(amount: 0.2),
//       cannabinoids[1].copyWith(amount: 0.1),
//     ],
//     terpenes: [
//       terpenes[0].copyWith(amount: 0.1),
//       terpenes[1].copyWith(amount: 0.05),
//       terpenes[2].copyWith(amount: 0.05),
//     ],
//     rating: 3,
//   ),
//   Product(
//       id: '2',
//       name: 'White Durban',
//       images: null,
//       description:
//           'OG Kush was first cultivated in Florida, in the early ‘90s when a strain from Northern California was crossed with a Hindu Kush plant from Amsterdam. The result was a hybrid with a unique terpene profile that boasts a complex aroma with notes of fuel, skunk, and spice. OG Kush is known for its strength, potency, and powerful euphoria. It’s an indica-dominant hybrid that is great for patients who need strong medication. Most patients find that OG Kush is a good strain for pain relief and insomnia. It is also excellent for migraines and stress. OG Kush is also used to treat Alzheimer’s disease. Dry mouth and eyes are the most common negative effects, though headaches and paranoia are also possible.',
//       category: ProductCategory.flower,
//       type: FlowerType.indica,
//       price: 10.00,
//       weight: 1.0,
//       unit: FlowerUnit.gram,
//       dispensary: 'The Green Door',
//       brand: 'Budsy Farms',
//       cannabinoids: [
//         cannabinoids[0].copyWith(amount: 0.17),
//         cannabinoids[1].copyWith(amount: 0.02),
//       ],
//       terpenes: [
//         terpenes[3].copyWith(amount: 0.1),
//         terpenes[1].copyWith(amount: 0.08),
//         terpenes[0].copyWith(amount: 0.05),
//       ],
//       rating: null),
//   Product(
//       id: '3',
//       name: 'Dreamberry Gummies',
//       images: null,
//       description:
//           'Dreamberry Gummies are a delicious way to enjoy the benefits of cannabis without smoking. These gummies are made with a balanced hybrid strain that is perfect for daytime use. Each gummy contains 10mg of THC and 5mg of CBD. Dreamberry Gummies are perfect for those who are new to cannabis edibles. The effects are uplifting and euphoric, making them perfect for social gatherings or creative activities. Dreamberry Gummies are made with natural fruit flavors and colors. They are vegan and gluten-free. Dreamberry Gummies are made with organic ingredients and are free from artificial flavors and colors. They are lab-tested for potency and purity. Dreamberry Gummies are made with love and care in California.',
//       category: ProductCategory.edible,
//       price: 20.00,
//       weight: 1.0,
//       unit: FlowerUnit.gram,
//       dispensary: 'The Green Door',
//       brand: 'Budsy Farms',
//       type: FlowerType.hybrid,
//       cannabinoids: [
//         cannabinoids[0].copyWith(amount: 0.27),
//         cannabinoids[1].copyWith(amount: 0.05),
//       ],
//       terpenes: [
//         terpenes[0].copyWith(amount: 0.18),
//         terpenes[1].copyWith(amount: 0.09),
//         terpenes[2].copyWith(amount: 0.02),
//       ],
//       rating: 4),
//   Product(
//     id: '4',
//     name: 'Blue Dream Cartridge',
//     images: null,
//     description:
//         'Blue Dream is a sativa-dominant hybrid marijuana strain made by crossing Blueberry with Haze. Blue Dream produces a balancing high accompanied by full-body relaxation with gentle cerebral invigoration. Novice and veteran consumers alike enjoy the calming and euphoric effects that Blue Dream provides. Consumers also love the flavor - which smells and tastes just like sweet berries. Medical marijuana patients say Blue Dream delivers swift relief from symptoms associated with pain, depression, and nausea. Growers say this strain is best suited to the Sea of Green Method and has an average flowering time of 67 days. Fun fact: Blue Dream originated in California and has achieved legendary status among West Coast strains.',
//     category: ProductCategory.cartridge,
//     price: 40.00,
//     weight: 1.0,
//     unit: FlowerUnit.gram,
//     dispensary: 'The Green Door',
//     brand: 'Budsy Farms',
//     type: FlowerType.hybrid,
//     cannabinoids: [
//       cannabinoids[0].copyWith(amount: 0.2),
//       cannabinoids[1].copyWith(amount: 0.1),
//     ],
//     terpenes: [
//       terpenes[0].copyWith(amount: 0.1),
//       terpenes[1].copyWith(amount: 0.05),
//       terpenes[2].copyWith(amount: 0.05),
//     ],
//     rating: 2,
//     archived: true,
//   ),
//   Product(
//       id: '5',
//       name: 'Blue Dream Pre-Roll',
//       images: null,
//       description:
//           'Blue Dream is a sativa-dominant hybrid marijuana strain made by crossing Blueberry with Haze. Blue Dream produces a balancing high accompanied by full-body relaxation with gentle cerebral invigoration. Novice and veteran consumers alike enjoy the calming and euphoric effects that Blue Dream provides. Consumers also love the flavor - which smells and tastes just like sweet berries. Medical marijuana patients say Blue Dream delivers swift relief from symptoms associated with pain, depression, and nausea. Growers say this strain is best suited to the Sea of Green Method and has an average flowering time of 67 days. Fun fact: Blue Dream originated in California and has achieved legendary status among West Coast strains.',
//       category: ProductCategory.flower,
//       price: 10.00,
//       weight: 1.0,
//       unit: FlowerUnit.gram,
//       dispensary: 'The Green Door',
//       brand: 'Budsy Farms',
//       type: FlowerType.hybrid,
//       cannabinoids: [
//         cannabinoids[0].copyWith(amount: 0.2),
//         cannabinoids[1].copyWith(amount: 0.1),
//       ],
//       terpenes: [
//         terpenes[0].copyWith(amount: 0.1),
//         terpenes[1].copyWith(amount: 0.05),
//         terpenes[2].copyWith(amount: 0.05),
//       ],
//       rating: 3,
//       archived: true),
//   Product(
//       id: '6',
//       name: 'Durban Zkittlez',
//       images: null,
//       description:
//           'Durban Zkittlez is a sativa-dominant hybrid marijuana strain made by crossing Durban Poison with Zkittlez. Durban Zkittlez produces a balanced high that is both euphoric and relaxing. This strain is known for its sweet and fruity aroma, which is reminiscent of candy. Consumers say Durban Zkittlez is a great strain for managing stress and anxiety. Growers say this strain is best suited for indoor growing and has a flowering time of 56 days. Fun fact: Durban Zkittlez was awarded 1st place in the 2019 Emerald Cup.',
//       category: ProductCategory.flower,
//       type: FlowerType.hybrid,
//       price: 88.00,
//       unit: FlowerUnit.quarter,
//       dispensary: 'Happy Days',
//       brand: 'Rhtythm',
//       cannabinoids: [
//         cannabinoids[0].copyWith(amount: 0.19),
//         cannabinoids[1].copyWith(amount: 0),
//       ],
//       terpenes: [
//         terpenes[0].copyWith(amount: 0.1),
//         terpenes[1].copyWith(amount: 0.05),
//         terpenes[2].copyWith(amount: 0.05),
//       ],
//       rating: 5,
//       archived: true),
// ];
