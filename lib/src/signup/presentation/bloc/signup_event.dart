import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
}

class InitializedCredentialsSignUp extends SignupEvent {
  @override
  String toString() => 'InitializedCredentialsSignUp';  
}


class ReazzonDeselected extends SignupEvent {
  @override
  String toString() => 'ReazzonDeselected';  
}

class ReazzonSelected extends SignupEvent {
  @override
  String toString() => 'ReazzonSelected';  
}