import 'package:bloc/bloc.dart';

class FilterBloc extends Bloc {
  List<FilterEntity> filterEntities;

  FilterBloc() {
    filterEntities = [];
  }

  @override
  // TODO: implement initialState
  get initialState => null;

  @override
  Stream mapEventToState(event) {
    // TODO: implement mapEventToState
    return null;
  }
}

class FilterEntity {
  String value;
  bool isSelected;

  FilterEntity(this.value, this.isSelected);
}
