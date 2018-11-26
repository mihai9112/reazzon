import 'package:flutter/material.dart';
import 'package:reazzon/src/helpers/fieldFocus.dart';
import 'package:reazzon/src/login/login_screen.dart';
import 'package:reazzon/src/signup/signUpBloc.dart';
import 'package:reazzon/src/signup/signUpProvider.dart';

class SignUpPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FocusNode _focusEmail = new FocusNode();
    FocusNode _focusPassword = new FocusNode();
    FocusNode _focusConfirmPassword = new FocusNode();

    final signUpBloc = SignUpProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blueAccent
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
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
                padding: const EdgeInsets.only(left: 0, right: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: emailField(signUpBloc))
                  ],
                ),
              ),
              Container(height: 20.0),
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
                    Expanded(child: passwordField(signUpBloc)),
                  ],
                ),
              ),
              Container(height: 20.0),
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
                    Expanded(child: confirmPasswordField(signUpBloc)),
                  ],
                ),
              ),
              Container(height: 24.0),
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: new FlatButton(
                      child: new Text(
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
                            builder: (context) => LoginScreen()) 
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
                      child: submitButton(signUpBloc),
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
  Widget submitButton(SignUpBloc bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.blueAccent,
          elevation: 4.0,
          onPressed: snapshot.hasData ? 
            () => bloc.submit()
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

  Widget emailField(SignUpBloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeEmail,
          keyboardType:  TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'you@example.com',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget passwordField(SignUpBloc bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        return TextField(
          obscureText: true,
          onChanged: bloc.changePassword,
          decoration: InputDecoration(
            hintText: 'password',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget confirmPasswordField(SignUpBloc bloc) {
    return StreamBuilder(
      stream: bloc.confirmPassword,
      builder: (context, snapshot) {
        return TextField(
          obscureText: true,
          onChanged: bloc.changeConfirmPassword,
          decoration: InputDecoration(
            hintText: 'password',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }
}