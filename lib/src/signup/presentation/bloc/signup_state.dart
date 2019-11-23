import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  const SignupState();
}

class InitialSignupState extends SignupState {
  @override
  List<Object> get props => [];
}

class SignupSucceeded extends SignupState {
  @override
  String toString() => 'SignupSucceeded';  
}

class SignupFailed extends SignupState {
  @override
  String toString() => 'SignupFailed'; 
}

class ReazzonSelectionUpdated  extends SignupState {
  @override
  String toString() => 'ReazzonSelectionUpdated'; 
}

