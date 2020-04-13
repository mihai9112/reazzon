class Reazzon {
  int _id;
  bool _isSelected;
  String _value;

  bool get isSelected => _isSelected;
  String get value => _value;
  int get id => _id;

  Reazzon(
    this._id,
    this._value
  ) {
    _isSelected = false;
  }

  Reazzon.selected(Reazzon reazzon){
    _id = reazzon.id;
    _value = reazzon.value;
    _isSelected = true;
  }

  Reazzon.fromJson(Map<String, dynamic> json)
    : _id = json['id'],
      _value = json['value'],
      _isSelected = true;

  Map<String, dynamic> toJson(){
    return {
      "id": _id,
      "value": _value
    };
  }
}
