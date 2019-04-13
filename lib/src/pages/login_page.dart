import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/blocs/login_bloc.dart';
import 'package:reazzon/src/helpers/fieldFocus.dart';
import 'package:flutter/widgets.dart';
import 'package:reazzon/src/helpers/spinner.dart';
import 'package:reazzon/src/pages/account.dart';
import 'package:reazzon/src/pages/signup_second_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  static const _kFontFam = 'reazzon';
  static const IconData facebookIcon = const IconData(0xe801, fontFamily: _kFontFam);
  static const IconData googleIcon = const IconData(0xf1a0, fontFamily: _kFontFam);
  LoginBloc _loginBloc;
  Future<bool> _isLoginSuccessful;

  @override
  void initState(){
    super.initState();
    _loginBloc = new LoginBloc();
  }

  @override
  void dispose(){
    _loginBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode _focusEmail = new FocusNode();
    FocusNode _focusPassword = new FocusNode();

    var _appBloc = BlocProvider.of<ApplicationBloc>(context);
    
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blueAccent
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Login", style: TextStyle(color: Colors.blueAccent))
      ),
      body:
      SingleChildScrollView(
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
                    stream: _loginBloc.outMessages,
                    builder: (context, snapshot){
                      return snapshot.hasData ? 
                        Text(snapshot.data, style: TextStyle(color: Colors.red), textAlign: TextAlign.center, softWrap: true) : 
                        Container();
                    },
                  )
                ),
              ),
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
                  ),
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
                    Expanded(child: emailField(_loginBloc))
                  ],
                ),
              ),
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
                  ),
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
                    Expanded(child: passwordField(_loginBloc)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: FlatButton(
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      onPressed: () => {}, //TODO:Functionality to be added
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
                      child: buildButton(_loginBloc, _appBloc),
                    ),
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
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(border: Border.all(width: 0.25)),
                      ),
                    ),
                    Text(
                      "OR CONNECT WITH",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(border: Border.all(width: 0.25)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 8.0),
                        alignment: Alignment.center,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                color: Color(0Xff3B5998),
                                onPressed: () {},
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              _isLoginSuccessful = _loginBloc.registerWithFacebook();
                                            });
                                          },
                                          padding: EdgeInsets.only(
                                            top: 20.0,
                                            bottom: 20.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Icon(
                                                facebookIcon,
                                                color: Colors.white,
                                                size: 15.0,
                                              ),
                                              Text(
                                                "FACEBOOK",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 8.0),
                        alignment: Alignment.center,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                color: Color(0Xffdb3236),
                                onPressed: () {},
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              _isLoginSuccessful = _loginBloc.registerWithGoogle();
                                            });
                                          },
                                          padding: EdgeInsets.only(
                                            top: 20.0,
                                            bottom: 20.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Icon(
                                                googleIcon,
                                                color: Colors.white,
                                                size: 15.0,
                                              ),
                                              Text(
                                                "GOOGLE",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ) 
    );
  }

  Widget submitButton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.blueAccent,
          elevation: 4.0,
          onPressed: snapshot.hasData ? () {
              setState(() {
                _isLoginSuccessful = bloc.submit();
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
                    "LOGIN",
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

  Widget emailField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeEmail,
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

  Widget passwordField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        return TextField(
          obscureText: true,
          onChanged: bloc.changePassword,
          decoration: InputDecoration(
            hintText: 'password',
            errorText: snapshot.error,
            errorStyle: TextStyle(fontSize: 15.0)
          ),
        );
      },
    );
  }

  Widget buildButton(LoginBloc loginBloc, ApplicationBloc appBloc) {
    return new FutureBuilder(
      future: _isLoginSuccessful,
      builder: (context, snapshot){
        if(!snapshot.hasData){
          if(snapshot.connectionState != ConnectionState.none){
            return Spinner();
          }
          return submitButton(loginBloc);
        }

        if(snapshot.hasData){
          if(snapshot.data){
            loginBloc.outUser.listen((onData){
              appBloc.appState.setUser(onData);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => appBloc.appState.user.userName == null ? SecondSignUpPage() : AccountPage()
                )
              );
            });
            return Container();
          }

          if(!snapshot.data){
            if(snapshot.connectionState == ConnectionState.done){
              return submitButton(loginBloc);
            }
            return Spinner();
          }
        }
      },
    );
  }
}



