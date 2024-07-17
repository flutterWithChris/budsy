part of 'journal_bloc.dart';

sealed class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object> get props => [];
}

final class LoadJournal extends JournalEvent {}

final class AddJournalEntry extends JournalEvent {
  final JournalEntry entry;

  const AddJournalEntry(this.entry);

  @override
  List<Object> get props => [entry];
}

final class UpdateJournalEntry extends JournalEvent {
  final JournalEntry entry;

  const UpdateJournalEntry(this.entry);

  @override
  List<Object> get props => [entry];
}

final class DeleteJournalEntry extends JournalEvent {
  final String entryId;

  const DeleteJournalEntry(this.entryId);

  @override
  List<Object> get props => [entryId];
}
