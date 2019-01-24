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
      body: new SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Column(
            children: <Widget>[
              Container(height: 20.0),
              Container(
                padding: EdgeInsets.all(55.0),
              ),
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
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 5.0),
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
              Container(height: 20.0),
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
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 5.0),
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
              Container(height: 20.0),
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
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 5.0),
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
                margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: continueButton(_signUpBloc, _appBloc),
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
}

Widget firstNameField(SignUpBloc signUpBloc) {
  return StreamBuilder(
    stream: signUpBloc.outFirstName,
    builder: (context, snapshot) {
      return TextField(
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
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.blueAccent,
        elevation: 4.0,
        onPressed: snapshot.hasData ? () {
            appBloc.outCurrentUser.listen((User user){
              signUpBloc.submitDetails(user).then((_){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => ThirdSignUpPage()
                  )
                );
              });
            });
          }
          : null,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
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
