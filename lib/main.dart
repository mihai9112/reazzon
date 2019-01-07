import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'src/app.dart';

Future<void> main() async {

  return runApp(
    BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: App()
    )
  );
}