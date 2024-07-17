part of 'journal_bloc.dart';

sealed class JournalState extends Equatable {
  const JournalState();

  @override
  List<Object> get props => [];
}

final class JournalInitial extends JournalState {}

final class JournalLoading extends JournalState {}

final class JournalLoaded extends JournalState {
  final List<JournalEntry> entries;

  const JournalLoaded(this.entries);

  @override
  List<Object> get props => [entries];
}

final class JournalEntryAdded extends JournalState {
  final JournalEntry entry;

  const JournalEntryAdded(this.entry);

  @override
  List<Object> get props => [entry];
}

final class JournalEntryUpdated extends JournalState {
  final JournalEntry entry;

  const JournalEntryUpdated(this.entry);

  @override
  List<Object> get props => [entry];
}

final class JournalError extends JournalState {
  final String message;

  const JournalError(this.message);

  @override
  List<Object> get props => [message];
}
