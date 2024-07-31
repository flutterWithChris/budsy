import 'package:bloc/bloc.dart';
import 'package:canjo/journal/model/journal_entry.dart';
import 'package:canjo/journal/repository/journal_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'journal_event.dart';
part 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final JournalRepository _journalRepository;

  JournalBloc({required JournalRepository journalRepository})
      : _journalRepository = journalRepository,
        super(JournalLoading()) {
    on<LoadJournal>(_onLoadJournal);
    on<AddJournalEntry>(_onAddJournalEntry);
    on<UpdateJournalEntry>(_onUpdateJournalEntry);
    on<DeleteJournalEntry>(_onDeleteJournalEntry);
  }

  void _onLoadJournal(LoadJournal event, Emitter<JournalState> emit) async {
    emit(JournalLoading());
    try {
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

  void _onAddJournalEntry(
      AddJournalEntry event, Emitter<JournalState> emit) async {
    emit(JournalLoading());
    try {
      JournalEntry? entry = await _journalRepository.addEntry(event.entry);

      if (entry == null) {
        emit(const JournalError('Failed to add journal entry'));
        return;
      }

      List<Future<void>> addFutures = [];

      if (event.entry.products != null && event.entry.products!.isNotEmpty) {
        for (var product in event.entry.products!) {
          addFutures.add(_journalRepository.addProductToEntry(
            entry.id!,
            product.id!,
            Supabase.instance.client.auth.currentUser!.id,
          ));
        }
      }

      if (event.entry.feelings != null && event.entry.feelings!.isNotEmpty) {
        for (var feeling in event.entry.feelings!) {
          addFutures.add(_journalRepository.addFeelingToEntry(
            entry.id!,
            feeling.id!,
            Supabase.instance.client.auth.currentUser!.id,
          ));
        }
      }

      // Wait for all add futures to complete
      await Future.wait(addFutures);

      emit(JournalEntryAdded(entry));
      add(LoadJournal());
    } catch (e) {
      print(e);
      emit(const JournalError('Failed to add journal entry'));
    }
  }

  void _onUpdateJournalEntry(
      UpdateJournalEntry event, Emitter<JournalState> emit) async {
    emit(JournalLoading());
    try {
      JournalEntry? entry = await _journalRepository.updateEntry(event.entry);
      if (entry == null) {
        emit(const JournalError('Failed to update journal entry'));
        return;
      }

      List<Future<void>> updateFutures = [];

      // Remove all products and feelings from the entry
      await _journalRepository.removeProductsFromEntry(
          entry.id!, Supabase.instance.client.auth.currentUser!.id);
      await _journalRepository.removeFeelingsFromEntry(
          entry.id!, Supabase.instance.client.auth.currentUser!.id);

      if (event.entry.products != null && event.entry.products!.isNotEmpty) {
        for (var product in event.entry.products!) {
          updateFutures.add(_journalRepository.addProductToEntry(
            entry.id!,
            product.id!,
            Supabase.instance.client.auth.currentUser!.id,
          ));
        }
      }

      if (event.entry.feelings != null && event.entry.feelings!.isNotEmpty) {
        for (var feeling in event.entry.feelings!) {
          updateFutures.add(_journalRepository.addFeelingToEntry(
            entry.id!,
            feeling.id!,
            Supabase.instance.client.auth.currentUser!.id,
          ));
        }
      }

      // Wait for all update futures to complete
      await Future.wait(updateFutures);

      emit(JournalEntryUpdated(entry));

      add(LoadJournal());
    } catch (e) {
      print(e);
      emit(const JournalError('Failed to update journal entry'));
    }
  }

  void _onDeleteJournalEntry(
      DeleteJournalEntry event, Emitter<JournalState> emit) async {
    emit(JournalLoading());
    try {
      await _journalRepository.deleteEntry(event.entryId);
      emit(JournalEntryDeleted());
      add(LoadJournal());
    } catch (e) {
      print(e);
      emit(const JournalError('Failed to delete journal entry'));
    }
  }
}
