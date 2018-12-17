import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/blocs/signup_bloc.dart';
import 'package:reazzon/src/helpers/fieldFocus.dart';

class SecondSignUpPage  extends StatelessWidget {
  SecondSignUpPage({
    @required this.signUpBloc,
  });

  final SignUpBloc signUpBloc;

  @override
  Widget build(BuildContext context) {
    FocusNode _firstName = new FocusNode();
    FocusNode _lastName = new FocusNode();

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
              Text(_appBloc.reazzonUser.userId),
              Container(
                padding: EdgeInsets.all(55.0),
              ),
              Row(
                children: <Widget>[
                  EnsureVisibleWhenFocused(
                    focusNode: _firstName,
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
                      child: lastNameField(signUpBloc)
                    )
                  ],
                ),
              ),
              Container(height: 20.0),
              Row(
                children: <Widget>[
                  EnsureVisibleWhenFocused(
                    focusNode: _lastName,
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
                      child: lastNameField(signUpBloc)
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
                      child: continueButton(signUpBloc, _appBloc),
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

  Widget lastNameField(SignUpBloc bloc) {
    return StreamBuilder(
      stream: bloc.outFirstName,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.inFirstName,
          decoration: InputDecoration(
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget firstNameField(SignUpBloc bloc) {
    return StreamBuilder(
      stream: bloc.outLastName,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.inLastName,
          decoration: InputDecoration(
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget continueButton(SignUpBloc bloc, ApplicationBloc appBloc) {
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
}