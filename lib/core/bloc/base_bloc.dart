import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  BaseBloc(State initialState) : super(initialState);

  @override
  void onEvent(Event event) {
    super.onEvent(event);
    // Log event if needed
  }

  @override
  void onChange(Change<State> change) {
    super.onChange(change);
    // Log state changes if needed
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // Log error if needed
    super.onError(error, stackTrace);
  }
}

// Base state class for all states
abstract class BaseState extends Equatable {
  final String? message;
  final String? error;

  const BaseState({this.message, this.error});

  bool get hasError => error != null;

  @override
  List<Object?> get props => [message, error];
}

// Base event class for all events
abstract class BaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}
