import 'bloc_provider.dart';

class FilterBloc extends BlocBase {
  List<FilterEntity> filterEntities;

  FilterBloc() {
    filterEntities = [];
  }

  @override
  void dispose() {}
}

class FilterEntity {
  String value;
  bool isSelected;

  FilterEntity(this.value, this.isSelected);
}
