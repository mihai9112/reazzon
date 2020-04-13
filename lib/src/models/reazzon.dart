class Reazzon {
  bool _isSelected;
  String _value;

  bool get isSelected => _isSelected;
  String get value => _value;

  Reazzon(this._value) {
    _isSelected = false;
  }

  void setSelection() {
    if (isSelected)
      _isSelected = false;
    else {
      _isSelected = true;
    }
  }

  static List<Reazzon> allReazzons() {
    return new List<Reazzon>()
      ..addAll([
        new Reazzon("#Divorce"),
        new Reazzon("#Perfectionist"),
        new Reazzon("#Breakups"),
        new Reazzon("#Loneliness"),
        new Reazzon("#Grief"),
        new Reazzon("#WorkStress"),
        new Reazzon("#FinancialStress"),
        new Reazzon("#KidsCustody"),
        new Reazzon("#Bullying"),
        new Reazzon("#Insomnia"),
        new Reazzon("#MoodSwings"),
        new Reazzon("#Preasure\nToSucceed"),
        new Reazzon("#Anxiety"),
        new Reazzon("#Breakups"),
        new Reazzon("#Cheating"),
        new Reazzon("#SelfEsteem"),
        new Reazzon("#BodyImage"),
        new Reazzon("#Exercise\nMotivation")
      ]);
  }
}
