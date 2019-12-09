import 'dart:async' show Future;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reazzon/src/helpers/field_focus.dart';
import 'package:reazzon/src/helpers/spinner.dart';
import 'package:reazzon/src/signup/presentation/bloc/signup.dart';

class SecondSignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SecondSignUpPageState();
}

class _SecondSignUpPageState extends State<SecondSignUpPage> {
  SignupBloc _signUpBloc;
  Future<bool> _isSecondSignUpSuccessful;

  @override
  void initState()
  {
    super.initState();
    _signUpBloc = BlocProvider.of<SignupBloc>(context);
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
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Signup", style: TextStyle(color: Colors.blueAccent, fontSize: 15.0)),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.looks_one,
                    size: 30.0,
                    color: Colors.grey,
                  ),
                  Icon(
                    Icons.trending_flat,
                    color: Colors.grey,
                    size: 30.0,
                  ),
                  Icon(
                    Icons.looks_two,
                    color: Colors.blueAccent,
                    size: 50.0,
                  ),
                  Icon(
                    Icons.trending_flat,
                    color: Colors.blueAccent,
                    size: 30.0,
                  ),
                  Icon(
                    Icons.looks_3,
                    size: 30.0,
                    color: Colors.grey,
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: firstNameField(_signUpBloc)
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                    margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: lastNameField(_signUpBloc)
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
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
                    margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: userNameField(_signUpBloc)
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: buildButton(_signUpBloc),
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

  Widget firstNameField(SignupBloc signUpBloc) {
    return Container();
    // return StreamBuilder(
    //   stream: signUpBloc.outFirstName,
    //   builder: (context, snapshot) {
    //     return TextField(
    //       style: TextStyle(fontSize: 15.0),
    //       onChanged: signUpBloc.inFirstName,
    //       decoration: InputDecoration(
    //         errorStyle: TextStyle(fontSize: 15.0),
    //         errorText: snapshot.error
    //       ),
    //     );
    //   },
    // );
  }

  Widget lastNameField(SignupBloc signUpBloc) {
    return Container();
    // return StreamBuilder(
    //   stream: signUpBloc.outLastName,
    //   builder: (context, snapshot) {
    //     return TextField(
    //       style: TextStyle(fontSize: 15.0),
    //       onChanged: signUpBloc.inLastName,
    //       decoration: InputDecoration(
    //         errorStyle: TextStyle(fontSize: 15.0),
    //         errorText: snapshot.error,
    //       ),
    //     );
    //   },
    // );
  }

  Widget userNameField(SignupBloc signUpBloc) {
    return Container();
    // return StreamBuilder(
    //   stream: signUpBloc.outUserName,
    //   builder: (context, snapshot) {
    //     return TextField(
    //       style: TextStyle(fontSize: 15.0),
    //       onChanged: signUpBloc.inUserName,
    //       decoration: InputDecoration(
    //         errorStyle: TextStyle(fontSize: 15.0),
    //         errorText: snapshot.error,
    //         prefixText: "@"
    //       ),
    //     );
    //   },
    // );
  }

  Widget continueButton(SignupBloc signUpBloc) {
    return Container();
    // return StreamBuilder(
    //   stream: signUpBloc.updateDetailsValid,
    //   builder: (context, snapshot) {
    //     return RaisedButton(
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(30.0),
    //       ),
    //       color: Colors.blueAccent,
    //       elevation: 4.0,
    //       onPressed: snapshot.hasData ? () {
    //           setState(() {
    //             //_isSecondSignUpSuccessful = signUpBloc.updateDetails(appBloc.appState.user);
    //           });
    //         }
    //         : null,
    //       child: Container(
    //         padding: const EdgeInsets.symmetric(
    //           vertical: 20.0,
    //           horizontal: 20.0
    //         ),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             Expanded(
    //               child: Text(
    //                 "CONTINUE",
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(
    //                   fontSize: 15.0,
    //                   color: Colors.white,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             )
    //           ],
    //         ),
    //       ), 
    //     );
    //   },
    // );
  }

  Widget buildButton(SignupBloc signUpBloc){
    return new FutureBuilder(
      future: _isSecondSignUpSuccessful,
      builder: (context, snapshot){
        if(!snapshot.hasData){
          if(snapshot.connectionState != ConnectionState.none){
            return Spinner();
          }
          return continueButton(signUpBloc);
        }

        if(snapshot.hasData){
          if(snapshot.data){
            // signUpBloc.outUser.listen((onData){
            //   //appBloc.appState.setUser(onData);
            //   Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(
            //         builder: (BuildContext context) => ThirdSignUpPage()
            //       )
            //   );
            // });
            return Container();
          }

          if(!snapshot.data){
            if(snapshot.connectionState == ConnectionState.done){
              return continueButton(signUpBloc);
            }
            return Spinner();
          }
        }

        return continueButton(signUpBloc);
      },
    );
  }
}


