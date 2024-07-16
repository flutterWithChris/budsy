part of 'journal_bloc.dart';

sealed class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object> get props => [];
}

final class LoadJournal extends JournalEvent {}
