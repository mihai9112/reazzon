import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  @override
  ConversationsState get initialState => InitialConversationsState();

  @override
  Stream<ConversationsState> mapEventToState(
    ConversationsEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
