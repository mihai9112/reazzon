import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/models/reazzon.dart';
import 'package:reazzon/src/models/user.dart';
import 'package:rxdart/rxdart.dart';

class ApplicationBloc implements BlocBase {
  User _currentUser;
  User get currentUser => _currentUser;

  BehaviorSubject<List<Reazzon>> _availableReazzonsController = BehaviorSubject<List<Reazzon>>();

  Sink<List<Reazzon>> get _inAvailableReazzons => _availableReazzonsController.sink;
  Stream<List<Reazzon>> get outAvailableReazzons => _availableReazzonsController.stream;

  ApplicationBloc(){
    _loadReazzons();
  }

  void setCurrentUser(FirebaseUser authenticatedUser)
  {
    if(authenticatedUser == null)
      throw new ArgumentError.notNull(authenticatedUser.runtimeType.toString());
    
    _currentUser = new User(authenticatedUser);
  }

  void _loadReazzons()
  {
    var availableReazzons = new List<Reazzon>();
    availableReazzons.addAll([
      new Reazzon("#Divorce"), new Reazzon("#Perfectionist"),
      new Reazzon("#Breakups"), new Reazzon("#Loneliness"),
      new Reazzon("#Grief"), new Reazzon("#WorkStress"),
      new Reazzon("#FinancialStress"), new Reazzon("#KidsCustody"),
      new Reazzon("#Bullying"), new Reazzon("#Insomnia"),
      new Reazzon("#MoodSwings"), new Reazzon("#Preasure\nToSucceed"),
      new Reazzon("#Anxiety"), new Reazzon("#Breakups"),
      new Reazzon("#Cheating"), new Reazzon("#SelfEsteem"),
      new Reazzon("#BodyImage"), new Reazzon("#Exercise\nMotivation")
    ]);
    _inAvailableReazzons.add(availableReazzons);
  }

  void updateReazzons(List<Reazzon> reazzons){
    _inAvailableReazzons.add(reazzons);
  }

  @override
  void dispose() {
    _availableReazzonsController?.close();
  }
}