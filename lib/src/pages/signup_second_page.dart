import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';

class SecondSignUpPage  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);

    return Container(
      child: StreamBuilder(
        stream: appBloc.outCurrentUser,
        builder: (context, AsyncSnapshot<FirebaseUser>snapshot) {
          return Text(snapshot.hasData ? snapshot.data.uid : "");
        },
      ),
    );
  }
}