import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
}

class InitializedCredentialsSignUp extends SignupEvent {
  @override
  String toString() => 'InitializedCredentialsSignUp';  
}

class DeselectReazzon extends SignupEvent {
  @override
  String toString() => 'DeselectReazzon';  
}

class SelectReazzon extends SignupEvent {
  @override
  String toString() => 'SelectReazzon';  
}

class LoadReazzons extends SignupEvent {
  @override
  String toString() => 'LoadReazzons';  
}