import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ditonton/features/tv_series/domain/entities/season_detail.dart';
import 'package:ditonton/common/state_enum.dart';

import '../../../domain/usecases/get_season_detail.dart';

// Events
abstract class SeasonDetailEvent extends Equatable {
  const SeasonDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchSeasonDetail extends SeasonDetailEvent {
  final int tvId;
  final int seasonNumber;

  const FetchSeasonDetail({
    required this.tvId,
    required this.seasonNumber,
  });

  @override
  List<Object> get props => [tvId, seasonNumber];
}

// States
class SeasonDetailState extends Equatable {
  final RequestState state;
  final Map<int, SeasonDetail> seasonDetails;
  final String message;

  const SeasonDetailState({
    this.state = RequestState.Empty,
    this.seasonDetails = const {},
    this.message = '',
  });

  SeasonDetailState copyWith({
    RequestState? state,
    Map<int, SeasonDetail>? seasonDetails,
    String? message,
  }) {
    return SeasonDetailState(
      state: state ?? this.state,
      seasonDetails: seasonDetails ?? this.seasonDetails,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, seasonDetails, message];
}

// BLoC
class SeasonDetailBloc extends Bloc<SeasonDetailEvent, SeasonDetailState> {
  final GetSeasonDetail getSeasonDetail;

  SeasonDetailBloc({required this.getSeasonDetail})
      : super(const SeasonDetailState()) {
    on<FetchSeasonDetail>(_onFetchSeasonDetail);
  }

  Future<void> _onFetchSeasonDetail(
    FetchSeasonDetail event,
    Emitter<SeasonDetailState> emit,
  ) async {
    // Check if we already have the season details
    if (state.seasonDetails.containsKey(event.seasonNumber)) {
      return;
    }

    emit(state.copyWith(state: RequestState.Loading));

    final result = await getSeasonDetail.execute(
      tvId: event.tvId,
      seasonNumber: event.seasonNumber,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        state: RequestState.Error,
        message: failure.message,
      )),
      (seasonDetail) {
        final updatedSeasons = Map<int, SeasonDetail>.from(state.seasonDetails);
        updatedSeasons[event.seasonNumber] = seasonDetail;
        
        emit(state.copyWith(
          state: RequestState.Loaded,
          seasonDetails: updatedSeasons,
        ));
      },
    );
  }
}
