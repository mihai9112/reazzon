import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appBloc = BlocProvider.of<ApplicationBloc>(context);
    var stringBuilder = new StringBuffer();

    _appBloc.currentUser.selectedReazzons.forEach((f) {
      stringBuilder.write(f.value);
      stringBuilder.write("; ");
    });

    return Column(
      children: <Widget>[
        Text(_appBloc.currentUser.firstName),
        Text(_appBloc.currentUser.lastName),
        Text(_appBloc.currentUser.userName),
        Text(stringBuilder.toString())
      ],
    );
  }
}