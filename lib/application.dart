import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/blocs/login_bloc.dart';
import 'package:reazzon/src/blocs/signup_bloc.dart';
import 'package:reazzon/src/pages/home_%20router.dart';
import 'package:reazzon/src/pages/signup_page.dart';
import 'package:reazzon/src/repositories/authentication_repository.dart';

class Application extends StatelessWidget {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final FacebookLogin _facebookLogin = FacebookLogin();
  
  @override
  Widget build(BuildContext context) {
    AuthenticationRepository _authenticationRepository = AuthenticationRepository(
          facebookSignIn: _facebookLogin, 
          firebaseAuth: _firebaseAuth, 
          googleSignin: _googleSignIn);
          
    return BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: BlocProvider<LoginBloc>(
        bloc: LoginBloc(_authenticationRepository),
        child: BlocProvider<SignUpBloc>(
          bloc: SignUpBloc(_authenticationRepository),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Reazzon',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: HomeRouter(),
            routes: {
              '/register': (BuildContext context) => SignUpPage(),
          },
        ))
      )
    );
  }
}
