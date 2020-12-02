import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietagri/blocs/user/Bloc.dart';
import 'package:vietagri/main.dart';
import 'package:vietagri/pages/home/home.dart';
import 'package:vietagri/widgets/drawer.dart';
import 'package:vietagri/widgets/header.dart';
import 'package:vietagri/widgets/raised-button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureText = true;
  String _username, _password;
  FocusNode _passwordFocusNode = FocusNode();
  UserBloc userBloc;

  @override
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context);
    userBloc.listen((state) {
      if (state is LoggedInState) {
        MyApp.userState = state;
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Home()
        ));
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
      if (state is LoginInfoNotExist) {
        isLoading = false;
        SnackBar snackBar = SnackBar(
          content: Text('Username or password is incorrect'),
          backgroundColor: Colors.red,
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
      if (mounted) setState(() {
        
      });
    });
  }

  InputDecoration textFieldDecoration({String labelText, bool obscureText = false, FocusNode focusNode}) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      labelText: labelText != null ? labelText : '',
      suffixIcon: obscureText ? GestureDetector(
        onTap: () => setState(() =>  _obscureText = !_obscureText),
        child: AbsorbPointer(
          child: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: focusNode.hasFocus ? Theme.of(context).primaryColor : Colors.grey
        ))
      ) : Text(''),
    );
  }

  Widget _textFieldPadding({Widget child}) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: child
    );
  }

  Widget _showTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: Text(
        'Sign in',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0
        )
      )
    );
  }

  Widget _showUsername() {
    return _textFieldPadding(
      child: TextFormField(
        decoration: textFieldDecoration(labelText: 'Username'),
        onChanged: (val) => _username = val, 
        validator: (val) => val.isEmpty ? 'Username field is required' : null,
      )
    );
  }

  Widget _showPassword() {
    return _textFieldPadding(
      child: TextFormField(
        decoration: textFieldDecoration(labelText: 'Password', obscureText: true, focusNode: _passwordFocusNode),
        onChanged: (val) => _password = val,
        validator: (val) => val.isEmpty ? 'Password field is required' : null,
        obscureText: _obscureText,
        focusNode: _passwordFocusNode,
      )
    );
  }

  Widget _showFormAction() {
    return _textFieldPadding(
      child: Row(children: [ Expanded(child: raisedButton(
      label: Text('Sign in', style: TextStyle(fontSize: 16.0)),
      onPressed: _submit,
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
    ))]));
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      userBloc.add(LoginEvent(_username, _password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, showSearchIcon: false, showNotificationIcon: false),
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
                  _showUsername(),
                  _showPassword(),
                  isLoading ? Center(child: CircularProgressIndicator()) : _showFormAction(),
                  Padding(padding: EdgeInsets.only(top: 10.0))
                ],
              )
            )
          )
        )
      ),
    );
  }
}