import 'package:vietagri/models/RiceSeed.dart';
import 'package:vietagri/providers/BaseProviders.dart';
import 'package:vietagri/providers/RiceSeedProvider.dart';

class RiceSeedRepository {
  BaseRiceSeedProvider riceSeedProvider = RiceSeedProvider();
  Future<List<RiceSeed>> getRiceSeeds() => riceSeedProvider.getRiceSeeds();
}