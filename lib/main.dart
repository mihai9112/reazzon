import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reazzon/src/authentication/authentication.dart';
import 'package:reazzon/src/login/login_bloc.dart';
import 'package:reazzon/src/pages/home_page.dart';
import 'package:reazzon/src/user/user_repository.dart';

import 'src/authentication/authentication_repository.dart';
import 'src/pages/account_page.dart';
import 'src/signup/presentation/bloc/signup.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
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
  final UserRepository _userRepository = 
    UserRepository();
  final LoginBloc _loginBloc = LoginBloc(authenticationRepository: _authenticationRepository, userRepository: _userRepository);
  final AuthenticationBloc _authenticationBloc = 
    AuthenticationBloc(authenticationRepository: _authenticationRepository, loginBloc: _loginBloc);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthenticationBloc>(
        create: (context) => _authenticationBloc
        ..add(AppStarted()),
      ),
      BlocProvider<LoginBloc>(
        create: (context) => _loginBloc
      ),
      BlocProvider<SignupBloc>(
        create: (context) => SignupBloc(authenticationRepository: _authenticationRepository),
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
      )
    );
  }
}