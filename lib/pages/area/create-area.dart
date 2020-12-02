import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:vietagri/config/Constants.dart';
import 'package:vietagri/models/RiceSeed.dart';
import 'package:vietagri/models/Soil.dart';
import 'package:vietagri/models/Weather.dart';
import 'package:vietagri/pages/home/home.dart';
import 'package:vietagri/utils/SharedObjects.dart';
import 'package:vietagri/widgets/custom-dropdown-field.dart';
import 'package:vietagri/widgets/drawer.dart';
import 'package:vietagri/widgets/header.dart';
import 'package:vietagri/widgets/raised-button.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietagri/blocs/area/Bloc.dart';

class CreateArea extends StatefulWidget {
  final String areaId;
  final String initialName;
  final String initialArea;
  final String initialAreaUnit;
  final String initialLocation;
  final String initialRiceSeedKind;
  final String initialSoil;
  final String initialWeather;
  final bool editMode;

  CreateArea({
    this.areaId,
    this.initialName,
    this.initialArea,
    this.initialAreaUnit,
    this.initialLocation,
    this.initialRiceSeedKind,
    this.initialSoil,
    this.initialWeather,
    this.editMode,
  });

  @override
  _CreateAreaState createState() => _CreateAreaState();
}

class _CreateAreaState extends State<CreateArea> {
  final _formKey = GlobalKey<FormState>();
  final _mapKey = GlobalKey<GoogleMapStateBase>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final createAreaBtnFocusNode = FocusNode();
  final riceSeedRef = FirebaseFirestore.instance.collection('riceSeed');
  final soilRef = FirebaseFirestore.instance.collection('soil');
  final weatherRef = FirebaseFirestore.instance.collection('weather');
  AreaBloc areaBloc;
  final List<RiceSeed> riceSeeds = [];
  final List<Soil> soils = [];
  final List<Weather> weathers = [];
  final List<String> riceSeedTitles = ['Select a rice seed kind'];
  final List<String> soilTitles = ['Select a soil'];
  final List<String> weatherTitles = ['Select a weather'];

  TextEditingController addressController = TextEditingController();

  String _name, _area;
  String _areaUnit = 'm2';
  String _riceSeed = 'Select a rice seed kind';
  String _soil = 'Select a soil';
  String _weather = 'Select a weather';
  bool _showRiceSeed = false;
  bool _showLoadingIcon = false;
  bool _isLocationValid = true;
  GeoCoord _userLocation;
  double latitude, longitude;
  Set<Marker> _markers;
  Widget mapWidget = Text('');
  String _province;

