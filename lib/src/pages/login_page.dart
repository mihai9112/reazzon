
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reazzon/src/helpers/field_focus.dart';
import 'package:flutter/widgets.dart';
import 'package:reazzon/src/helpers/spinner.dart';
import 'package:reazzon/src/login/login_bloc.dart';
import 'package:reazzon/src/login/login_event.dart';
import 'package:reazzon/src/login/login_state.dart';
import 'package:reazzon/src/pages/forgotten_password_page.dart';
import 'package:reazzon/src/pages/signup_second_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const _kFontFam = 'reazzon';
  static const IconData facebookIcon =
      const IconData(0xe801, fontFamily: _kFontFam);
  static const IconData googleIcon =
      const IconData(0xf1a0, fontFamily: _kFontFam);
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  void dispose() {
    _loginBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode _focusEmail = new FocusNode();
    FocusNode _focusPassword = new FocusNode();

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state){
        if(state is ProfileToBeUpdated){
          final route = MaterialPageRoute(builder: (_) => SecondSignUpPage());
          Navigator.of(context).push(route);
        }
      },
      child: Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.blueAccent),
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: Text("Login", style: TextStyle(color: Colors.blueAccent))
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: BlocListener<LoginBloc, LoginState>(
              listener: (context, state){
                if(state is LoginFailed){
                  Scaffold.of(context)
                    .showSnackBar(SnackBar(
                      key: Key("snack_bar_failure"),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Login Failure'), Icon(Icons.error)],
                      ),
                      backgroundColor: Colors.redAccent
                    ));
                }

                if (state is LoginLoading) {
                  Scaffold.of(context)
                    .showSnackBar(SnackBar(
                      key: Key("snack_bar_loading"),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Logging in...'), Spinner()],
                      ),
                      backgroundColor: Colors.blueAccent
                    ));
                }
              },
              child: Column(
                children: <Widget>[
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
                    margin:
                        const EdgeInsets.only(left: 40.0, right: 40.0, top: 5.0),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[Expanded(child: emailField(_loginBloc))],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0)
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
                    margin:
                        const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
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
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgottenPasswordPage()));
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
                          child: buildCredentialButtonWidget(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(8.0),
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.25)),
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
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.25)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: buildFacebookButtonWidget() 
                        ),
                        Expanded(
                          child: buildGoogleButtonWidget()
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ),
        )
      )
    );
  }

  Widget emailField(LoginBloc bloc) {
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

  Widget passwordField(LoginBloc bloc) {
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

  buildCredentialButtonWidget(){
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return StreamBuilder(
      stream: loginBloc.submitValid,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return RaisedButton(
          key: Key('credentials_button'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.blueAccent,
          elevation: 4.0,
          onPressed: () => snapshot.data ? null : loginBloc
            .add(InitializedCredentialsSignIn()),
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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

  buildGoogleButtonWidget(){
    return Container(
      margin: EdgeInsets.only(left: 8.0),
      alignment: Alignment.center,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.only(
          top: 15.0,
          bottom: 15.0,
        ),
        color: Color(0Xffdb3236),
        onPressed: () => BlocProvider.of<LoginBloc>(context)
          .add(InitializedGoogleSignIn()),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              googleIcon,
              color: Colors.white,
              size: 25.0,
            ),
            Text(
              "GOOGLE",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight:
                      FontWeight.bold),
            ),
          ],
        )
      ),
    );
  }

  buildFacebookButtonWidget(){
    return Container(
      margin: EdgeInsets.only(left: 8.0),
      alignment: Alignment.center,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.only(
          top: 15.0,
          bottom: 15.0,
        ),
        color: Color(0Xff3B5998),
        onPressed: () => BlocProvider.of<LoginBloc>(context)
          .add(InitializedFacebookSignIn()),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              facebookIcon,
              color: Colors.white,
              size: 25.0,
            ),
            Text(
              "FACEBOOK",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight:
                      FontWeight.bold),
            ),
          ],
        )
      ),
    );
  }
}
