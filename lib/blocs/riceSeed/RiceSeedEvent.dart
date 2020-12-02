import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RiceSeedEvent extends Equatable {}

class FetchRiceSeedsEvent extends RiceSeedEvent {
  @override
  List<Object> get props => [];
}