  @override
  void initState() {
    super.initState();
    latitude = SharedObjects.prefs.getValue('userLatitude');
    longitude = SharedObjects.prefs.getValue('userLongitude');
    initUserAddress(latitude, longitude);
    areaBloc = BlocProvider.of<AreaBloc>(context);
    areaBloc.listen((state) {
      if (state is AreaInProgress) _showLoadingIcon = true;
      if (state is AreaCreated || state is AreaUpdated) {
        _showLoadingIcon = false;
        SnackBar snackBar = SnackBar(
          content: Text(
            'Area ${state is AreaCreated ? "Created" : "Updated"} Successfully',
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return Home();
          }),
        );
      }
      if (state is ErrorState) {
        _showLoadingIcon = false;
        SnackBar snackBar = SnackBar(
          content: Text('Server error occurred'),
          backgroundColor: Colors.red,
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
      if (mounted) setState(() {});
    });
    if (widget.editMode) {
      setState(() {
        _name = widget.initialName;
        _area = widget.initialArea;
        _riceSeed = widget.initialRiceSeedKind;
        _soil = widget.initialSoil;
        _weather = widget.initialWeather;
      });
    }
  }

  initUserAddress(double latitude, double longitude) async {
    if (widget.editMode && mapWidget is Text) {
      addressController.text = widget.initialLocation;
      await verifyLocationAndLoadMap();
    } else {
      var addresses = await Geocoder.local
          .findAddressesFromCoordinates(new Coordinates(latitude, longitude));
      if (addresses.first.countryName.toLowerCase() == 'vietnam') {
        addressController.text = addresses.first.addressLine;
        _province = addresses.first.adminArea;
        _userLocation = new GeoCoord(
          addresses.first.coordinates.latitude,
          addresses.first.coordinates.longitude,
        );
        _markers = Set.from([
          Marker(_userLocation, label: 'Location on map'),
        ]);
        _isLocationValid = true;
      } else {
        _isLocationValid = false;
        locationErrorMsg();
      }
    }
    mapWidget = SizedBox(
      height: 200.0,
      child: GoogleMap(
        key: _mapKey,
        initialPosition: _userLocation,
        markers: _markers,
        initialZoom: 15.0,
        onTap: (GeoCoord position) async {
          await initUserAddress(
            position.latitude,
            position.longitude,
          );
        },
      ),
    );
    setState(() {});
  }

  Future<void> verifyLocationAndLoadMap() async {
    var addresses =
        await Geocoder.local.findAddressesFromQuery(addressController.text);
    if (addresses.first.countryName.toLowerCase() == "vietnam") {
      addressController.text = addresses.first.addressLine;
      _province = addresses.first.adminArea;
      _userLocation = new GeoCoord(addresses.first.coordinates.latitude,
          addresses.first.coordinates.longitude);
      _markers = Set.from([
        Marker(_userLocation, label: 'Location on map'),
      ]);
      _isLocationValid = true;
    } else {
      _isLocationValid = false;
      locationErrorMsg();
    }
    setState(() {});
  }

  Future<Widget> locationErrorMsg() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('Invalid address, try again'),
          actions: [
            FlatButton(
              child: Text('Close'),
              onPressed: () => Navigator.pop(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              color: Colors.grey[600],
              textColor: Colors.black,
            ),
          ],
        );
      },
    );
  }

  InputDecoration textFieldDecoration({String labelText, Icon suffixIcon}) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      labelText: labelText != null ? labelText : '',
      suffixIcon: suffixIcon != null ? suffixIcon : Text(''),
    );
  }

  Widget _showNameInput() {
    return Padding(
      padding: EdgeInsets.only(top: 15.0),
      child: TextFormField(
        onChanged: (val) => _name = val,
        decoration: textFieldDecoration(labelText: 'Name'),
        validator: (val) => val.isEmpty ? 'Name field is required' : null,
        initialValue: _name,
      ),
    );
  }

  Widget _showAreaUnitInput() {
    return Expanded(
      flex: 1,
      child: CustomDropdownField(
        displayText: widget.editMode ? widget.initialAreaUnit : _areaUnit,
        dropdownItems: ['m2', 'ha'],
        fullWidth: false,
        itemSelected: (selectedItem) {
          setState(() => _areaUnit = selectedItem);
        },
      ),
    );
  }

  Widget _showAreaInput() {
    return Padding(
      padding: EdgeInsets.only(top: 15.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              onChanged: (val) => _area = val,
              decoration: textFieldDecoration(labelText: 'Area'),
              keyboardType: TextInputType.number,
              validator: (val) => val.isEmpty ? 'Area field is required' : null,
              initialValue: _area,
            ),
          ),
          Padding(padding: EdgeInsets.only(right: 10.0)),
          _showAreaUnitInput()
        ],
      ),
    );
  }

  Widget _showLocationInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: FocusScope(
        onFocusChange: (value) async {
          if (!value) {
            await verifyLocationAndLoadMap();
          }
        },
        child: TextFormField(
          controller: addressController,
          decoration: textFieldDecoration(labelText: 'Location'),
          keyboardType: TextInputType.streetAddress,
          validator: (val) => val.isEmpty ? 'Location field is required' : null,
        ),
      ),
    );
  }

  Widget _showSoilInput() {
    return StreamBuilder(
      stream: soilRef.doc(Constants.soilId).collection('data').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        snapshot.data.documents.forEach((doc) {
          Soil soil = Soil.fromDocument(doc);
          if (!soilTitles.contains(soil.name)) {
            soils.add(soil);
            soilTitles.add(soil.name);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() => _soil = widget.editMode ? widget.initialSoil : soilTitles[0]);
            });
          }
        });
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: CustomDropdownField(
            displayText:
                widget.editMode && widget.initialSoil == _soil ? widget.initialSoil : _soil,
            dropdownItems: soilTitles,
            fullWidth: true,
            itemSelected: (selectedItem) {
              setState(() => _soil = selectedItem);
              createAreaBtnFocusNode.requestFocus();
            },
          ),
        );
      }
    );
  }

  Widget _showWeatherInput() {
    return StreamBuilder(
      stream: weatherRef.doc(Constants.weatherId).collection('data').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        snapshot.data.documents.forEach((doc) {
          Weather weather = Weather.fromDocument(doc);
          if (!weatherTitles.contains(weather.name)) {
            weathers.add(weather);
            weatherTitles.add(weather.name);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() => _weather = widget.editMode ? widget.initialWeather : weatherTitles[0]);
            });
          }
        });
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: CustomDropdownField(
            displayText:
                widget.editMode && widget.initialWeather == _weather ? widget.initialWeather : _weather,
            dropdownItems: weatherTitles,
            fullWidth: true,
            itemSelected: (selectedItem) {
              setState(() => _weather = selectedItem);
              createAreaBtnFocusNode.requestFocus();
            },
          ),
        );
      }
    );
  }

  Widget _showRiceSeedKindInput() {
    if (_showRiceSeed) {
      return StreamBuilder(
        stream: riceSeedRef
            .doc(Constants.riceSeedId)
            .collection('data')
            .where('locations.$_province', isEqualTo: true)
            .where('soils.$_soil', isEqualTo: true)
            .where('weathers.$_weather', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (_showRiceSeed && snapshot.data.documents.length < 1) {
            WidgetsBinding.instance.addPostFrameCallback((_) { 
              SnackBar snackBar = SnackBar(
                content: Text('There is currently no rice seed for the data provided'),
                backgroundColor: Colors.red,
              );
              _scaffoldKey.currentState.showSnackBar(snackBar);
            });
          }
          snapshot.data.documents.forEach((doc) {
            RiceSeed riceSeed = RiceSeed.fromDocument(doc);
            if (!riceSeedTitles.contains(riceSeed.name)) {
              riceSeeds.add(riceSeed);
              riceSeedTitles.add(riceSeed.name);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => _riceSeed = widget.editMode ? widget.initialRiceSeedKind : riceSeedTitles[0]);
              });
            }
          });
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: CustomDropdownField(
              displayText:
                  widget.editMode && widget.initialRiceSeedKind == _riceSeed ? widget.initialRiceSeedKind : _riceSeed,
              dropdownItems: riceSeedTitles,
              fullWidth: true,
              itemSelected: (selectedItem) {
                setState(() => _riceSeed = selectedItem);
                createAreaBtnFocusNode.requestFocus();
              },
            ),
          );
        },
      );
    } else {
      return Text('');
    }
  }

  Widget _showFormAction() {
    return Row(children: [
      Expanded(
        child: raisedButton(
          showIcon: _showRiceSeed && !_showLoadingIcon,
          icon: Icon(Icons.location_on),
          label: _showLoadingIcon
              ? CircularProgressIndicator()
              : Text(
                  _showRiceSeed
                      ? widget.editMode ? 'Update area' : 'Create area'
                      : 'Next',
                ),
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          focusNode: createAreaBtnFocusNode,
          onPressed: _showLoadingIcon
              ? null
              : () async {
                  var isFormValidated = _formKey.currentState.validate();
                  if (_soil == 'Select a soil') {
                    SnackBar snackBar = SnackBar(
                      content: Text(
                        'You must select a soil!',
                      ),
                      backgroundColor: Colors.red,
                    );
                    _scaffoldKey.currentState.showSnackBar(snackBar);
                  } else if (_weather == 'Select a weather') {
                    SnackBar snackBar = SnackBar(
                      content: Text(
                        'You must select a weather!',
                      ),
                      backgroundColor: Colors.red,
                    );
                    _scaffoldKey.currentState.showSnackBar(snackBar);
                  } else if (!_showRiceSeed && isFormValidated) {
                    setState(() => _showRiceSeed = !_showRiceSeed);
                  } else if (isFormValidated && _showRiceSeed) {
                    if (_riceSeed == 'Select a rice seed kind') {
                      SnackBar snackBar = SnackBar(
                        content: Text(
                          'You must select a rice seed kind!',
                        ),
                        backgroundColor: Colors.red,
                      );
                      _scaffoldKey.currentState.showSnackBar(snackBar);
                    } else if (isFormValidated && _showRiceSeed) {
                      await verifyLocationAndLoadMap();
                      if (_isLocationValid) {
                        if (widget.editMode) {
                          areaBloc.add(
                            UpdateAreaEvent(
                              widget.areaId,
                              _name,
                              _area,
                              _areaUnit,
                              addressController.text,
                              _riceSeed,
                              _soil,
                              _weather,
                              _province
                            ),
                          );
                        } else {
                          areaBloc.add(
                            CreateAreaEvent(
                              _name,
                              _area,
                              _areaUnit,
                              addressController.text,
                              _riceSeed,
                              _soil,
                              _weather,
                              _province
                            ),
                          );
                        }
                      }
                    }
                  }
                },
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context),
      drawer: DrawerWidget(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(children: [
              _showNameInput(),
              _showAreaInput(),
              _showLocationInput(),
              mapWidget,
              _showSoilInput(),
              _showWeatherInput(),
              _showRiceSeedKindInput(),
              _showFormAction()
            ]),
          ),
        ),
      ),
    );
  }
}
