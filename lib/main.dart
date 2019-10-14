import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reazzon/src/authentication/authentication.dart';
import 'package:reazzon/src/blocs/login_bloc.dart';
import 'package:reazzon/src/blocs/signup_bloc.dart';
import 'package:reazzon/src/pages/home_page.dart';

import 'src/authentication/authentication_repository.dart';
import 'src/pages/account_page.dart';

void main() async {
  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final FacebookLogin _facebookLogin = FacebookLogin();
  
  final AuthenticationRepository _authenticationRepository =
    AuthenticationRepository(facebookSignIn: _facebookLogin, firebaseAuth: _firebaseAuth, googleSignin: _googleSignIn);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthenticationBloc>(
        builder: (context) => AuthenticationBloc(_authenticationRepository)
        ..dispatch(AppStarted()),
      ),
      BlocProvider<LoginBloc>(
        builder: (context) => LoginBloc(_authenticationRepository)
      ),
      BlocProvider<SignUpBloc>(
        builder: (context) => SignUpBloc(_authenticationRepository),
      )
    ],
    child: ReazzonMainWidget(),
  ));
}

class ReazzonMainWidget extends StatelessWidget {

  final ThemeData theme = ThemeData(
    primarySwatch: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reazzon',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if(state is Authenticated){
            return AccountPage();
          }
          return HomePage();
        },
      ),
    );
  }
}