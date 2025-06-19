import 'package:equatable/equatable.dart';

enum RequestState { empty, loading, loaded, error }

class RequestStatus extends Equatable {
  final RequestState state;
  final String? message;

  const RequestStatus({
    this.state = RequestState.empty,
    this.message,
  });

  bool get isLoading => state == RequestState.loading;
  bool get isLoaded => state == RequestState.loaded;
  bool get hasError => state == RequestState.error;
  bool get isEmpty => state == RequestState.empty;

  RequestStatus copyWith({
    RequestState? state,
    String? message,
  }) {
    return RequestStatus(
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, message];
}
