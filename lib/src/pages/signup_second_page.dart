import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/blocs/signup_bloc.dart';
import 'package:reazzon/src/helpers/fieldFocus.dart';
import 'package:reazzon/src/models/user.dart';
import 'package:reazzon/src/pages/signup_third_page.dart';

class SecondSignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SecondSignUpPageState();
}

class _SecondSignUpPageState extends State<SecondSignUpPage> {
  SignUpBloc _signUpBloc;
  Future<User> _user;

  @override
  void initState()
  {
    super.initState();
    _signUpBloc = new SignUpBloc();
  }

  @override
  void dispose()
  {
    _signUpBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode _focusFirstName = new FocusNode();
    FocusNode _focusLastName = new FocusNode();
    FocusNode _focusUserName = new FocusNode();

    final ApplicationBloc _appBloc = BlocProvider.of<ApplicationBloc>(context);
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Signup", style: TextStyle(color: Colors.blueAccent)),
        centerTitle: true,
      ),
      body: new SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100.0,
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  EnsureVisibleWhenFocused(
                    focusNode: _focusFirstName,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Text(
                          "FIRST NAME",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: firstNameField(_signUpBloc)
                    )
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  EnsureVisibleWhenFocused(
                    focusNode: _focusLastName,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Text(
                          "LAST NAME",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: lastNameField(_signUpBloc)
                    )
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  EnsureVisibleWhenFocused(
                    focusNode: _focusUserName,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Text(
                          "USERNAME",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: userNameField(_signUpBloc)
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: buildButton(_signUpBloc, _appBloc),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget firstNameField(SignUpBloc signUpBloc) {
    return StreamBuilder(
      stream: signUpBloc.outFirstName,
      builder: (context, snapshot) {
        return TextField(
          style: TextStyle(fontSize: 30.0),
          onChanged: signUpBloc.inFirstName,
          decoration: InputDecoration(
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget lastNameField(SignUpBloc signUpBloc) {
    return StreamBuilder(
      stream: signUpBloc.outLastName,
      builder: (context, snapshot) {
        return TextField(
          style: TextStyle(fontSize: 30.0),
          onChanged: signUpBloc.inLastName,
          decoration: InputDecoration(
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget userNameField(SignUpBloc signUpBloc) {
    return StreamBuilder(
      stream: signUpBloc.outUserName,
      builder: (context, snapshot) {
        return TextField(
          style: TextStyle(fontSize: 30.0),
          onChanged: signUpBloc.inUserName,
          decoration: InputDecoration(
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget continueButton(SignUpBloc signUpBloc, ApplicationBloc appBloc) {
    return StreamBuilder(
      stream: signUpBloc.updateDetailsValid,
      builder: (context, snapshot) {
        return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          color: Colors.blueAccent,
          elevation: 4.0,
          onPressed: snapshot.hasData ? () {
              setState(() {
               _user = signUpBloc.updateDetails(appBloc.currentUser); 
              });
            }
            : null,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "CONTINUE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ), 
        );
      },
    );
  }

  Widget buildButton(SignUpBloc signUpBloc, ApplicationBloc appBloc){
    return new FutureBuilder(
      future: _user,
      builder: (context, AsyncSnapshot<User> snapshot){
        if(snapshot.hasData){
          _user.then((updatedUser){
            appBloc.updateUser(updatedUser);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => ThirdSignUpPage()
                )
            );
          });
          return Container();
        }
        else {
          if(snapshot.connectionState != ConnectionState.none && !snapshot.hasData){
            if(snapshot.connectionState == ConnectionState.done)
              return continueButton(signUpBloc, appBloc);

            return new Stack(
              alignment: FractionalOffset.center,
              children: <Widget>[
                new CircularProgressIndicator(
                  backgroundColor: Colors.blueAccent,
                )
              ],
            );
          }
            
          return continueButton(signUpBloc, appBloc);
        }
      },
    );
  }
}


