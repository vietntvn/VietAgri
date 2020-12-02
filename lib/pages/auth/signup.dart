import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vietagri/blocs/user/Bloc.dart';
import 'package:vietagri/pages/home/home.dart';
import 'package:vietagri/widgets/drawer.dart';
import 'package:vietagri/widgets/header.dart';
import 'package:vietagri/widgets/raised-button.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  UserBloc userBloc;
  bool isLoading = false;
  bool _obscureText = true;
  String _fullName, _email, _address, _username, _password;
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _confirmPasswordFocusNode = FocusNode();
  File _image;

  @override
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context);
    userBloc.listen((state) {
      if (state is AuthenticationCompleted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
      if (state is AuthenticationInProgress) {
        isLoading = true;
      }
      if (state is AuthenticationErrorState) {
        isLoading = false;
        SnackBar snackBar = SnackBar(
          content: Text('Server error occurred'),
          backgroundColor: Colors.red,
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
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

  Widget _showTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: Text(
        'Create account',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _textFieldPadding({Widget child}) {
    return Padding(padding: EdgeInsets.only(top: 20.0), child: child);
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
      ),
    );
  }

  Widget _showAddressInput() {
    return _textFieldPadding(
      child: TextFormField(
        decoration: textFieldDecoration(labelText: 'Address'),
        onChanged: (val) => _address = val,
        validator: (val) => val.isEmpty ? 'Address field is required' : null,
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
    ));
  }

  Widget _showConfirmPasswordInput() {
    return _textFieldPadding(
        child: TextFormField(
      decoration: textFieldDecoration(
          labelText: 'Confirm Password',
          obscureText: true,
          focusNode: _confirmPasswordFocusNode),
      validator: (val) => val != _password ? 'Passwords do not match' : null,
      obscureText: _obscureText,
      focusNode: _confirmPasswordFocusNode,
    ));
  }

  Widget _showFormAction() {
    return _textFieldPadding(
      child: Row(
        children: [
          Expanded(
            child: raisedButton(
              label: Text('Sign up', style: TextStyle(fontSize: 16.0)),
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
          null,
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
                  _showTitle(),
                  _showFullNameInput(),
                  _showEmailInput(),
                  _showAddressInput(),
                  _showUsernameInput(),
                  _showPasswordInput(),
                  _showConfirmPasswordInput(),
                  _image != null
                      ? _textFieldPadding(
                          child: Container(
                          child: Image.file(_image,
                              fit: BoxFit.fitWidth, height: 150.0),
                        ))
                      : Text(''),
                  _textFieldPadding(
                    child: FlatButton(
                      onPressed: () async {
                        final pickedFile = await ImagePicker()
                            .getImage(source: ImageSource.gallery);
                        setState(() => _image = File(pickedFile.path));
                      },
                      child: Container(
                        height: 50.0,
                        child: Text(
                          'Select an image',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _showFormAction(),
                  Padding(padding: EdgeInsets.only(top: 10.0))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
