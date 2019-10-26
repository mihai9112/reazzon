import 'package:mockito/mockito.dart';
import 'package:reazzon/src/chat/chat_bloc/chat_bloc.dart';
import 'package:reazzon/src/chat/repository/chat_repository.dart';

class ChatRepositoryMock extends Mock implements ChatRepository {}

class ChatBlocMock extends Mock implements ChatBloc {
  ChatRepository chatRepository;

  ChatBlocMock({this.chatRepository});
}