import 'dart:math';

import 'package:budsy/consts.dart';
import 'package:budsy/journal/mock/mock_feelings.dart';
import 'package:budsy/stash/mock/mock_products.dart';
import 'package:budsy/journal/model/journal_entry.dart';

List<JournalEntry> mockJournalEntries = [
  JournalEntry(
    id: '1',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.feeling,
    products: [mockProducts[0]],
    feelings: [mockFeelings[0], mockFeelings[1]],
  ),
  JournalEntry(
    id: '2',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.feeling,
    products: [mockProducts[1], mockProducts[2]],
    feelings: [mockFeelings[2], mockFeelings[3], mockFeelings[0]],
  ),
  JournalEntry(
    id: '3',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.feeling,
    products: [mockProducts[2], mockProducts[3], mockProducts[0]],
    feelings: [mockFeelings[1], mockFeelings[0]],
  ),
];

DateTime generateRandomDateWithinWeek() {
  final random = Random();
  final now = DateTime.now();
  final randomDays = random.nextInt(7);
  return now.subtract(Duration(days: randomDays));
}
