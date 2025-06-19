// Event classes

import 'package:equatable/equatable.dart';

abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();

  @override
  List<Object> get props => [];
}

class OnMovieQueryChanged extends MovieSearchEvent {
  final String query;

  const OnMovieQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
