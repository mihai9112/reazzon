class Reazzon {
  bool _isSelected;
  String _value;

  bool get isSelected => _isSelected;
  String get value => _value;

  Reazzon(this._value){
    _isSelected = false;
  }

  void select(){
    if(!_isSelected)
      _isSelected = true;
  }

  void deselect(){
    if(_isSelected){
      _isSelected = false;
    }
  }
}