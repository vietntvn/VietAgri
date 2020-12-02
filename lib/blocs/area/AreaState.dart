import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vietagri/models/Area.dart';

@immutable
abstract class AreaState extends Equatable {
  AreaState();
}

class InitialAreaState extends AreaState {
  @override
  List<Object> get props => [];
}

class AreaCreated extends AreaState {
  @override
  List<Object> get props => [];
}

class AreaUpdated extends AreaState {
  @override
  List<Object> get props => [];
}

class AreaInProgress extends AreaState {
  @override
  List<Object> get props => [];
}

class NoAreas extends AreaState {
  @override
  List<Object> get props => [];
}

class FetchedAreas extends AreaState {
  final List<Area> areas;

  FetchedAreas(this.areas);

  @override
  List<Object> get props => [areas];
}

class AreaDeleted extends AreaState {
  @override
  List<Object> get props => [];
}

class AreaFound extends AreaState {
  final List<Area> areas;

  AreaFound(this.areas);

  @override
  List<Object> get props => [areas];
}

class ErrorState extends AreaState {
  final Exception exception;

  ErrorState(this.exception);

  @override
  List<Object> get props => [exception];
}
