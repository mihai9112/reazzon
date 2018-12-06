import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/blocs/signup_bloc.dart';

class SecondSignUpPage  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);

    return Container(
      child: StreamBuilder(
        stream: appBloc.outCurrentUser,
        builder: (context, snapshot) {
          return Text(snapshot.data);
        },
      ),
    );
  }
}