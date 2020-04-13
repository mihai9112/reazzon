import 'package:mockito/mockito.dart';
import 'package:reazzon/src/user/user.dart';
import 'package:reazzon/src/user/user_repository.dart';

class UserRepositoryMock extends Mock implements UserRepository{}
class UserMock extends Mock implements User{}