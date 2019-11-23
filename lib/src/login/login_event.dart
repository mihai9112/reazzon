import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

class InitializedGoogleSignIn extends LoginEvent {
  @override
  String toString() => 'InitializedGoogleSignIn';
}

class InitializedFacebookSignIn extends LoginEvent {
  @override
  String toString() => 'InitializedFacebookSignIn';
}

class InitializedCredentialsSignIn extends LoginEvent {
  @override
  String toString() => 'InitializedCredentialsSignIn';  
}

class InitializedLogOut extends LoginEvent {
  @override
  String toString() => 'InitializedLogOut'; 
}

class InitializedForgottenPassword extends LoginEvent {
  @override
  String toString() => 'InitializedForgottenPassword'; 
}