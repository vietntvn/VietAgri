import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:vietagri/blocs/riceSeed/Bloc.dart';
import 'package:vietagri/blocs/user/Bloc.dart';
import 'package:vietagri/config/API_KEY.dart';
import 'package:vietagri/config/Constants.dart';
import 'package:vietagri/models/User.dart';
import 'package:vietagri/pages/home/welcome.dart';
import 'package:vietagri/repositories/AreaRepository.dart';
import 'package:vietagri/repositories/RiceSeedRepository.dart';
import 'package:vietagri/repositories/UserRepository.dart';
import 'package:vietagri/utils/SharedObjects.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:vietagri/pages/home/home.dart';
import 'package:vietagri/blocs/area/Bloc.dart';

getUserLocation() async {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  _locationData = await location.getLocation();

  SharedObjects.prefs
      .setValue(Constants.userLatitude, _locationData.latitude, 'double');
  SharedObjects.prefs
      .setValue(Constants.userLongitude, _locationData.longitude, 'double');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedObjects.prefs = await CachedSharedPreferences.getInstance();
  await getUserLocation();
  GoogleMap.init(API_KEY);
  await Firebase.initializeApp();
  final AreaRepository areaRepository = AreaRepository();
  final RiceSeedRepository riceSeedRepository = RiceSeedRepository();
  final UserRepository userRepository = UserRepository();

  runApp(MultiBlocProvider(providers: [
    BlocProvider<AreaBloc>(
      create: (context) => AreaBloc(areaRepository: areaRepository),
    ),
    BlocProvider<RiceSeedBloc>(
      create: (context) => RiceSeedBloc(riceSeedRepository: riceSeedRepository),
    ),
    BlocProvider<UserBloc>(
      create: (context) => UserBloc(userRepository: userRepository)..add(LoginEvent('', '', sessionLogin: true))
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  static UserState userState;
  static User loggedInUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VietAgri Application',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is LoggedInState) {
            userState = state;
            loggedInUser = state.user;
            return Home();
          } else if (state is AuthenticationInProgress) {
            return Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator(),)
            );
          } else {
            return Welcome();
          }
        },
      ),
    );
  }
}
