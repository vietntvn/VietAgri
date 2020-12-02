import 'package:bloc/bloc.dart';
import 'package:vietagri/blocs/area/Bloc.dart';
import 'package:vietagri/models/Area.dart';
import 'package:vietagri/repositories/AreaRepository.dart';

class AreaBloc extends Bloc<AreaEvent, AreaState> {
  final AreaRepository areaRepository;

  AreaBloc({this.areaRepository}) : super(InitialAreaState());

  @override
  Stream<AreaState> mapEventToState(AreaEvent event) async* {
    if (event is CreateAreaEvent) {
      yield* mapCreateAreaEventToState(event);
    }
    if (event is UpdateAreaEvent) {
      yield* mapUpdateAreaEventToState(event);
    }
    if (event is FetchAreasEvent) {
      yield* mapFetchAreasEventToState(event);
    }
    if (event is DeleteAreaEvent) {
      yield* mapDeleteAreaEventToState(event);
    }
    if (event is SearchAreaEvent) {
      yield* mapSearchAreaEventToState(event);
    }
  }

  Stream<AreaState> mapCreateAreaEventToState(CreateAreaEvent event) async* {
    try {
      yield AreaInProgress();
      await areaRepository.createArea(
        event.name,
        event.area,
        event.areaUnit,
        event.location,
        event.riceSeedKind,
        event.soil,
        event.weather,
        event.province
      );
      yield AreaCreated();
    } on Exception catch (exception) {
      yield ErrorState(exception);
    }
  }

  Stream<AreaState> mapUpdateAreaEventToState(UpdateAreaEvent event) async* {
    try {
      yield AreaInProgress();
      await areaRepository.updateArea(
        event.id,
        event.name,
        event.area,
        event.areaUnit,
        event.location,
        event.riceSeedKind,
        event.soil,
        event.weather,
        event.province,
      );
      yield AreaUpdated();
    } on Exception catch (exception) {
      yield ErrorState(exception);
    }
  }

  Stream<AreaState> mapFetchAreasEventToState(FetchAreasEvent event) async* {
    try {
      yield AreaInProgress();
      List<Area> areas = await areaRepository.getAreas(event.riceSeeds);
      if (areas == null || areas.isEmpty) {
        yield NoAreas();
      } else {
        yield FetchedAreas(areas);
      }
    } on Exception catch (exception) {
      yield ErrorState(exception);
    }
  }

  Stream<AreaState> mapDeleteAreaEventToState(DeleteAreaEvent event) async* {
    try {
      await areaRepository.deleteArea(event.id);
      yield AreaDeleted();
    } on Exception catch (exception) {
      yield ErrorState(exception);
    }
  }

  Stream<AreaState> mapSearchAreaEventToState(SearchAreaEvent event) async* {
    try {
      yield AreaInProgress();
      List<Area> areas = await areaRepository.searchArea(event.name, event.riceSeeds);
      if (areas.isNotEmpty) {
        yield AreaFound(areas);
      } else {
        yield NoAreas();
      }
    } on Exception catch (exception) {
      yield ErrorState(exception);
    }
  }
}
