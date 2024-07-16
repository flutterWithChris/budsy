import 'package:bloc/bloc.dart';
import 'package:budsy/journal/model/feeling.dart';
import 'package:budsy/journal/model/journal_entry.dart';
import 'package:budsy/journal/repository/journal_repository.dart';
import 'package:equatable/equatable.dart';

part 'journal_event.dart';
part 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final JournalRepository _journalRepository;

  JournalBloc({required JournalRepository journalRepository})
      : _journalRepository = journalRepository,
        super(JournalLoading()) {
    on<LoadJournal>(_onLoadJournal);
  }

  void _onLoadJournal(LoadJournal event, Emitter<JournalState> emit) async {
    emit(JournalLoading());
    try {
      print('Loading journal entries');
      List<JournalEntry>? entries = await _journalRepository.getEntries();
      print(entries);
      if (entries == null) {
        emit(const JournalError('Failed to load journal entries'));
        return;
      }
      emit(JournalLoaded(entries));
    } catch (e) {
      print(e);
      emit(const JournalError('Failed to load journal entries'));
    }
  }
}
