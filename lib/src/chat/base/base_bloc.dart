import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';

import 'package:rxdart/rxdart.dart';

abstract class BLOCEvents extends Equatable {}

abstract class BLOCStates extends Equatable {}

abstract class BLOCBase<BLOCEvents, BLOCStates> extends BlocBase {
  BehaviorSubject<BLOCEvents> _eventStreamController =
      BehaviorSubject<BLOCEvents>();
  BehaviorSubject<BLOCStates> _stateStreamController =
      BehaviorSubject<BLOCStates>();

  // states stream getter
  Stream<BLOCStates> get stream => _stateStreamController.stream;

  BLOCBase() {
    _stateStreamController.add(initialState());
    _eventStreamController.listen((event) {
      mapEventToState(event)
          .listen((state) => _stateStreamController.add(state));
    });
  }

  void dispatch(BLOCEvents event) => _eventStreamController.add(event);

  BLOCStates initialState();

  Stream<BLOCStates> mapEventToState(BLOCEvents event);

  @override
  void dispose() {
    _eventStreamController.close();
    _stateStreamController.close();
  }
}
