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

  static List<Reazzon> allReazzons() {
    return  List<Reazzon>()
      ..addAll([
        Reazzon(1,"#Divorce"),
        Reazzon(2,"#Perfectionist"),
        Reazzon(3,"#Breakups"),
        Reazzon(4,"#Loneliness"),
        Reazzon(5,"#Grief"),
        Reazzon(6,"#WorkStress"),
        Reazzon(7,"#FinancialStress"),
        Reazzon(8,"#KidsCustody"),
        Reazzon(9,"#Bullying"),
        Reazzon(10,"#Insomnia"),
        Reazzon(11,"#MoodSwings"),
        Reazzon(12,"#Preasure\nToSucceed"),
        Reazzon(13,"#Anxiety"),
        Reazzon(14,"#Breakups"),
        Reazzon(15,"#Cheating"),
        Reazzon(16,"#SelfEsteem"),
        Reazzon(17,"#BodyImage"),
        Reazzon(18,"#Exercise\nMotivation")
      ]);
  }
}
