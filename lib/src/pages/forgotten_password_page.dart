import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/login_bloc.dart';
import 'package:reazzon/src/helpers/fieldFocus.dart';
import 'package:reazzon/src/helpers/spinner.dart';

class ForgottenPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForgottenPasswordPageState();
}
  
class _ForgottenPasswordPageState extends State<ForgottenPasswordPage> {
  LoginBloc _loginBloc;
  Future<bool> _forgottenPasswordSuccessful;

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

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color:  Colors.blueAccent
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Forgotten password", style: TextStyle(color: Colors.blueAccent)),
      ),
      body: new SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100.0,
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Column(
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
              Container(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: Center(
                  child: StreamBuilder(
                    stream: _loginBloc.outSuccessForgottenMessages,
                    builder: (context, snapshot){
                      return snapshot.hasData ? 
                        Text(snapshot.data, style: TextStyle(color: Colors.green), textAlign: TextAlign.center, softWrap: true) : 
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: buildButton(_loginBloc),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(LoginBloc loginBloc) {
    return new FutureBuilder(
      future: _forgottenPasswordSuccessful,
      builder: (context, snapshot){
        if(!snapshot.hasData){
          if(snapshot.connectionState != ConnectionState.none)
            return Spinner();
          
          return submitButton(loginBloc);
        }
        
        if(snapshot.hasData){
          if(snapshot.data){
            return submitButton(loginBloc);
          }

          if(!snapshot.data){
            if(snapshot.connectionState == ConnectionState.done)
              return submitButton(loginBloc);

            return Spinner();
          }
        }
      },
    );
  }

  Widget submitButton(LoginBloc loginBloc){
    return StreamBuilder(
      stream: loginBloc.forgottenPasswordValid,
      builder: (context, snapshot) {
        return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)
          ),
          color: Colors.blueAccent,
          elevation: 4.0,
          onPressed: snapshot.hasData ? () {
            setState(() {
              _forgottenPasswordSuccessful = _loginBloc.forgottenPassword();
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
                    "RESET PASSWORD",
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
}

