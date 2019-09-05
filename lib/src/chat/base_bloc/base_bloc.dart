import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';

import 'package:rxdart/rxdart.dart';

abstract class BlocEvents extends Equatable {}

abstract class BlocStates extends Equatable {}

abstract class BlocEventStateBase<BlocEvents, BlocStates> extends BlocBase {
  BehaviorSubject<BlocEvents> _eventStreamController =
      BehaviorSubject<BlocEvents>();
  BehaviorSubject<BlocStates> _stateStreamController =
      BehaviorSubject<BlocStates>();

  // states stream getter
  Stream<BlocStates> get stream => _stateStreamController.stream;

  BlocEventStateBase() {
    _stateStreamController.add(initialState());
    _eventStreamController.listen((event) {
      mapEventToState(event)
          .listen((state) => _stateStreamController.add(state));
    });
  }

  void dispatch(BlocEvents event) => _eventStreamController.add(event);

  BlocStates initialState();

  Stream<BlocStates> mapEventToState(BlocEvents event);

  @override
  void dispose() {
    _eventStreamController.close();
    _stateStreamController.close();
  }
}
