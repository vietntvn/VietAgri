import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietagri/blocs/area/Bloc.dart';
import 'package:vietagri/models/Area.dart';
import 'package:vietagri/pages/home/home.dart';
import 'package:vietagri/widgets/area-widget.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final searchAreaFocusNode = FocusNode();
  AreaBloc areaBloc;
  bool displayAreas = false;
  List<Widget> areaWidgets = [];
  bool isLoading = false;
  List<Area> areaQueryResultSet = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchAreaFocusNode.requestFocus();
    areaBloc = BlocProvider.of<AreaBloc>(context);
    areaBloc.listen((state) {
      if (state is AreaFound) {
        areaWidgets.clear();
        for (int i = 0; i < state.areas.length; i++) {
          areaQueryResultSet.add(state.areas[i]);
          areaWidgets.add(areaWidget(
            context,
            index: i,
            area: state.areas[i],
            showPostOptions: false,
          ));
          isLoading = false;
          displayAreas = true;
        }
      }
      if (state is AreaInProgress) isLoading = true;
      if (state is NoAreas) {
        areaWidgets.clear();
        isLoading = false;
        displayAreas = false;
      }
      if (state is ErrorState) {
        areaWidgets.clear();
        isLoading = false;
        displayAreas = false;
        SnackBar snackBar = SnackBar(
          content: Text('Server error occurred'),
          backgroundColor: Colors.red,
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
      if (mounted) setState(() {});
    });
  }

  Widget searchHeader() {
    return AppBar(
      title: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide.none),
          hintText: 'Search area...',
          hintStyle: TextStyle(color: Colors.white),
        ),
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
        cursorColor: Colors.black,
        focusNode: searchAreaFocusNode,
        controller: searchController,
        onChanged: (val) {
          if (areaQueryResultSet.length == 0 && val.length == 1) {
            areaBloc.add(SearchAreaEvent(val, HomeState.riceSeeds));
          } else {
            setState(() => isLoading = true);
            areaWidgets.clear();
            val = val.trim().toLowerCase();
            if (val.isEmpty) {
              displayAreas = false;
              areaQueryResultSet.clear();
            } else {
              for (int i = 0; i < areaQueryResultSet.length; i++) {
                if (areaQueryResultSet[i].name.toLowerCase().startsWith(val)) {
                  areaWidgets.add(areaWidget(
                    context,
                    index: i,
                    area: areaQueryResultSet[i],
                    showPostOptions: false,
                  ));
                } else if (areaQueryResultSet[i]
                    .name
                    .toLowerCase()
                    .contains(val)) {
                  areaWidgets.add(areaWidget(
                    context,
                    index: i,
                    area: areaQueryResultSet[i],
                    showPostOptions: false,
                  ));
                }
              }
            }
            isLoading = false;
            setState(() {});
          }
        },
      ),
      iconTheme: IconThemeData(color: Colors.white),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            setState(() {
              searchController.text = '';
              displayAreas = false;
              areaWidgets.clear();
              areaQueryResultSet.clear();
            });
          },
        )
      ],
    );
  }

  Widget displayAreaWidgets() {
    return ListView(children: [
      Padding(
        padding: EdgeInsets.all(10.0),
        child: Text('Areas Found: ${areaWidgets.length}'),
      ),
      Column(children: areaWidgets),
    ]);
  }

  Widget displayLoadingWidget() {
    return Center(child: CircularProgressIndicator());
  }

  Widget displayNoAreaWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud),
          Text('There is not found'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return Home();
          }),
        );
        return Future.value(false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: searchHeader(),
        body: isLoading
            ? displayLoadingWidget()
            : displayAreas ? displayAreaWidgets() : displayNoAreaWidget(),
      ),
    );
  }
}
