import 'package:bloc/bloc.dart';
import 'package:canjo/journal/model/feeling.dart';
import 'package:canjo/journal/repository/feelings_repository.dart';
import 'package:equatable/equatable.dart';

part 'feelings_state.dart';

class FeelingsCubit extends Cubit<FeelingsState> {
  final FeelingsRepository _feelingsRepository;
  FeelingsCubit({required FeelingsRepository feelingsRepository})
      : _feelingsRepository = feelingsRepository,
        super(FeelingsInitial());
  Future<List<Feeling>> getFeelings() => _onGetFeelings();

  Future<List<Feeling>> _onGetFeelings() async {
    emit(FeelingsLoading());
    try {
      final feelings = await _feelingsRepository.getFeelings();
      emit(FeelingsLoaded(feelings));
      return feelings;
    } catch (e) {
      emit(const FeelingsError('Failed to load feelings'));
      return [];
    }
  }
}
