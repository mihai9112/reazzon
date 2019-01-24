import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/models/user.dart';
import 'package:rxdart/rxdart.dart';

class ApplicationBloc implements BlocBase {
  BehaviorSubject<List<String>> _availableReazzonsController = BehaviorSubject<List<String>>();
  BehaviorSubject<User> _currentUserController = BehaviorSubject<User>();

  Sink<User> get _inCurrentUser => _currentUserController.sink;
  Stream<User> get outCurrentUser => _currentUserController.stream;
  

  Sink<List<String>> get _inAvailableReazzons => _availableReazzonsController.sink;
  Stream<List<String>> get outAvailableReazzons => _availableReazzonsController.stream;

  ApplicationBloc(){
    _loadReazzons();
  }

  void setCurrentUser(FirebaseUser authenticatedUser)
  {
    if(authenticatedUser == null)
      throw new ArgumentError.notNull(authenticatedUser.runtimeType.toString());

    _inCurrentUser.add(new User(authenticatedUser));
  }

  void _loadReazzons()
  {
    var availableReazzons = new List<String>();
    availableReazzons.addAll([
        '#Divorce', '#Perfectionist', '#Breakups', '#Loneliness', '#Grief', 
        '#WorkStress', '#FinancialStress', '#KidsCustody', '#Bullying', '#Insomnia',
        '#ManagingEmotions', '#MoodSwings', '#Anxiety', '#Breakups', '#Cheating',
        '#SelfEsteem', '#BodyImage', '#ExerciseMotivation', '#PreasureToSucceed'
    ]);
    _inAvailableReazzons.add(availableReazzons);
  }

  @override
  void dispose() {
    _currentUserController.close();
    _availableReazzonsController?.close();
  }
}