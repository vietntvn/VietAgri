import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vietagri/blocs/user/Bloc.dart';
import 'package:vietagri/blocs/user/UserBloc.dart';
import 'package:vietagri/main.dart';
import 'package:vietagri/widgets/drawer.dart';
import 'package:vietagri/widgets/header.dart';
import 'package:vietagri/widgets/raised-button.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  UserBloc userBloc;
  bool isLoading = false;
  bool _obscureText = true;
  String _fullName = MyApp.loggedInUser.fullName;
  String _email = MyApp.loggedInUser.email;
  String _address = MyApp.loggedInUser.address;
  String _username = MyApp.loggedInUser.username;
  String _password = MyApp.loggedInUser.password;
  FocusNode _passwordFocusNode = FocusNode();
  File _image;

  @override
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context);
    userBloc.listen((state) {
      if (state is AuthenticationInProgress) {
        isLoading = true;
      }
      if (state is LoggedInState) {
        isLoading = false;
        SnackBar snackBar = SnackBar(
          content: Text('Profile updated successfully'),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        MyApp.loggedInUser = state.user;
      }
      if (state is SignupIsDuplicate) {
        isLoading = false;
        SnackBar snackBar = SnackBar(
          content: Text('Email or username already exist'),
          backgroundColor: Colors.red,
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
      if (mounted) setState(() {});
    });
  }

  Widget _showFullNameInput() {
    return _textFieldPadding(
      child: TextFormField(
        decoration: textFieldDecoration(labelText: 'Full name'),
        onChanged: (val) => _fullName = val,
        validator: (val) {
          if (val.isEmpty) {
            return 'This field cannot be blank';
          } else if (val.trim().length < 3) {
            return 'Display name is too short';
          } else if (val.trim().length > 30) {
            return 'Display name is too long';
          } else if (!RegExp(r'^[a-zA-Z\s]{0,255}$').hasMatch(val)) {
            return 'Name must contain alphabets ONLY';
          } else {
            return null;
          }
        },
        initialValue: _fullName,
      ),
    );
  }

  Widget _showEmailInput() {
    return _textFieldPadding(
      child: TextFormField(
        decoration: textFieldDecoration(labelText: 'Email'),
        onChanged: (val) => _email = val,
        validator: (val) {
          if (val.isEmpty) {
            return 'This field cannot be blank';
          } else if (!RegExp(
                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)"
                  r"*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*["
                  r"a-z0-9])?")
              .hasMatch(val)) {
            return 'Invalid email';
          } else {
            return null;
          }
        },
        initialValue: _email,
      ),
    );
  }

  Widget _showAddressInput() {
    return _textFieldPadding(
      child: TextFormField(
        decoration: textFieldDecoration(labelText: 'Address'),
        onChanged: (val) => _address = val,
        validator: (val) => val.isEmpty ? 'Address field is required' : null,
        initialValue: _address,
      ),
    );
  }

  Widget _showUsernameInput() {
    return _textFieldPadding(
        child: TextFormField(
      decoration: textFieldDecoration(labelText: 'Username'),
      onChanged: (val) => _username = val,
      validator: (val) {
        if (val.isEmpty) {
          return 'This field cannot be blank';
        } else if (val.trim().length < 4) {
          return 'Username is too short';
        } else if (val.trim().length > 12) {
          return 'Username is too long';
        } else if (!RegExp(r'[a-zA-Z0-9]').hasMatch(val)) {
          return 'Username must contain alphanumerics ONLY';
        } else {
          return null;
        }
      },
      initialValue: _username,
    ));
  }

  Widget _showPasswordInput() {
    return _textFieldPadding(
        child: TextFormField(
      decoration: textFieldDecoration(
          labelText: 'Password',
          obscureText: true,
          focusNode: _passwordFocusNode),
      onChanged: (val) => _password = val,
      validator: (val) => val.isEmpty ? 'Password field is required' : null,
      obscureText: _obscureText,
      focusNode: _passwordFocusNode,
      initialValue: _password,
    ));
  }

  Widget _textFieldPadding({Widget child}) {
    return Padding(padding: EdgeInsets.only(top: 20.0), child: child);
  }

  InputDecoration textFieldDecoration(
      {String labelText, bool obscureText = false, FocusNode focusNode}) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      labelText: labelText != null ? labelText : '',
      suffixIcon: obscureText
          ? GestureDetector(
              onTap: () => setState(() => _obscureText = !_obscureText),
              child: AbsorbPointer(
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: focusNode.hasFocus
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
            )
          : Text(''),
    );
  }

  Widget _showFormAction() {
    return _textFieldPadding(
      child: Row(
        children: [
          Expanded(
            child: raisedButton(
              label: Text('Update profile', style: TextStyle(fontSize: 16.0)),
              onPressed: _submit,
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      userBloc.add(
        SignupEvent(
          MyApp.loggedInUser.id,
          _fullName,
          _email,
          _address,
          _password,
          _username,
          _image
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(
        context,
        showSearchIcon: false,
        showNotificationIcon: false,
      ),
      drawer: DrawerWidget(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: MyApp.loggedInUser.image == "" ? null : CachedNetworkImageProvider(MyApp.loggedInUser.image),
                    ),
                    onTap: () async {
                      final pickedFile = await ImagePicker()
                            .getImage(source: ImageSource.gallery);
                        setState(() => _image = File(pickedFile.path));
                    },
                  ),
                  _showFullNameInput(),
                  _showEmailInput(),
                  _showAddressInput(),
                  _showUsernameInput(),
                  _showPasswordInput(),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _showFormAction(),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                ],
              )
            )
          )
        )
      )
    );
  }
}