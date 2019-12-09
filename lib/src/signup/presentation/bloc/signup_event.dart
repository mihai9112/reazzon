import 'package:equatable/equatable.dart';
import 'package:reazzon/src/models/reazzon.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class InitializedCredentialsSignUp extends SignupEvent {
  @override
  String toString() => 'InitializedCredentialsSignUp';  
}

class DeselectReazzon extends SignupEvent {
  final Reazzon reazzon;

  const DeselectReazzon(this.reazzon);

  @override
  List<Object> get props => [reazzon];

  @override
  String toString() => 'DeselectReazzon { reazzon : $reazzon }';  
}

class SelectReazzon extends SignupEvent {
  final Reazzon reazzon;

  const SelectReazzon(this.reazzon);

  @override
  List<Object> get props => [reazzon];

  @override
  String toString() => 'SelectReazzon { reazzon : $reazzon }';  
}

class LoadReazzons extends SignupEvent {
  @override
  String toString() => 'LoadReazzons';  
}