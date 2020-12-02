import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietagri/blocs/user/Bloc.dart';
import 'package:vietagri/main.dart';
import 'package:vietagri/pages/agencies/agencies.dart';
import 'package:vietagri/pages/auth/login.dart';
import 'package:vietagri/pages/auth/signup.dart';
import 'package:vietagri/pages/edit_profile.dart';
import 'package:vietagri/pages/home/home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vietagri/pages/home/welcome.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  UserBloc userBloc;

  @override
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context);
    userBloc.listen((state) {
      if (state is LoggedOutState) {
        MyApp.loggedInUser = null;
        Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MyApp.loggedInUser != null ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: <Widget>[
          MyApp.loggedInUser != null ? UserAccountsDrawerHeader(
            accountName: Text(MyApp.loggedInUser.fullName),
            accountEmail: Text(MyApp.loggedInUser.email),
            currentAccountPicture: GestureDetector(
              child: CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.grey,
                backgroundImage: MyApp.loggedInUser.image == "" ? null : CachedNetworkImageProvider(MyApp.loggedInUser.image)
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
              },
            ),
          ) : Text(''),
          MyApp.loggedInUser == null ? ListTile(
            leading: Icon(Icons.person_add),
            title: Text('Sign up'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Signup()
                )
              );
            },
          ) : Text(''),
          MyApp.loggedInUser == null ? ListTile(
            leading: Icon(Icons.login),
            title: Text('Login'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Login()
                )
              );
            },
          ) : Text(''),
          MyApp.loggedInUser != null ? ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
            },
          ) : Text(''),
          MyApp.loggedInUser != null ? ListTile(
            leading: Icon(Icons.card_giftcard),
            title: Text('Contact with agency'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Agencies(),
                ),
              );
            },
          ) : Text(''),
          MyApp.loggedInUser != null ? ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              userBloc.add(LogoutEvent());
            },
          ) : Text(''),
        ],
      ),
    );
  }
}
