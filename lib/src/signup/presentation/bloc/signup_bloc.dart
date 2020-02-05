import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:reazzon/src/authentication/authentication_repository.dart';
import 'package:reazzon/src/domain/validators.dart';
import 'package:reazzon/src/helpers/cached_preferences.dart';
import 'package:reazzon/src/helpers/constants.dart';
import 'package:reazzon/src/models/reazzon.dart';
import 'package:reazzon/src/user/user.dart';
import 'package:reazzon/src/user/user_repository.dart';
import 'package:rxdart/rxdart.dart';
import './signup.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> with Validators {
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _confirmPasswordController = BehaviorSubject<String>();
  final _usernameController = BehaviorSubject<String>();
  final _validationController = BehaviorSubject<bool>();
  Set<Reazzon> _selectedReazzons = Set<Reazzon>();

  SignupBloc({
    @required this.authenticationRepository,
    @required this.userRepository
  })
  : assert(authenticationRepository != null),
    assert(userRepository != null){}

  Stream<String> get email =>
    _emailController.stream.transform(validateEmail);
  Stream<String> get password =>
    _passwordController.stream.transform(validatePassword);
  Stream<String> get confirmPassword => _confirmPasswordController.stream
      .transform(validatePassword)
      .doOnData((String c) {
    if (0 != _passwordController.value.compareTo(c)) {
      _confirmPasswordController.addError("Passwords do not match");
    }
  });
  Stream<bool> get submitValid => Observable.combineLatest3(
    email, password, confirmPassword, (e, p, cp) => true);
  Stream<String> get username => 
    _usernameController.stream.transform(validateUsername);
  Stream<bool> get completeValid => Observable.combineLatest2(username, _validationController.stream, (u, vc) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeConfirmPassword => _confirmPasswordController.sink.add;
  Function(String) get changeUsername => _usernameController.sink.add;
  
  @override
  SignupState get initialState => InitialSignupState();

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if(event is InitializedCredentialsSignUp){
      yield* _mapCredentialsSigningUpToState();
    }

    if(event is LoadReazzons){
      yield ReazzonsLoaded(_allReazzons());
    }

    if(event is SelectReazzon){
      yield* _mapReazzonSelected(event);
    }

    if(event is DeselectReazzon){
      yield* _mapReazzonDeselected(event);
    }

    if(event is CompleteSignup){
      yield* _mapCompletedSignup();
    }
  }

  Stream<SignupState> _mapCredentialsSigningUpToState() async* {
    yield SignupLoading();
    try {
      final firebaseUser = await authenticationRepository.signUpWithCredentials(
        _emailController.value,
        _passwordController.value
      );

      final savedUser = await userRepository.saveDetailsFromProvider(firebaseUser);

      if(savedUser != null) {
        add(LoadReazzons());
        yield SignupSucceeded();
      }
      else {
        yield SignupFailed();
      }
    } 
    catch (_, stacktrace) {
      //TODO: log stacktrace;
      yield SignupFailed();
    }
  }

  Stream<SignupState> _mapReazzonSelected(SelectReazzon event) async* {
    if(state is ReazzonsLoaded){
      var reazzonsToWork = (state as ReazzonsLoaded).reazzons;

      if(reazzonsToWork.where((r) => r.isSelected == true).length == 3){
        yield ReazzonLimitSelected();
      }
      else {
        reazzonsToWork = reazzonsToWork.map((reazzon) {
          return reazzon.id == event.reazzon.id ? Reazzon.selected(reazzon) : reazzon;
        }).toList();
        _selectedReazzons.clear();
        _selectedReazzons.addAll(reazzonsToWork.where((r) => r.isSelected == true));
        _validationController.sink.add(true);
      }
        
      yield ReazzonsLoaded(reazzonsToWork);
    }
  }

  Stream<SignupState> _mapReazzonDeselected(DeselectReazzon event) async* {
    if(state is ReazzonsLoaded){
      final List<Reazzon> updatedReazzons = (state as ReazzonsLoaded).reazzons.map((reazzon) {
        return reazzon.id == event.reazzon.id ? Reazzon(reazzon.id, reazzon.value) : reazzon;
      }).toList();
      _selectedReazzons.clear();
      _selectedReazzons.addAll(updatedReazzons.where((r) => r.isSelected == true));
      yield ReazzonsLoaded(updatedReazzons);

      if(updatedReazzons.where((reazzon) => reazzon.isSelected == true).length == 0){
        _validationController.sink.addError("Please select at least one #reazzon");
      }
    }
  }

  Stream<SignupState> _mapCompletedSignup() async* {
    yield SignupLoading();
    try {
      final updatedUser = User(
        documentId: SharedObjects.prefs.getString(Constants.sessionUid),
        name: SharedObjects.prefs.getString(Constants.sessionDisplayName),
        email: SharedObjects.prefs.getString(Constants.sessionEmail),
        reazzons: _selectedReazzons,
        userName: _usernameController.value
      );
      await userRepository.updateDetails(updatedUser);
    } 
    catch (_, stacktrace) {
      //TODO: log stacktrace;
      yield SignupFailed();
    }
  }

  void dispose(){
    _emailController.close();
    _passwordController.close();
    _confirmPasswordController.close();
    _usernameController.close();
    _validationController.close();
  }

  static List<Reazzon> _allReazzons() {
    return List<Reazzon>()
      ..addAll([
        Reazzon(1,"#Divorce"),
        Reazzon(2,"#Perfectionist"),
        Reazzon(3,"#Breakups"),
        Reazzon(4,"#Loneliness"),
        Reazzon(5,"#Grief"),
        Reazzon(6,"#WorkStress"),
        Reazzon(7,"#FinancialStress"),
        Reazzon(8,"#KidsCustody"),
        Reazzon(9,"#Bullying"),
        Reazzon(10,"#Insomnia"),
        Reazzon(11,"#MoodSwings"),
        Reazzon(12,"#Preasure\nToSucceed"),
        Reazzon(13,"#Anxiety"),
        Reazzon(14,"#Breakups"),
        Reazzon(15,"#Cheating"),
        Reazzon(16,"#SelfEsteem"),
        Reazzon(17,"#BodyImage"),
        Reazzon(18,"#Exercise\nMotivation")
      ]);
  }
}
