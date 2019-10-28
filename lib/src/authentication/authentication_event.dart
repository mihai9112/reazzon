import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthenticationEvent {
  @override
  String toString() => 'LoggedIn';
}

class InitializedGoogleSignIn extends AuthenticationEvent {
  @override
  String toString() => 'InitializedGoogleSignIn';
}

class InitializedFacebookSignIn extends AuthenticationEvent {
  @override
  String toString() => 'InitializedFacebookSignIn';
}

class InitializedCredentialsSignIn extends AuthenticationEvent {
  final String validEmail;
  final String validPassword;

  InitializedCredentialsSignIn({this.validEmail, this.validPassword});

  @override
  String toString() => 'InitializedCredentialsSignIn';  
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}