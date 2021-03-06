import 'package:mockito/mockito.dart';
import 'package:reazzon/src/helpers/cached_preferences.dart';

class CachedPreferencesMock extends Mock implements CachedPreferences{
  final bool mockedReturnResultSetString;
  CachedPreferencesMock({this.mockedReturnResultSetString});

  @override
  Future<bool> setString(String key, String value) => Future.value(mockedReturnResultSetString);
}