import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/models/app_state.dart';

class ApplicationBloc implements BlocBase {
  AppState _appState;

  AppState get appState => _appState;

  ApplicationBloc() {
    _appState = new AppState();
  }

  @override
  void dispose() {}
}
