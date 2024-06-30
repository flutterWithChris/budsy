import 'package:budsy/consts.dart';
import 'package:budsy/entries/mock/mock_products.dart';
import 'package:budsy/entries/model/journal_entry.dart';

List<JournalEntry> mockJournalEntries = [
  JournalEntry(
    id: '1',
    createdAt: DateTime.now(),
    product: mockProducts[0],
    feeling: Feeling.happy,
  ),
  JournalEntry(
    id: '2',
    createdAt: DateTime.now(),
    product: mockProducts[1],
    feeling: Feeling.creative,
  ),
  JournalEntry(
    id: '3',
    createdAt: DateTime.now(),
    product: mockProducts[2],
    feeling: Feeling.relaxed,
  ),
  JournalEntry(
    id: '4',
    createdAt: DateTime.now(),
    product: mockProducts[0],
    feeling: Feeling.sleepy,
  ),
  JournalEntry(
    id: '5',
    createdAt: DateTime.now(),
    product: mockProducts[2],
    feeling: Feeling.anxious,
  ),
  JournalEntry(
    id: '6',
    createdAt: DateTime.now(),
    product: mockProducts[1],
    feeling: Feeling.hungry,
  ),
  JournalEntry(
    id: '7',
    createdAt: DateTime.now(),
    product: mockProducts[0],
    feeling: Feeling.energetic,
  ),
  JournalEntry(
    id: '8',
    createdAt: DateTime.now(),
    product: mockProducts[2],
    feeling: Feeling.focus,
  ),
  JournalEntry(
    id: '9',
    createdAt: DateTime.now(),
    product: mockProducts[1],
    feeling: Feeling.social,
  ),
  JournalEntry(
    id: '10',
    createdAt: DateTime.now(),
    product: mockProducts[0],
    feeling: Feeling.calm,
  ),
  JournalEntry(
    id: '11',
    createdAt: DateTime.now(),
    product: mockProducts[0],
    feeling: Feeling.happy,
  ),
  JournalEntry(
    id: '12',
    createdAt: DateTime.now(),
    product: mockProducts[1],
    feeling: Feeling.creative,
  ),
];
