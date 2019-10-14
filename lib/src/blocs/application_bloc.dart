
import 'dart:async';

import 'package:reazzon/src/models/app_state.dart';
import 'package:bloc/bloc.dart';

class ApplicationBloc extends Bloc {
  AppState _appState;

  AppState get appState => _appState;

  ApplicationBloc() {
    _appState = new AppState();
  }

  @override
  // TODO: implement initialState
  get initialState => null;

  @override
  Stream mapEventToState(event) {
    // TODO: implement mapEventToState
    return null;
  }
}
