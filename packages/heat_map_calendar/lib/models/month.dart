import 'day.dart';

class Month {
  int number;
  List<List<Day>> weeks = [];
  Month({
    this.number,
    this.weeks,
  });
}
