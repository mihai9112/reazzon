import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  @override
  AccountState get initialState => InitialAccountState();

  @override
  Stream<AccountState> mapEventToState(
    AccountEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
