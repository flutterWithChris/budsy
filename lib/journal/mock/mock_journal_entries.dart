import 'package:budsy/consts.dart';
import 'package:budsy/entries/mock/mock_products.dart';
import 'package:budsy/entries/model/journal_entry.dart';

List<JournalEntry> mockJournalEntries = [
  JournalEntry(
    id: '1',
    createdAt: DateTime.now(),
    type: EntryType.feeling,
    product: mockProducts[0],
    feelings: [Feeling.happy],
  ),
  JournalEntry(
    id: '2',
    createdAt: DateTime.now(),
    type: EntryType.feeling,
    product: mockProducts[1],
    feelings: [Feeling.creative, Feeling.social],
  ),
  JournalEntry(
    id: '3',
    createdAt: DateTime.now(),
    type: EntryType.feeling,
    product: mockProducts[2],
    feelings: [Feeling.hungry, Feeling.energetic, Feeling.focus],
  ),
  JournalEntry(
    id: '4',
    createdAt: DateTime.now(),
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
    createdAt: DateTime.now(),
    type: EntryType.feeling,
    product: mockProducts[2],
    feelings: [Feeling.happy, Feeling.calm],
  ),
  JournalEntry(
    id: '6',
    createdAt: DateTime.now(),
    type: EntryType.feeling,
    product: mockProducts[1],
    feelings: [Feeling.creative, Feeling.social],
  ),
  JournalEntry(
    id: '7',
    createdAt: DateTime.now(),
    type: EntryType.feeling,
    product: mockProducts[0],
    feelings: [Feeling.sleepy, Feeling.anxious],
  ),
];
