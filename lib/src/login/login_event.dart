import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

class LoginButtonPressed extends LoginEvent {

  @override
  String toString() => 'LoginButtonPressed';
}