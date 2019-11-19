import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  LoginState([List props = const []]) : super(props);
}

class LoginInitial extends LoginState {
  @override
  String toString() => 'LoginInitial';
}

class LoginLoading extends LoginState {
  @override
  String toString() => 'LoginLoading';
}

class LoginFailed extends LoginState {
  final String error;
  LoginFailed({this.error});

  @override
  String toString() => 'LoginFailure';
}

class LoginSucceeded extends LoginState {
  @override
  String toString() => 'LoginSucceeded';
}

class ProfileToBeUpdated extends LoginState {
  @override
  String toString() => 'ProfileToBeUpdated';
}