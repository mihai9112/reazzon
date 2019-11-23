import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  const SignupState();
}

class InitialSignupState extends SignupState {
  @override
  List<Object> get props => [];
}
