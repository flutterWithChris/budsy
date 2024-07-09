import 'dart:math';

import 'package:budsy/consts.dart';
import 'package:budsy/entries/mock/mock_products.dart';
import 'package:budsy/entries/model/journal_entry.dart';

List<JournalEntry> mockJournalEntries = [
  JournalEntry(
    id: '1',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.feeling,
    product: mockProducts[0],
    feelings: [Feeling.happy],
  ),
  JournalEntry(
    id: '2',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.feeling,
    product: mockProducts[1],
    feelings: [Feeling.creative, Feeling.social],
  ),
  JournalEntry(
    id: '3',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.feeling,
    product: mockProducts[2],
    feelings: [Feeling.hungry, Feeling.energetic, Feeling.focus],
  ),
  JournalEntry(
    id: '4',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.feeling,
    product: mockProducts[0],
    feelings: [
      Feeling.sleepy,
      Feeling.anxious,
      Feeling.creative,
      Feeling.happy
    ],
  ),
  JournalEntry(
    id: '5',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.feeling,
    product: mockProducts[2],
    feelings: [Feeling.happy, Feeling.calm],
  ),
  JournalEntry(
    id: '6',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.feeling,
    product: mockProducts[1],
    feelings: [Feeling.creative, Feeling.social],
  ),
  JournalEntry(
    id: '7',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.feeling,
    product: mockProducts[2],
    feelings: [Feeling.sleepy, Feeling.anxious],
  ),
  JournalEntry(
    id: '8',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.session,
    product: mockProducts[2],
  ),
  JournalEntry(
    id: '9',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.session,
    product: mockProducts[1],
  ),
  JournalEntry(
    id: '10',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.session,
    product: mockProducts[2],
  ),
  JournalEntry(
    id: '11',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.session,
    product: mockProducts[3],
  ),
  JournalEntry(
    id: '12',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.session,
    product: mockProducts[1],
  ),
  JournalEntry(
    id: '13',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.session,
    product: mockProducts[2],
  ),
  JournalEntry(
    id: '14',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.session,
    product: mockProducts[0],
  ),
  JournalEntry(
    id: '15',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.session,
    product: mockProducts[3],
  ),
  JournalEntry(
    id: '16',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.session,
    product: mockProducts[2],
  ),
  JournalEntry(
    id: '17',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.session,
    product: mockProducts[3],
  ),
  JournalEntry(
    id: '18',
    createdAt: generateRandomDateWithinWeek(),
    type: EntryType.session,
    product: mockProducts[1],
  ),
];

DateTime generateRandomDateWithinWeek() {
  final random = Random();
  final now = DateTime.now();
  final randomDays = random.nextInt(7);
  return now.subtract(Duration(days: randomDays));
}
