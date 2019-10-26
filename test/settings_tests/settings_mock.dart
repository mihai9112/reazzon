import 'package:mockito/mockito.dart';
import 'package:reazzon/src/settings/setting_bloc.dart';
import 'package:reazzon/src/settings/setting_repository.dart';

class SettingsRepositoryMock extends Mock implements SettingRepository {}

class SettingsBlocMock extends Mock implements SettingsBloc {
  SettingsRepositoryMock settingsRepository;

  SettingsBlocMock({this.settingsRepository});
}