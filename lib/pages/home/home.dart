import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietagri/blocs/area/Bloc.dart';
import 'package:vietagri/blocs/riceSeed/Bloc.dart';
import 'package:vietagri/blocs/user/Bloc.dart';
import 'package:vietagri/helpers/custom_popup_menu.dart';
import 'package:vietagri/models/RiceSeed.dart';
import 'package:vietagri/pages/area/create-area.dart';
import 'package:vietagri/widgets/area-widget.dart';
import 'package:vietagri/widgets/create-area-widget.dart';

import 'package:vietagri/widgets/drawer.dart';
import 'package:vietagri/widgets/header.dart';
import 'package:vietagri/widgets/raised-button.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AreaBloc areaBloc;
  RiceSeedBloc riceSeedBloc;
  List<Widget> areas = [];
  bool isLoading = true;
  static List<RiceSeed> riceSeeds = [];

  List<List<CustomPopupMenu>> areaOptions = [];

  @override
  void initState() {
    super.initState();
    areaBloc = BlocProvider.of<AreaBloc>(context);
    riceSeedBloc = BlocProvider.of<RiceSeedBloc>(context);
    riceSeedBloc.add(FetchRiceSeedsEvent());
    riceSeedBloc.listen((state) {
      if (state is RiceSeedInProgress) isLoading = true;
      if (state is FetchedRiceSeeds) {
        riceSeeds = state.riceSeeds;
        areaBloc.add(FetchAreasEvent(riceSeeds));
      }
      if (mounted) setState(() {});
    });
    areaBloc.listen((state) {
      if (state is NoAreas) {
        isLoading = false;
        areas.clear();
      }
      if (state is FetchedAreas) {
        isLoading = false;
        if (state.areas.length > 0) {
          areas.clear();
          for (int i = 0; i < state.areas.length; i++) {
            areaOptions.add([
              CustomPopupMenu(
                id: 'edit',
                title: Text('Edit'),
                areaId: state.areas[i].id,
                areaTitle: state.areas[i].name,
                area: state.areas[i].area,
                areaLocation: state.areas[i].location,
                areaUnit: state.areas[i].areaUnit,
                riceSeedKind: state.areas[i].riceSeedKind,
                soil: state.areas[i].soil,
                weather: state.areas[i].weather,
                widgetPosition: i,
              ),
              CustomPopupMenu(
                id: 'delete',
                title: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                areaId: state.areas[i].id,
                widgetPosition: i,
              ),
            ]);
            areas.add(areaWidget(
              context,
              index: i,
              area: state.areas[i],
              onAreaOptionSelected: handleAreaOptionSelected,
              areaOptions: areaOptions[i],
              showPostOptions: true,
            ));
          }
        } else {
          areas.clear();
        }
      }
      if (state is AreaInProgress) isLoading = true;
      if (state is ErrorState) {
        isLoading = false;
        areas.clear();
        SnackBar snackBar = SnackBar(
          content: Text('Server error occurred'),
          backgroundColor: Colors.red,
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
      if (mounted) setState(() {});
    });
  }

  void handleAreaOptionSelected(CustomPopupMenu choice) {
    if (choice.id == 'edit') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateArea(
            editMode: true,
            areaId: choice.areaId,
            initialName: choice.areaTitle,
            initialArea: choice.area,
            initialAreaUnit: choice.areaUnit,
            initialLocation: choice.areaLocation,
            initialRiceSeedKind: choice.riceSeedKind,
            initialSoil: choice.soil,
            initialWeather: choice.weather,
          ),
        ),
      );
    }
    if (choice.id == 'delete') {
      areaBloc.add(DeleteAreaEvent(choice.areaId));
      areas.removeAt(choice.widgetPosition);
      areaOptions.removeAt(choice.widgetPosition);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context),
      drawer: DrawerWidget(),
      body: Stack(
        children: [
          ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                child: raisedButton(
                  showIcon: true,
                  icon: Icon(Icons.location_on),
                  label: Text('Create area'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateArea(editMode: false),
                      ),
                    );
                  },
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                ),
              ),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : areas.isNotEmpty
                      ? Column(children: areas)
                      : Center(child: Text('There are no areas to display')),
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: createAreaWidget(context)
          )
        ]
      )
    );
  }
}
