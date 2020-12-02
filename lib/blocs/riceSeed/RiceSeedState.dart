import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vietagri/blocs/riceSeed/Bloc.dart';
import 'package:vietagri/models/RiceSeed.dart';

@immutable 
abstract class RiceSeedState extends Equatable {}

class InitialRiceSeedState extends RiceSeedState {
  @override
  List<Object> get props => [];
}

class RiceSeedInProgress extends RiceSeedState {
  @override
  List<Object> get props => [];
}

class FetchedRiceSeeds extends RiceSeedState {
  final List<RiceSeed> riceSeeds;

  FetchedRiceSeeds(this.riceSeeds);

  @override
  List<Object> get props => [riceSeeds];
}

class NoRiceSeeds extends RiceSeedState {
  @override
  List<Object> get props => [];
}

class RiceSeedErrorState extends RiceSeedState {
  final Exception exception;

  RiceSeedErrorState(this.exception);

  @override
  List<Object> get props => [exception];
}