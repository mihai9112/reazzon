import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/blocs/signup_bloc.dart';
import 'package:reazzon/src/helpers/fieldFocus.dart';
import 'package:reazzon/src/helpers/spinner.dart';
import 'package:reazzon/src/pages/login_page.dart';
import 'package:reazzon/src/pages/signup_second_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>{
  SignUpBloc _signUpBloc;
  Future<bool> _isSignUpSuccessful;
  
  @override
  void initState(){
    super.initState();
    _signUpBloc = new SignUpBloc();
  }

  @override
  void dispose(){
    _signUpBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode _focusEmail = new FocusNode();
    FocusNode _focusPassword = new FocusNode();
    FocusNode _focusConfirmPassword = new FocusNode();

    var _appBloc = BlocProvider.of<ApplicationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blueAccent
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Signup", style: TextStyle(color: Colors.blueAccent))
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100.0,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(55.0),
                child: Center(
                  child: Icon(
                    Icons.developer_board,
                    color: Colors.blueAccent,
                    size: 50.0,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: Center(
                  child: StreamBuilder(
                    stream: _signUpBloc.outMessages,
                    builder: (context, snapshot){
                      return snapshot.hasData ? 
                        Text(snapshot.data, style: TextStyle(color: Colors.red), textAlign: TextAlign.center, softWrap: true) : 
                        Container();
                    },
                  )
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      EnsureVisibleWhenFocused(
                        focusNode: _focusEmail,
                        child: Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text(
                              "EMAIL",
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
                        Expanded(child: emailField(_signUpBloc))
                      ],
                    ),
                  )
                ]
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      EnsureVisibleWhenFocused(
                        focusNode: _focusPassword, 
                        child: Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text(
                              "PASSWORD",
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
                    margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(child: passwordField(_signUpBloc)),
                      ],
                    ),
                  )
                ]
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      EnsureVisibleWhenFocused(
                        focusNode: _focusConfirmPassword,
                        child: Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text(
                              "CONFIRM PASSWORD",
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
                    margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(child: confirmPasswordField(_signUpBloc)),
                      ],
                    ),
                  ),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: FlatButton(
                      child: Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          fontSize: 15.0,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage()) 
                        );
                      },
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
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

  Widget submitButton(SignUpBloc signUpBloc) {
    return StreamBuilder(
      stream: signUpBloc.submitValid,
      builder: (context, snapshot) {
        return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.blueAccent,
          elevation: 4.0,
          onPressed: snapshot.hasData ? () {
              setState(() {
                _isSignUpSuccessful = _signUpBloc.submit();
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
                    "SIGNUP",
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

  Widget buildButton(SignUpBloc signUpBloc, ApplicationBloc appBloc) {
    return new FutureBuilder(
      future: _isSignUpSuccessful,
      builder: (context, snapshot){
        if(!snapshot.hasData){
          if(snapshot.connectionState != ConnectionState.none){
            return Spinner();
          }
          return submitButton(signUpBloc);
        }

        if(snapshot.hasData){
          if(snapshot.data){
            signUpBloc.outUser.listen((onData){
              appBloc.appState.setUser(onData);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => SecondSignUpPage()
                )
              );
            });
            return Container();
          }

          if(!snapshot.data){
            if(snapshot.connectionState == ConnectionState.done){
              return submitButton(signUpBloc);
            }
            return Spinner();
          }
        }
      },
    );
  }

  Widget emailField(SignUpBloc bloc) {
    return StreamBuilder(
      stream: bloc.outEmail,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.inEmail,
          keyboardType:  TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'you@example.com',
            errorText: snapshot.error,
            errorStyle: TextStyle(fontSize: 15.0)
          ),
        );
      },
    );
  }

  Widget passwordField(SignUpBloc bloc) {
    return StreamBuilder(
      stream: bloc.outPassword,
      builder: (context, snapshot) {
        return TextField(
          obscureText: true,
          onChanged: bloc.inPassword,
          decoration: InputDecoration(
            hintText: 'password',
            errorText: snapshot.error,
            errorStyle: TextStyle(fontSize: 15.0)
          ),
        );
      },
    );
  }

  Widget confirmPasswordField(SignUpBloc bloc) {
    return StreamBuilder(
      stream: bloc.outConfirmPassword,
      builder: (context, snapshot) {
        return TextField(
          obscureText: true,
          onChanged: bloc.inConfirmPassword,
          decoration: InputDecoration(
            hintText: 'password',
            errorText: snapshot.error,
            errorStyle: TextStyle(fontSize: 15.0)
          ),
        );
      },
    );
  }
}