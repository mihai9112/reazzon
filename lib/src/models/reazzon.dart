class Reazzon {
  bool _isSelected;
  String _value;

  bool get isSelected => _isSelected;
  String get value => _value;

  Reazzon(this._value){
    _isSelected = false;
  }

  void setSelection()
  {
    if(isSelected)
      _isSelected = false;
    else {
      _isSelected = true;
    }
  }
}