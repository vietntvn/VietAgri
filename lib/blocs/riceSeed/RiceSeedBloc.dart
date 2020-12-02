import 'package:bloc/bloc.dart';
import 'package:vietagri/models/RiceSeed.dart';
import 'package:vietagri/repositories/RiceSeedRepository.dart';

import 'Bloc.dart';

class RiceSeedBloc extends Bloc<RiceSeedEvent, RiceSeedState> {
  final RiceSeedRepository riceSeedRepository;

  RiceSeedBloc({ this.riceSeedRepository }): super(InitialRiceSeedState());

  @override
  Stream<RiceSeedState> mapEventToState(RiceSeedEvent event) async* {
    if (event is FetchRiceSeedsEvent) {
      yield* mapFetchRiceSeedsEventToState();
    }
  }

  Stream<RiceSeedState> mapFetchRiceSeedsEventToState() async* {
    try {
      yield RiceSeedInProgress();
      List<RiceSeed> riceSeeds = await riceSeedRepository.getRiceSeeds();
      if (riceSeeds == null || riceSeeds.isEmpty) {
        yield NoRiceSeeds();
      } else {
        yield FetchedRiceSeeds(riceSeeds);
      }
    } on Exception catch (exception) {
      yield RiceSeedErrorState(exception);
    }
  }
}