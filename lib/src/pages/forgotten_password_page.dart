import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reazzon/src/helpers/field_focus.dart';
import 'package:reazzon/src/login/login_bloc.dart';
import 'package:reazzon/src/login/login_event.dart';
import 'package:reazzon/src/login/login_state.dart';

class ForgottenPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForgottenPasswordPageState();
}
  
class _ForgottenPasswordPageState extends State<ForgottenPasswordPage> {
  LoginBloc _loginBloc;

  @override
  void initState(){
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  void dispose(){
    _loginBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode _focusEmail =  FocusNode();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color:  Colors.blueAccent
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Forgotten password", style: TextStyle(color: Colors.blueAccent)),
      ),
      body:  SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state){
              if(state is ForgotPasswordSucceeded){
                Scaffold.of(context)
                    .showSnackBar(SnackBar(
                      key: Key("snack_bar_forgot_password_succeeded"),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Email sent successfully. \n Please follow instructions contained in the reset email.'), Icon(Icons.check_box)],
                      ),
                      backgroundColor: Colors.greenAccent
                    ));
              }

              if(state is ForgotPasswordFailed){
                Scaffold.of(context)
                    .showSnackBar(SnackBar(
                      key: Key("snack_bar_forgot_password_failure"),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Forgot password failed'), Icon(Icons.error)],
                      ),
                      backgroundColor: Colors.redAccent
                    ));
              }
            },
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
                            child: submitButton(_loginBloc),
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
      ),
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
          onPressed: () => snapshot.data ? null : loginBloc
            .add(InitializedForgottenPassword()),
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
          keyboardType: TextInputType.emailAddress,
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

