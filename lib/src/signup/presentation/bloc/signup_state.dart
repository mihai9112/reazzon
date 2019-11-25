import 'package:equatable/equatable.dart';
import 'package:reazzon/src/models/reazzon.dart';

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

class ReazzonSelectionUpdated extends SignupState {
  @override
  String toString() => 'ReazzonSelectionUpdated'; 
}

class ReazzonsLoaded extends SignupState {
  final List<Reazzon> reazzons;

  const ReazzonsLoaded([this.reazzons = const []]);

  @override
  List<Object> get props => [reazzons];
  
  @override
  String toString() => 'ReazzonLoaded { reazzons: $reazzons }'; 
}

class ReazzonNotLoaded extends SignupState {
  @override
  String toString() => 'ReazzonNotLoaded'; 
}

