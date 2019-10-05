import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

abstract class BlocEvents extends Equatable {}

abstract class BlocStates extends Equatable {}

abstract class BlocEventStateBase<BlocEvents, BlocStates> extends BlocBase {
  PublishSubject<BlocEvents> _eventController = PublishSubject<BlocEvents>();
  BehaviorSubject<BlocStates> _stateController = BehaviorSubject<BlocStates>();

  /// To be invoked to emit an event
  Function(BlocEvents) get dispatch => _eventController.sink.add;

  /// Current/New state
  Stream<BlocStates> get stream => _stateController.stream;

  /// External processing of the event
  Stream<BlocStates> mapEventToState(BlocEvents event, BlocStates currentState);

  /// initialState
  BlocStates initialState();

  // Constructor
  BlocEventStateBase() {
    // initialState is added initially without any dispatch
    _stateController.sink.add(initialState());

    // For each received event, we invoke the [eventHandler or mapEventToState] and
    // emit any resulting newState
    _eventController.listen((BlocEvents event) {
      BlocStates currentState = _stateController.value ?? initialState;
      mapEventToState(event, currentState).forEach((BlocStates newState) {
        _stateController.sink.add(newState);
      });
    });
  }

  @override
  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}
