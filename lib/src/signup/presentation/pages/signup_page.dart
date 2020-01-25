import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reazzon/src/helpers/field_focus.dart';
import 'package:reazzon/src/helpers/spinner.dart';
import 'package:reazzon/src/login/login_page.dart';
import 'package:reazzon/src/signup/presentation/bloc/signup.dart';

import 'signup_continue_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  SignupBloc _signupBloc;

  @override
  void initState() {
    super.initState();
    _signupBloc = BlocProvider.of<SignupBloc>(context);
  }

  @override
  void dispose() {
    _signupBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode _focusEmail = new FocusNode();
    FocusNode _focusPassword = new FocusNode();
    FocusNode _focusConfirmPassword = new FocusNode();
    
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state){
        if(state is SignupSucceeded){
          final route = MaterialPageRoute(builder: (_) => SignupContinuePage());
          Navigator.of(context).push(route);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.blueAccent),
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text("Signup", style: TextStyle(color: Colors.blueAccent))
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: BlocListener<SignupBloc, SignupState>(
              listener: (context, state){
                if(state is SignupFailed){
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      key: Key("snack_bar_failure"),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Sign up failure'), Icon(Icons.error)],
                      ),
                      backgroundColor: Colors.redAccent
                  ));
                }
                if(state is SignupLoading){
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Registering...'),
                            Spinner(),
                          ],
                        ),
                      ),
                    );
                }
              },
              child: Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.all(50.0),
                  child: Center(
                    child: Icon(
                      Icons.developer_board,
                      color: Colors.blueAccent,
                      size: 50.0,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: <Widget>[
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
                      margin: const EdgeInsets.only(
                          left: 40.0, right: 40.0),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(child: emailField(_signupBloc))
                        ],
                      ),
                    )
                  ]),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0)
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
                        margin: const EdgeInsets.only(
                            left: 40.0, right: 40.0),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(child: passwordField(_signupBloc)),
                          ],
                        ),
                      )
                    ]),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0)
                  ),
                  Column(children: <Widget>[
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
                    margin:
                        const EdgeInsets.only(left: 40.0, right: 40.0),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(child: confirmPasswordField(_signupBloc)),
                      ],
                    ),
                  ),
                ]),
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
                                  builder: (context) => LoginPage()));
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                  alignment: Alignment.center,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: buildButton(_signupBloc),
                      ),
                    ],
                  ),
                )
              ])
            ),
          ),
        )
      )
    );
  }

  buildButton(SignupBloc signupBloc){
    return StreamBuilder(
      stream: signupBloc.submitValid,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return RaisedButton(
          key: Key('signup_button'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.blueAccent,
          elevation: 4.0,
          onPressed: snapshot.hasData ? () => signupBloc
            .add(InitializedCredentialsSignUp()) : null,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "SIGN UP",
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

  Widget emailField(SignupBloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          key: Key('email_field'),
          onChanged: bloc.changeEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'you@example.com',
            errorText: snapshot.error,
            errorStyle: TextStyle(fontSize: 15.0)),
        );
      },
    );
  }

  Widget passwordField(SignupBloc bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        return TextField(
          key: Key('password_field'),
          obscureText: true,
          onChanged: bloc.changePassword,
          decoration: InputDecoration(
            hintText: 'password',
            errorText: snapshot.error,
            errorStyle: TextStyle(fontSize: 15.0)),
        );
      },
    );
  }

  Widget confirmPasswordField(SignupBloc bloc) {
    return StreamBuilder(
      stream: bloc.confirmPassword,
      builder: (context, snapshot) {
        return TextField(
          obscureText: true,
          onChanged: bloc.changeConfirmPassword,
          decoration: InputDecoration(
            hintText: 'password',
            errorText: snapshot.error,
            errorStyle: TextStyle(fontSize: 15.0)),
        );
      },
    );
  }
}