class DayModel {
  final String day;
  bool selected;

  DayModel({required this.day, this.selected = false});

  @override
  String toString(){
    return day;
  }
}