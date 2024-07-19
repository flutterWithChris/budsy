part of 'journal_bloc.dart';

sealed class JournalState extends Equatable {
  final List<JournalEntry>? entries;
  final JournalEntry? entry;
  const JournalState({
    this.entries,
    this.entry,
  });

  @override
  List<Object?> get props => [
        entries,
        entry,
      ];
}

final class JournalInitial extends JournalState {}

final class JournalLoading extends JournalState {}

final class JournalLoaded extends JournalState {
  @override
  final List<JournalEntry> entries;

  const JournalLoaded(this.entries);

  @override
  List<Object> get props => [entries];
}

final class JournalEntryAdded extends JournalState {
  @override
  final JournalEntry entry;

  const JournalEntryAdded(this.entry);

  @override
  List<Object> get props => [entry];
}

final class JournalEntryUpdated extends JournalState {
  @override
  final JournalEntry entry;

  const JournalEntryUpdated(this.entry);

  @override
  List<Object> get props => [entry];
}

final class JournalEntryDeleted extends JournalState {}

final class JournalError extends JournalState {
  final String message;

  const JournalError(this.message);

  @override
  List<Object> get props => [message];
}
