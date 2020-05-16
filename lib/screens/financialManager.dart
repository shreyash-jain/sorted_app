import 'dart:async';
import 'dart:convert';
import 'package:notes/data/date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/data/custom_slider_thumb_circle_text.dart';
import 'package:flutter/painting.dart';
import 'package:notes/components/cards2.dart';
import 'package:notes/components/faderoute.dart';
import 'package:notes/data/eCat.dart';
import 'package:notes/data/expense.dart';
import 'package:notes/data/friend.dart';
import 'package:notes/data/models.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/data/rEvent.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/screens/Display_questions.dart';
import 'package:notes/screens/ListQuestion.dart';
import 'package:notes/screens/dashboard.dart';
import 'package:notes/screens/expenseEdit.dart';
import 'package:notes/screens/richedit.dart';
import 'package:notes/screens/view.dart';
import 'package:notes/services/database.dart';
import 'settings.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:notes/bloc/todo_bloc.dart';
import 'package:notes/components/QuestionCards.dart';
import 'package:notes/data/custom_slider_thumb_circle.dart';
import 'package:notes/components/SecondPage.dart';
import 'package:notes/components/faderoute.dart';
import 'package:notes/data/date.dart';
import 'package:notes/data/event.dart';
import 'package:notes/data/activity.dart';
import 'package:notes/data/user_activity.dart';
import 'package:notes/data/activityLog.dart';
import 'package:notes/data/models.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/data/question.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/data/todo.dart';
import 'package:notes/data/animated-wave.dart';
import 'package:notes/data/animated-background.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/screens/Display_questions.dart';
import 'package:notes/screens/ListQuestion.dart';
import 'package:notes/screens/Survey_start.dart';
import 'package:notes/screens/addEvent.dart';
import 'package:notes/screens/dashboard.dart';
import 'package:notes/screens/expenseEdit.dart';
import 'package:notes/screens/richedit.dart';
import 'package:notes/screens/view.dart';
import 'package:notes/services/database.dart';
import 'package:notes/services/local_notications_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:sqflite_porter/utils/csv_utils.dart';
import 'settings.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../components/cards.dart';
import '../components/FadeAnimation.dart';
import '../components/BluePainter.dart';

Color primaryColor = Color.fromARGB(255, 58, 149, 255);
final int id = 0;

class FinanceView extends StatefulWidget {
  Function(Brightness brightness) changeTheme;

  FinanceView({
    Key key,
    this.title,
    Function(Brightness brightness) changeTheme,
  }) : super(key: key) {
    this.changeTheme = changeTheme;
  }

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FinanceView> {
  List<NoteBookModel> notebookList = [];
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    Color.fromARGB(255, 58, 149, 255),
  ];
  bool isFlagOn = false;
  int _radioValue1 = 0;
  int current_position_month = 11;
  static var formatter = new DateFormat('d MMMM, EEE');
  static DateTime TofillDate = DateTime.now();
  String formatted = formatter.format(TofillDate);
  bool headerShouldHide = false;
  var formatter_only_month = new DateFormat('MMM');

  List<NotesModel> notesList = [];
  TextEditingController searchController = TextEditingController();
  ThemeData theme = appThemeLight;
  DateTime selectedDate = DateTime.now();
  List<FlSpot> to_show_month_graph = [FlSpot(0, 0)];
  List<FlSpot> one_month_graph = [FlSpot(0, 0)];
  List<FlSpot> two_month_graph = [FlSpot(0, 0)];
  List<FlSpot> three_month_graph = [FlSpot(0, 0)];

  int swich_month_graph = 3;
  String search_text = "Search by month";
  String list_type_text = "All";
  double max_all_cat = 1;
  double max_past_week_cat = 1;
  double max_past_month_cat = 1;
  double max_all_friends = 1;
  double max_all_months = 1;

  double sum_all_expense = 0;
  double last_month_expense = 0;
  double last_week_expense = 0;
  List<EventModel> eventsListtoday = [];
  bool isSearchEmpty = true;
  DateTime today = DateTime.now();
  List<DateTime> pastMonths = [];
  int select_list_type = 1;
  int search_type = 1;
  bool search = false;
  bool select_list = false;
  List<CatModel> categories = [];
  var formatter_date_Expense = new DateFormat('d MMM, h:mm a');
  var formatter_date = new DateFormat('dd-MM-yyyy');
  var formatter_date_builder = new DateFormat('y\nMMM');
  HashMap hashMap_today = new HashMap<int, List<Todo>>();
  static ScrollController _controller =
      ScrollController(initialScrollOffset: 700);
  List<Todo> TodaytodoList = [];
  List<FriendModel> friends_list = [];
  List<UserAModel> AllUserActivityList = [];

  List<ExpenseModel> to_show = [];
  var all_categories;
  var last_month_categories;
  var last_week_categories;
  List<ExpenseModel> last_week = [];
  List<ExpenseModel> last_month = [];
  var all_months;
  List<ExpenseModel> all_expense;
  var all_friends;
  int chosen_expense_cat = -1;

  List<double> all_expense_cat_total;
  List<double> last_month_cat_total;
  List<double> last_week_cat_total;
  List<double> all_friends_total;
  List<double> months_total;
  int chosen_friend = -1;
  final Duration animDuration = const Duration(milliseconds: 250);
  RangeValues _values = new RangeValues(0, 100000);
  RangeLabels _labels = new RangeLabels('0', '100000');

  int current_position_expense_list = -1;

  int touchedIndex;
  Color barBackgroundColor = const Color(0xff72d8bf);

  @override
  void initState() {
    super.initState();
    get_category_List();
    get_UserActivityModel();

    get_past_months();
  }

  get_friends_List() async {
    var fetchedDate = await NotesDatabaseService.db.getFriendsDB();
    setState(() {
      friends_list = fetchedDate;
    });
    all_friends = new List.generate(friends_list.length + 1, (i) => []);
    all_friends_total =
        new List<double>.generate(friends_list.length + 1, (i) => 0);

    var fetched_all_events = await NotesDatabaseService.db.getExpensesFromDB();
    setState(() {
      all_expense = fetched_all_events;
      to_show = all_expense;
      print("karo print" + to_show.length.toString());
    });

    DateTime lastweek = DateTime.now().subtract(Duration(days: 8));
    DateTime lastmonth = DateTime.now().subtract(Duration(days: 31));

    sum_all_expense = 0;
    last_month_expense = 0;
    last_week_expense = 0;
    for (int i = 0; i < all_expense.length; i++) {
      sum_all_expense += all_expense[i].money;
      print("cat batao " + all_expense[i].cat_id.toString());

      for (int j = 1; j < categories.length + 1; j++) {
        if (all_expense[i].cat_id == j) {
          all_categories[j].add(all_expense[i]);
          all_expense_cat_total[j] += all_expense[i].money;
          if (all_expense_cat_total[j] > max_all_cat)
            max_all_cat = all_expense_cat_total[j];

          break;
        }
      }
      for (int j = 1; j < friends_list.length + 1; j++) {
        if (all_expense[i].friend_id == j) {
          all_friends[j].add(all_expense[i]);
          all_friends_total[j] += all_expense[i].money;
          if (all_friends_total[j] > max_all_friends)
            max_all_friends = all_friends_total[j];
          break;
        }
      }

      if (all_expense[i].date.isAfter(lastweek) &&
          all_expense[i].date.isBefore(DateTime.now())) {
        last_week.add(all_expense[i]);
        last_week_expense += all_expense[i].money;

        for (int j = 1; j < categories.length + 1; j++) {
          if (all_expense[i].cat_id == j) {
            last_week_categories[j].add(all_expense[i]);

            last_week_cat_total[j] += all_expense[i].money;
            if (last_week_cat_total[j] > max_past_week_cat)
              max_past_week_cat = last_week_cat_total[j];
            break;
          }
        }
      }

      if (all_expense[i].date.isAfter(lastmonth) &&
          all_expense[i].date.isBefore(DateTime.now())) {
        last_month.add(all_expense[i]);
        last_month_expense += all_expense[i].money;

        for (int j = 1; j < categories.length + 1; j++) {
          if (all_expense[i].cat_id == j) {
            last_month_categories[j].add(all_expense[i]);
            last_month_cat_total[j] += all_expense[i].money;
            if (last_month_cat_total[j] > max_past_month_cat)
              max_past_month_cat = last_month_cat_total[j];
            break;
          }
        }
      }

      DateTime end = DateTime.now();
      DateTime start;
      int k = 12;
      while (k > 0) {
        k = k - 1;
        start = pastMonths[k];
        if (all_expense[i].date.isAfter(start) &&
            all_expense[i].date.isBefore(end)) {
          print(k);
          all_months[k + 1].add(all_expense[i]);
          months_total[k + 1] += all_expense[i].money;
          if (months_total[k + 1] > max_all_months)
            max_all_months = months_total[k + 1];
          break;
        }
        end = start;
      }
    }

    print(last_month.length);
    for (int i = 0; i < 4; i++) {
      print(i.toString() +
          " " +
          months_total[i + 1].toString() +
          " " +
          max_all_months.toString());
      one_month_graph.add(new FlSpot(
          i.toDouble(), months_total[i + 1] / (max_all_months * 1.2)));
    }
    for (int i = 4; i < 8; i++) {
      print(i.toString() +
          " " +
          months_total[i + 1].toString() +
          " " +
          max_all_months.toString());
      two_month_graph.add(new FlSpot(
          i - 4.toDouble(), months_total[i + 1] / (max_all_months * 1.2)));
    }
    for (int i = 8; i < 12; i++) {
      print(i.toString() +
          " " +
          months_total[i + 1].toString() +
          " " +
          max_all_months.toString());
      three_month_graph.add(new FlSpot(
          i - 8.toDouble(), months_total[i + 1] / (max_all_months * 1.2)));
    }

    setState(() {
      to_show_month_graph = three_month_graph;
    });
  }

  get_category_List() async {
    var fetchedDate = await NotesDatabaseService.db.getCatsFromDB();
    setState(() {
      categories = fetchedDate;
    });
    all_expense_cat_total =
        new List<double>.generate(categories.length + 1, (i) => 0);
    last_week_cat_total =
        new List<double>.generate(categories.length + 1, (i) => 0);
    last_month_cat_total =
        new List<double>.generate(categories.length + 1, (i) => 0);
    all_categories = new List.generate(categories.length + 1, (i) => []);
    last_month_categories = new List.generate(categories.length + 1, (i) => []);
    last_week_categories = new List.generate(categories.length + 1, (i) => []);
    months_total = new List.generate(13, (i) => 0);
    print("cate " + categories.length.toString());
    all_months = new List.generate(13, (i) => []);
    get_friends_List();
  }

  get_past_months() {
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, 1);

    pastMonths.add(today);
    int c_month = today.month;

    while (c_month != 0) {
      c_month--;
      if (c_month == 0) break;
      DateTime last_month = DateTime(today.year, c_month, 1);

      pastMonths.add(last_month);
    }
    c_month = 13;
    while (c_month - today.month > 1) {
      c_month--;
      if (c_month == 0) break;
      DateTime last_month = DateTime(today.year - 1, c_month, 1);

      pastMonths.add(last_month);
    }

    print(pastMonths.length);
    pastMonths = pastMonths.reversed.toList();

    for (int i = 0; i < pastMonths.length; i++) {
      print(
          pastMonths[i].month.toString() + " " + pastMonths[i].year.toString());
    }
  }

  get_UserActivityModel() async {
    var fetchedDate =
        await NotesDatabaseService.db.getUserActiviyAfterFromDB(6);
    setState(() {
      AllUserActivityList = fetchedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    barBackgroundColor = Theme.of(context).dividerColor;
    if (Theme.of(context).brightness == Brightness.dark) {
      barBackgroundColor = Theme.of(context).cardColor;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: GestureDetector(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.bottomCenter,
                            padding: EdgeInsets.only(bottom: 8),
                            height: (MediaQuery.of(context).size.height) / 9,
                            decoration: new BoxDecoration(
                              gradient: new LinearGradient(
                                  colors: [
                                    const Color(0xFF00c6ff),
                                    Theme.of(context).primaryColor,
                                  ],
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter,
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: Icon(Icons.arrow_back)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child: Text(
                                    "Financial Manager",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'ZillaSlab',
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          height:
                              ((MediaQuery.of(context).size.height) * 8) / 9,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular((20))),
                          ),
                          child: MediaQuery.removePadding(
                              removeTop: true,
                              context: context,
                              child: ListView(
                                shrinkWrap: true,
                                children: <Widget>[
                                  Container(height: 20),
                                  buildHeaderWidget(context),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        height: 212,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                50,
                                        margin: EdgeInsets.only(
                                            right: 0, top: 16, bottom: 16),
                                        padding: EdgeInsets.all(8),
                                        decoration: new BoxDecoration(
                                          borderRadius: new BorderRadius.only(
                                              topRight: Radius.circular(20.0),
                                              bottomRight:
                                                  Radius.circular((20))),
                                          gradient: new LinearGradient(
                                              colors: [
                                                const Color(0xFF00c6ff),
                                                Theme.of(context).primaryColor,
                                              ],
                                              begin: const FractionalOffset(
                                                  0.0, 0.0),
                                              end: const FractionalOffset(
                                                  1.0, 1.00),
                                              stops: [0.0, 1.0],
                                              tileMode: TileMode.clamp),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 12,
                                                  top: 16,
                                                  bottom: 16),
                                              child: Text(
                                                'All Expenses',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontFamily: 'ZillaSlab',
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black45,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 16,
                                                  bottom: 12,
                                                  top: 12),
                                              child: Text(
                                                '₹\n' +
                                                    sum_all_expense.toString(),
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontFamily: 'ZillaSlab',
                                                  fontSize: (sum_all_expense >
                                                          99999.0)
                                                      ? 20
                                                      : 24.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            height: 93,
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 +
                                                32,
                                            margin: EdgeInsets.only(
                                                right: 0, top: 8, bottom: 8),
                                            padding: EdgeInsets.all(8),
                                            decoration: new BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20.0),
                                                      bottomLeft:
                                                          Radius.circular(
                                                              (20))),
                                              gradient: new LinearGradient(
                                                  colors: [
                                                    Theme.of(context)
                                                        .primaryColor,
                                                    const Color(0xFF00c6ff),
                                                  ],
                                                  begin: const FractionalOffset(
                                                      1.0, 0.0),
                                                  end: const FractionalOffset(
                                                      0.0, 1.00),
                                                  stops: [0.0, 1.0],
                                                  tileMode: TileMode.clamp),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16,
                                                      top: 4,
                                                      bottom: 8),
                                                  child: Text(
                                                    'Last Week',
                                                    style: TextStyle(
                                                      fontFamily: 'ZillaSlab',
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16,
                                                      top: 0,
                                                      bottom: 4),
                                                  child: Text(
                                                    '₹ ' +
                                                        last_week_expense
                                                            .toString(),
                                                    style: TextStyle(
                                                      fontFamily: 'ZillaSlab',
                                                      fontSize: 24.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 93,
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 +
                                                32,
                                            margin: EdgeInsets.only(
                                                right: 0, top: 8, bottom: 8),
                                            padding: EdgeInsets.all(8),
                                            decoration: new BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20.0),
                                                      bottomLeft:
                                                          Radius.circular(
                                                              (20))),
                                              gradient: new LinearGradient(
                                                  colors: [
                                                    Theme.of(context)
                                                        .primaryColor,
                                                    const Color(0xFF00c6ff),
                                                  ],
                                                  begin: const FractionalOffset(
                                                      1.0, 0.0),
                                                  end: const FractionalOffset(
                                                      0.0, 1.00),
                                                  stops: [0.0, 1.0],
                                                  tileMode: TileMode.clamp),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16,
                                                      top: 4,
                                                      bottom: 8),
                                                  child: Text(
                                                    'Last Month',
                                                    style: TextStyle(
                                                      fontFamily: 'ZillaSlab',
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16,
                                                      top: 0,
                                                      bottom: 4),
                                                  child: Text(
                                                    '₹ ' +
                                                        last_month_expense
                                                            .toString(),
                                                    style: TextStyle(
                                                      fontFamily: 'ZillaSlab',
                                                      fontSize: 24.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              new Radio(
                                                value: 0,
                                                groupValue: _radioValue1,
                                                onChanged:
                                                    _handleRadioValueChange1,
                                              ),
                                              new Text(
                                                'All time',
                                                style: new TextStyle(
                                                    fontSize: 14.0,
                                                    fontFamily: 'ZillaSlab',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              new Radio(
                                                value: 1,
                                                groupValue: _radioValue1,
                                                onChanged:
                                                    _handleRadioValueChange1,
                                              ),
                                              new Text(
                                                '↓ month',
                                                style: new TextStyle(
                                                    fontSize: 14.0,
                                                    fontFamily: 'ZillaSlab',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              new Radio(
                                                value: 2,
                                                groupValue: _radioValue1,
                                                onChanged:
                                                    _handleRadioValueChange1,
                                              ),
                                              new Text(
                                                '↓ week',
                                                style: new TextStyle(
                                                    fontSize: 14.0,
                                                    fontFamily: 'ZillaSlab',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 130,
                                            margin: EdgeInsets.only(
                                                top: 0, bottom: 10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                70,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: BarChart(
                                                mainBarData(),
                                                swapAnimationDuration:
                                                    animDuration,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                70,
                                            decoration: new BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomLeft:
                                                      Radius.circular((20)),
                                                  bottomRight:
                                                      Radius.circular((0)),
                                                  topRight:
                                                      Radius.circular((0)),
                                                ),
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 16),
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: categories.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return _buildCatsGraph(
                                                        index,
                                                        categories[index]);
                                                  }),
                                            ),
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                        height: 290,
                                        width: 60,
                                        margin: EdgeInsets.only(
                                            right: 0, top: 16, bottom: 16),
                                        padding: EdgeInsets.all(8),
                                        decoration: new BoxDecoration(
                                          borderRadius: new BorderRadius.only(
                                              topLeft: Radius.circular(20.0),
                                              bottomLeft:
                                                  Radius.circular((20))),
                                          gradient: new LinearGradient(
                                              colors: [
                                                const Color(0xFF00c6ff),
                                                Theme.of(context).primaryColor,
                                              ],
                                              begin: const FractionalOffset(
                                                  0.0, 0.0),
                                              end: const FractionalOffset(
                                                  1.0, 1.00),
                                              stops: [0.0, 1.0],
                                              tileMode: TileMode.clamp),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            RotatedBox(
                                              quarterTurns: -3,
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16,
                                                      right: 8,
                                                      bottom: 4,
                                                      top: 0),
                                                  child: Text(
                                                    "Categories",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily: 'ZillaSlab',
                                                        fontSize: 30,
                                                        color: Colors.black26,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 340,
                                        width: 60,
                                        margin: EdgeInsets.only(
                                            right: 0, top: 16, bottom: 16),
                                        padding: EdgeInsets.all(8),
                                        decoration: new BoxDecoration(
                                          borderRadius: new BorderRadius.only(
                                              topRight: Radius.circular(20.0),
                                              bottomRight:
                                                  Radius.circular((20))),
                                          gradient: new LinearGradient(
                                              colors: [
                                                const Color(0xFF00c6ff),
                                                Theme.of(context).primaryColor,
                                              ],
                                              begin: const FractionalOffset(
                                                  0.0, 0.0),
                                              end: const FractionalOffset(
                                                  1.0, 1.00),
                                              stops: [0.0, 1.0],
                                              tileMode: TileMode.clamp),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            RotatedBox(
                                              quarterTurns: -1,
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8,
                                                      right: 16,
                                                      bottom: 4,
                                                      top: 0),
                                                  child: Text(
                                                    "Past twelve months",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily: 'ZillaSlab',
                                                        fontSize: 30,
                                                        color: Colors.black26,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              60,
                                          height: 340,
                                          child: Padding(
                                              padding: EdgeInsets.only(top: 0),
                                              child: Container(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  ButtonBar(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    // this will take space as minimum as posible(to center)
                                                    children: <Widget>[
                                                      if (swich_month_graph !=
                                                          1)
                                                        new ButtonTheme(
                                                          minWidth: 10,
                                                          buttonColor: Colors
                                                              .transparent,
                                                          child: RaisedButton(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    new BorderRadius
                                                                            .circular(
                                                                        18.0),
                                                                side: BorderSide(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor)),
                                                            color: Colors
                                                                .transparent,
                                                            child: new Icon(
                                                              Icons
                                                                  .arrow_back_ios,
                                                              size: 16,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                swich_month_graph--;
                                                                if (swich_month_graph ==
                                                                    2) {
                                                                  to_show_month_graph =
                                                                      two_month_graph;
                                                                } else if (swich_month_graph ==
                                                                    1) {
                                                                  to_show_month_graph =
                                                                      one_month_graph;
                                                                }
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      if (swich_month_graph !=
                                                          3)
                                                        new ButtonTheme(
                                                            minWidth: 10,
                                                            child: RaisedButton(
                                                              color: Colors
                                                                  .transparent,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      new BorderRadius
                                                                              .circular(
                                                                          18.0),
                                                                  side: BorderSide(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor)),
                                                              child: new Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size: 16),
                                                              onPressed: () {
                                                                setState(() {
                                                                  swich_month_graph++;
                                                                  if (swich_month_graph ==
                                                                      2) {
                                                                    to_show_month_graph =
                                                                        two_month_graph;
                                                                  } else if (swich_month_graph ==
                                                                      3) {
                                                                    to_show_month_graph =
                                                                        three_month_graph;
                                                                  }
                                                                });
                                                              },
                                                            )),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 0,
                                                                  left: 0.0),
                                                          child: LineChart(
                                                            mainData(),
                                                            swapAnimationDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        250),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )))),
                                    ],
                                  ),
                                  Container(height: 200),
                                ],
                              )),
                        ),
                      ],
                    ),

//// down 2nd part
                    Container(
                      child: DraggableScrollableSheet(
                        initialChildSize: 0.20,
                        minChildSize: 0.06,
                        maxChildSize: 0.89,
                        builder: (BuildContext context, myscrollController) {
                          return Container(
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                    topLeft: Radius.circular((20)),
                                    topRight: Radius.circular((20))),
                                gradient: new LinearGradient(
                                    colors: [
                                      Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withOpacity(.9),
                                      Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withOpacity(.9)
                                    ],
                                    stops: [
                                      0.0,
                                      1.0
                                    ],
                                    begin: FractionalOffset.topCenter,
                                    end: FractionalOffset.bottomCenter,
                                    tileMode: TileMode.clamp),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(1, 1),
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.5),
                                      blurRadius: 1)
                                ],
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: MediaQuery.removePadding(
                                      removeTop: true,
                                      context: context,
                                      child: ListView.builder(
                                        controller: myscrollController,
                                        shrinkWrap: true,
                                        itemCount: 19 + to_show.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index == 0)
                                            return Column(
                                              children: <Widget>[
                                                Container(
                                                    decoration:
                                                        new BoxDecoration(
                                                      borderRadius:
                                                          new BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      (20)),
                                                              topRight: Radius
                                                                  .circular(
                                                                      (20))),
                                                      gradient: new LinearGradient(
                                                          colors: [
                                                            Theme.of(context)
                                                                .cardColor,
                                                            Theme.of(context)
                                                                .scaffoldBackgroundColor
                                                                .withOpacity(
                                                                    .9),
                                                          ],
                                                          stops: [
                                                            0.0,
                                                            1.0
                                                          ],
                                                          begin:
                                                              FractionalOffset
                                                                  .topCenter,
                                                          end: FractionalOffset
                                                              .bottomCenter,
                                                          tileMode:
                                                              TileMode.clamp),
                                                      /*boxShadow: [

                                                BoxShadow(
                                                    offset: Offset(1, 1),
                                                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                                                    blurRadius: 5)
                                              ],*/
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 60,
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 40,
                                                                height: 6,
                                                                decoration:
                                                                    new BoxDecoration(
                                                                  borderRadius: new BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          (8))),
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        offset: Offset(
                                                                            1,
                                                                            1),
                                                                        color: Theme.of(context)
                                                                            .primaryColor
                                                                            .withAlpha(
                                                                                80),
                                                                        blurRadius:
                                                                            10)
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ])),
                                              ],
                                            );

                                          if (index == 1)
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[],
                                            ); // sl
                                          else if (index == 2)
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20, top: 10),
                                                  child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 12,
                                                          right: 12,
                                                          top: 6,
                                                          bottom: 6),
                                                      decoration:
                                                          new BoxDecoration(
                                                        borderRadius:
                                                            new BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    (20))),
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                      ),
                                                      child: Text(
                                                        "My Expenses",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'ZillaSlab',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: .5,
                                                            fontSize: 26),
                                                      )),
                                                ),
                                                Spacer(),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 20, right: 4),
                                                  child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 12,
                                                          right: 12,
                                                          top: 6,
                                                          bottom: 6),
                                                      decoration:
                                                          new BoxDecoration(
                                                        borderRadius:
                                                            new BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    (20))),
                                                        border: Border.all(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            width: 2),
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              offset:
                                                                  Offset(0, 1),
                                                              color: Colors
                                                                  .black
                                                                  .withAlpha(
                                                                      80),
                                                              blurRadius: 2)
                                                        ],
                                                      ),
                                                      child: Text(
                                                        list_type_text,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'ZillaSlab',
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            letterSpacing: .5,
                                                            fontSize: 18),
                                                      )),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      select_list =
                                                          !select_list;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10, right: 20),
                                                    child: Container(
                                                        padding:
                                                            EdgeInsets.all(6),
                                                        decoration:
                                                            new BoxDecoration(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          (20))),
                                                          color: Theme.of(
                                                                  context)
                                                              .scaffoldBackgroundColor,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset: Offset(
                                                                    0, 1),
                                                                color: Colors
                                                                    .black
                                                                    .withAlpha(
                                                                        80),
                                                                blurRadius: 2)
                                                          ],
                                                        ),
                                                        child: Icon(Icons
                                                            .keyboard_arrow_down)),
                                                  ),
                                                )
                                              ],
                                            );
                                          else if (index == 3) {
                                            if (select_list)
                                              return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      select_list_type = 1;
                                                      select_list = false;
                                                      search_type = 1;
                                                      search_text =
                                                          "Search by month";
                                                      list_type_text = "All";
                                                      to_show.clear();
                                                      to_show = all_expense;
                                                      search = false;
                                                    });
                                                  },
                                                  child: FadeAnimation(
                                                      1.0,
                                                      Container(
                                                          child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    right: 20),
                                                            child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            12,
                                                                        right:
                                                                            12,
                                                                        top: 6,
                                                                        bottom:
                                                                            6),
                                                                decoration:
                                                                    new BoxDecoration(
                                                                  borderRadius: new BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          (20))),
                                                                  color: (select_list_type ==
                                                                          1)
                                                                      ? Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                      : Theme.of(
                                                                              context)
                                                                          .scaffoldBackgroundColor,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        offset: Offset(
                                                                            0,
                                                                            1),
                                                                        color: Colors
                                                                            .black
                                                                            .withAlpha(
                                                                                80),
                                                                        blurRadius:
                                                                            2)
                                                                  ],
                                                                ),
                                                                child: Text(
                                                                  "All",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'ZillaSlab',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      letterSpacing:
                                                                          .5,
                                                                      fontSize:
                                                                          22),
                                                                )),
                                                          ),
                                                        ],
                                                      ))));
                                            else
                                              return SizedBox(
                                                height: 0,
                                              );
                                          } else if (index == 4) {
                                            if (select_list)
                                              return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      select_list_type = 2;
                                                      select_list = false;
                                                      search_type = 2;
                                                      search_text =
                                                          "Search by category";
                                                      list_type_text =
                                                          "↓ Month";
                                                      to_show.clear();
                                                      to_show = last_month;
                                                      search = false;
                                                    });
                                                  },
                                                  child: FadeAnimation(
                                                      1.2,
                                                      Container(
                                                          child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    right: 20),
                                                            child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            12,
                                                                        right:
                                                                            12,
                                                                        top: 6,
                                                                        bottom:
                                                                            6),
                                                                decoration:
                                                                    new BoxDecoration(
                                                                  borderRadius: new BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          (20))),
                                                                  color: (select_list_type ==
                                                                          2)
                                                                      ? Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                      : Theme.of(
                                                                              context)
                                                                          .scaffoldBackgroundColor,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        offset: Offset(
                                                                            0,
                                                                            1),
                                                                        color: Colors
                                                                            .black
                                                                            .withAlpha(
                                                                                80),
                                                                        blurRadius:
                                                                            2)
                                                                  ],
                                                                ),
                                                                child: Text(
                                                                  "Past Month",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'ZillaSlab',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      letterSpacing:
                                                                          .5,
                                                                      fontSize:
                                                                          22),
                                                                )),
                                                          ),
                                                        ],
                                                      ))));
                                            else
                                              return SizedBox(
                                                height: 0,
                                              );
                                          } else if (index == 5) {
                                            if (select_list)
                                              return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      select_list_type = 3;
                                                      select_list = false;
                                                      search_type = 2;
                                                      search_text =
                                                          "Search by category";
                                                      list_type_text = "↓ Week";
                                                      to_show.clear();
                                                      to_show = last_week;
                                                      search = false;
                                                    });
                                                  },
                                                  child: FadeAnimation(
                                                      1.4,
                                                      Container(
                                                          child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    right: 20),
                                                            child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            12,
                                                                        right:
                                                                            12,
                                                                        top: 6,
                                                                        bottom:
                                                                            6),
                                                                decoration:
                                                                    new BoxDecoration(
                                                                  borderRadius: new BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          (20))),
                                                                  color: (select_list_type ==
                                                                          3)
                                                                      ? Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                      : Theme.of(
                                                                              context)
                                                                          .scaffoldBackgroundColor,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        offset: Offset(
                                                                            0,
                                                                            1),
                                                                        color: Colors
                                                                            .black
                                                                            .withAlpha(
                                                                                80),
                                                                        blurRadius:
                                                                            2)
                                                                  ],
                                                                ),
                                                                child: Text(
                                                                  "Past Week",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'ZillaSlab',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      letterSpacing:
                                                                          .5,
                                                                      fontSize:
                                                                          22),
                                                                )),
                                                          ),
                                                        ],
                                                      ))));
                                            else
                                              return SizedBox(
                                                height: 0,
                                              );
                                          } else if (index == 6)
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20, top: 10),
                                                  child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 12,
                                                          right: 12,
                                                          top: 6,
                                                          bottom: 6),
                                                      decoration:
                                                          new BoxDecoration(
                                                        border: Border.all(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            width: 2),
                                                        borderRadius:
                                                            new BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    (20))),
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              offset:
                                                                  Offset(0, 1),
                                                              color: Colors
                                                                  .black
                                                                  .withAlpha(
                                                                      80),
                                                              blurRadius: 2)
                                                        ],
                                                      ),
                                                      child: Text(
                                                        search_text,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'ZillaSlab',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            letterSpacing: .5,
                                                            fontSize: 20),
                                                      )),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      search = !search;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10, left: 4),
                                                    child: Container(
                                                        padding:
                                                            EdgeInsets.all(6),
                                                        decoration:
                                                            new BoxDecoration(
                                                                borderRadius:
                                                                    new BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            (20))),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              1),
                                                                      color: Colors
                                                                          .black
                                                                          .withAlpha(
                                                                              80),
                                                                      blurRadius:
                                                                          2)
                                                                ],
                                                                color: Theme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor),
                                                        child: Icon(Icons
                                                            .keyboard_arrow_down)),
                                                  ),
                                                ),
                                              ],
                                            );
                                          else if (index == 7) {
                                            if (search && select_list_type == 1)
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    search_type = 1;
                                                    search = false;
                                                    search_text =
                                                        "Search by month";
                                                  });
                                                },
                                                child: FadeAnimation(
                                                    1.0,
                                                    Container(
                                                        child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 20,
                                                                  top: 10),
                                                          child: Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 12,
                                                                      right: 12,
                                                                      top: 6,
                                                                      bottom:
                                                                          6),
                                                              decoration:
                                                                  new BoxDecoration(
                                                                borderRadius:
                                                                    new BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            (20))),
                                                                color: (search_type ==
                                                                        1)
                                                                    ? Theme.of(
                                                                            context)
                                                                        .primaryColor
                                                                    : Theme.of(
                                                                            context)
                                                                        .scaffoldBackgroundColor,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              1),
                                                                      color: Colors
                                                                          .black
                                                                          .withAlpha(
                                                                              80),
                                                                      blurRadius:
                                                                          2)
                                                                ],
                                                              ),
                                                              child: Text(
                                                                "Search by month",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'ZillaSlab',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    letterSpacing:
                                                                        .5,
                                                                    fontSize:
                                                                        20),
                                                              )),
                                                        ),
                                                      ],
                                                    ))),
                                              );
                                            else
                                              return SizedBox(
                                                height: 0,
                                              );
                                          } else if (index == 8) {
                                            if (search)
                                              return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      search_type = 2;
                                                      search = false;
                                                      search_text =
                                                          "Search by category";
                                                    });
                                                  },
                                                  child: FadeAnimation(
                                                      1.2,
                                                      Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 20,
                                                                      top: 10),
                                                              child: Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              12,
                                                                          right:
                                                                              12,
                                                                          top:
                                                                              6,
                                                                          bottom:
                                                                              6),
                                                                  decoration:
                                                                      new BoxDecoration(
                                                                    borderRadius: new BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            (20))),
                                                                    color: (search_type ==
                                                                            2)
                                                                        ? Theme.of(context)
                                                                            .primaryColor
                                                                        : Theme.of(context)
                                                                            .scaffoldBackgroundColor,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          offset: Offset(
                                                                              0,
                                                                              1),
                                                                          color: Colors.black.withAlpha(
                                                                              80),
                                                                          blurRadius:
                                                                              2)
                                                                    ],
                                                                  ),
                                                                  child: Text(
                                                                    "Search by category",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'ZillaSlab',
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        letterSpacing:
                                                                            .5,
                                                                        fontSize:
                                                                            20),
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      )));
                                            else
                                              return SizedBox(
                                                height: 0,
                                              );
                                          } else if (index == 9) {
                                            if (search)
                                              return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      search_type = 3;
                                                      search = false;
                                                      search_text =
                                                          "Search by amount";
                                                    });
                                                  },
                                                  child: FadeAnimation(
                                                      1.4,
                                                      Container(
                                                          child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    top: 10),
                                                            child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            12,
                                                                        right:
                                                                            12,
                                                                        top: 6,
                                                                        bottom:
                                                                            6),
                                                                decoration:
                                                                    new BoxDecoration(
                                                                  borderRadius: new BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          (20))),
                                                                  color: (search_type ==
                                                                          3)
                                                                      ? Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                      : Theme.of(
                                                                              context)
                                                                          .scaffoldBackgroundColor,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        offset: Offset(
                                                                            0,
                                                                            1),
                                                                        color: Colors
                                                                            .black
                                                                            .withAlpha(
                                                                                80),
                                                                        blurRadius:
                                                                            2)
                                                                  ],
                                                                ),
                                                                child: Text(
                                                                  "Search by amount",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'ZillaSlab',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      letterSpacing:
                                                                          .5,
                                                                      fontSize:
                                                                          20),
                                                                )),
                                                          ),
                                                        ],
                                                      ))));
                                            else
                                              return SizedBox(
                                                height: 0,
                                              );
                                          } //amount

                                          else if (index == 10) {
                                            if (search && select_list_type == 1)
                                              return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      search_type = 1;
                                                      search = false;
                                                      search_text =
                                                          "Search by date";
                                                    });
                                                  },
                                                  child: FadeAnimation(
                                                      1.6,
                                                      Container(
                                                          child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    top: 10),
                                                            child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            12,
                                                                        right:
                                                                            12,
                                                                        top: 6,
                                                                        bottom:
                                                                            6),
                                                                decoration:
                                                                    new BoxDecoration(
                                                                  borderRadius: new BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          (20))),
                                                                  color: (search_type ==
                                                                          4)
                                                                      ? Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                      : Theme.of(
                                                                              context)
                                                                          .scaffoldBackgroundColor,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        offset: Offset(
                                                                            0,
                                                                            1),
                                                                        color: Colors
                                                                            .black
                                                                            .withAlpha(
                                                                                80),
                                                                        blurRadius:
                                                                            2)
                                                                  ],
                                                                ),
                                                                child: Text(
                                                                  "Search by date",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'ZillaSlab',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      letterSpacing:
                                                                          .5,
                                                                      fontSize:
                                                                          20),
                                                                )),
                                                          ),
                                                        ],
                                                      ))));
                                            else
                                              return SizedBox(
                                                height: 0,
                                              );
                                          } // ide up//date ide up bar
                                          else if (index == 11) {
                                            if (search && select_list_type == 1)
                                              return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      search_type = 5;
                                                      search = false;
                                                      search_text =
                                                          "Search by friend";
                                                    });
                                                  },
                                                  child: FadeAnimation(
                                                      1.8,
                                                      Container(
                                                          child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    top: 10),
                                                            child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            12,
                                                                        right:
                                                                            12,
                                                                        top: 6,
                                                                        bottom:
                                                                            6),
                                                                decoration:
                                                                    new BoxDecoration(
                                                                  borderRadius: new BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          (20))),
                                                                  color: (search_type ==
                                                                          5)
                                                                      ? Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                      : Theme.of(
                                                                              context)
                                                                          .scaffoldBackgroundColor,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        offset: Offset(
                                                                            0,
                                                                            1),
                                                                        color: Colors
                                                                            .black
                                                                            .withAlpha(
                                                                                80),
                                                                        blurRadius:
                                                                            2)
                                                                  ],
                                                                ),
                                                                child: Text(
                                                                  "Search by friend",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'ZillaSlab',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      letterSpacing:
                                                                          .5,
                                                                      fontSize:
                                                                          20),
                                                                )),
                                                          ),
                                                        ],
                                                      ))));
                                            else
                                              return SizedBox(
                                                height: 0,
                                              );
                                          } //friend

                                          else if (index == 12)
                                            return Container(height: 10);
                                          else if (index == 13) {
                                            if (search_type == 1)
                                              return monthsSelect();
                                            else
                                              return SizedBox(
                                                height: 0,
                                              );
                                          } else if (index == 14) {
                                            if (search_type == 2)
                                              return CategorySelect();
                                            else
                                              return SizedBox(
                                                height: 0,
                                              );
                                          } else if (index == 15) {
                                            if (search_type == 5)
                                              return FriendSelect();
                                            else
                                              return SizedBox(
                                                height: 0,
                                              );
                                          } else if (index == 16) {
                                            if (search_type == 3)
                                              return AmountSelect();
                                            else
                                              return SizedBox(
                                                height: 0,
                                              );
                                          } else if (index == 17)
                                            return Container(height: 10);
                                          else if (index == 18) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 6),
                                                  child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 12,
                                                          right: 12,
                                                          top: 6,
                                                          bottom: 6),
                                                      decoration:
                                                          new BoxDecoration(
                                                        border: Border.all(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            width: 2),
                                                        borderRadius:
                                                            new BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    (20))),
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              offset:
                                                                  Offset(0, 1),
                                                              color: Colors
                                                                  .black
                                                                  .withAlpha(
                                                                      80),
                                                              blurRadius: 2)
                                                        ],
                                                      ),
                                                      child: Text(
                                                        "Double tap to edit",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'ZillaSlab',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            letterSpacing: .5,
                                                            fontSize: 14),
                                                      )),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 4, bottom: 6),
                                                  child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 12,
                                                          right: 12,
                                                          top: 6,
                                                          bottom: 6),
                                                      decoration:
                                                          new BoxDecoration(
                                                        border: Border.all(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            width: 2),
                                                        borderRadius:
                                                            new BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    (20))),
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              offset:
                                                                  Offset(0, 1),
                                                              color: Colors
                                                                  .black
                                                                  .withAlpha(
                                                                      80),
                                                              blurRadius: 2)
                                                        ],
                                                      ),
                                                      child: Text(
                                                        "Amount ↓",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'ZillaSlab',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            letterSpacing: .5,
                                                            fontSize: 14),
                                                      )),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 4, bottom: 6),
                                                  child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 12,
                                                          right: 12,
                                                          top: 6,
                                                          bottom: 6),
                                                      decoration:
                                                          new BoxDecoration(
                                                        border: Border.all(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            width: 2),
                                                        borderRadius:
                                                            new BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    (20))),
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              offset:
                                                                  Offset(0, 1),
                                                              color: Colors
                                                                  .black
                                                                  .withAlpha(
                                                                      80),
                                                              blurRadius: 2)
                                                        ],
                                                      ),
                                                      child: Text(
                                                        "Date ↓",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'ZillaSlab',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            letterSpacing: .5,
                                                            fontSize: 14),
                                                      )),
                                                ),
                                              ],
                                            );
                                          }

                                          return _buildExpenseCard(
                                              index - 19, to_show[index - 19]);
                                        },
                                      ),
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: new BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular((10))),
                                              color:
                                                  Theme.of(context).cardColor,
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(1, 1),
                                                    color: Colors.black
                                                        .withAlpha(80),
                                                    blurRadius: 4)
                                              ],
                                            ),
                                          )))
                                ],
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget AmountSelect() {
    return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
        margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
        width: headerShouldHide ? 0 : null,
        child: Container(
          height: 80,
          margin: EdgeInsets.only(left: 20),
          padding: EdgeInsets.all(8),
          decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: Offset(1, 1),
                    color: Colors.black.withAlpha(80),
                    blurRadius: 2)
              ],
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular((20)),
                bottomRight: Radius.circular((0)),
                topRight: Radius.circular((0)),
              ),
              color: Theme.of(context).scaffoldBackgroundColor),
          child: Padding(
              padding: EdgeInsets.only(left: 0),
              child: SliderTheme(
                data: SliderThemeData(
                    showValueIndicator: ShowValueIndicator.always),
                child: RangeSlider(
                    values: _values,
                    labels: _labels,
                    divisions: 1000,
                    min: 0,
                    max: 100000,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _values = values;
                        _labels = RangeLabels(
                            '${_values.start.toInt().toString()} \₹',
                            '${_values.end.toInt().toString()} \₹');
                      });

                      setState(() {
                        List<ExpenseModel> added_list = [];
                        List<ExpenseModel> temp = [];
                        if (select_list_type == 1)
                          temp = []..addAll(all_expense);
                        else if (select_list_type == 2)
                          temp = []..addAll(last_month);
                        else {
                          temp = []..addAll(last_week);
                        }
                        for (int i = 0; i < temp.length; i++) {
                          if (!(temp[i].money < _values.start ||
                              temp[i].money > _values.end)) {
                            added_list.add(temp[i]);
                          }
                        }
                        to_show = added_list;
                      });
                    }),
              )),
        ));
  }

  Widget monthsSelect() {
    return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
        margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
        width: headerShouldHide ? 0 : null,
        child: Container(
          height: 85,
          margin: EdgeInsets.only(left: 20),
          padding: EdgeInsets.all(8),
          decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: Offset(1, 1),
                    color: Colors.black.withAlpha(80),
                    blurRadius: 2)
              ],
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular((20)),
                bottomRight: Radius.circular((0)),
                topRight: Radius.circular((0)),
              ),
              color: Theme.of(context).scaffoldBackgroundColor),
          child: Padding(
            padding: EdgeInsets.only(left: 0),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 12,
                controller: _controller,
                itemBuilder: (BuildContext context, int index) {
                  return _buildMonthCard(index, pastMonths[index]);
                }),
          ),
        ));
  }

  Widget FriendSelect() {
    return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
        margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
        width: headerShouldHide ? 0 : null,
        child: Container(
          height: 80,
          margin: EdgeInsets.only(left: 20),
          padding: EdgeInsets.all(8),
          decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: Offset(1, 1),
                    color: Colors.black.withAlpha(80),
                    blurRadius: 2)
              ],
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular((20)),
                bottomRight: Radius.circular((0)),
                topRight: Radius.circular((0)),
              ),
              color: Theme.of(context).scaffoldBackgroundColor),
          child: Padding(
            padding: EdgeInsets.only(left: 0),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: friends_list.length + 1,
                controller: _controller,
                itemBuilder: (BuildContext context, int index) {
                  if (index == friends_list.length) {
                    if (friends_list.length == 0) {
                      return Padding(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 4, horizontal: 4.0),
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 8, left: 8),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "You have no friends, hehe I mean first add your friends ",
                                    style: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SizedBox(
                        width: 0,
                      );
                    }
                  }

                  return _buildFriends(index, friends_list[index]);
                }),
          ),
        ));
  }

  Widget CategorySelect() {
    return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
        margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
        width: headerShouldHide ? 0 : null,
        child: Container(
          height: 80,
          margin: EdgeInsets.only(left: 20),
          padding: EdgeInsets.all(8),
          decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: Offset(1, 1),
                    color: Colors.black.withAlpha(80),
                    blurRadius: 2)
              ],
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular((20)),
                bottomRight: Radius.circular((0)),
                topRight: Radius.circular((0)),
              ),
              color: Theme.of(context).scaffoldBackgroundColor),
          child: Padding(
            padding: EdgeInsets.only(left: 0),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildCats(index, categories[index]);
                }),
          ),
        ));
  }

  setTheme(Brightness brightness) {
    if (brightness == Brightness.dark) {
      setState(() {
        theme = appThemeDark;
      });
    } else {
      setState(() {
        theme = appThemeLight;
      });
    }
  }

  Widget buildHeaderWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => expenseEdit(
                        triggerRefetch: get_category_List,
                      )));
            },
            child:AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
            margin: EdgeInsets.only(
              top: 0,
              bottom: 0,
            ),
            width: headerShouldHide ? 0 : null,
            child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width - 30,
                margin: EdgeInsets.only(left: 12, right: 12),
                padding: EdgeInsets.all(8),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(Radius.circular((20))),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(1, 1),
                        color: Colors.black.withAlpha(80),
                        blurRadius: 4)
                  ],
                ),
                child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "ADD EXPENSE ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize: 22.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.add_circle, size: 30),
                      )
                    ],
                  ),
                ))),
      ],
    );
  }

  Widget _buildExpenseCard(int index, ExpenseModel this_expense) {
    String count = "";
    print(this_expense.date);

    return GestureDetector(
      onTap: () {
        setState(() {
          current_position_expense_list = index;
        });

        setState(() {});
        setState(() {});
      },
      child: Padding(
        padding: EdgeInsets.only(),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: (current_position_expense_list == index)
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  width: 2),
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              color: (current_position_expense_list == index)
                  ? Theme.of(context).primaryColor
                  : Colors.transparent),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Stack(
            children: <Widget>[
              if (this_expense.cat_id != 0 && this_expense.friend_id == 0)
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: EdgeInsets.only(left: 20, top: 1),
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            color: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? Colors.black12
                                : Colors.white12),
                        child: Icon(toic_id(this_expense.cat_id)))), //icon
              if (this_expense.friend_id != 0)
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: EdgeInsets.only(left: 20, top: 1),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            color: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? Colors.black12
                                : Colors.white12),
                        child: Icon(Icons.arrow_forward))), //icon
              if (this_expense.friend_id != 0)
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: EdgeInsets.only(left: 20, top: 40),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            color: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? Colors.black12
                                : Colors.white12),
                        child: Text("Friend",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )))), //icon

              Padding(
                padding: EdgeInsets.only(left: 110, top: 4),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(this_expense.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 110, top: 34),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(formatter_date_Expense.format(this_expense.date),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 16,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20, top: 13),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("₹ " + this_expense.money.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              if (this_expense.content != "")
                Padding(
                  padding: EdgeInsets.only(right: 20, top: 65, left: 110),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(this_expense.content,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          fontSize: 18,
                        )),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthCard(int index, DateTime this_date) {
    String count = "";

    return GestureDetector(
      onTap: () {
        setState(() {
          current_position_month = index;
          if (select_list_type == 1) {
            to_show = all_months[index + 1].cast<ExpenseModel>();
          }
        });

        setState(() {
          selectedDate = this_date;
        });
        setState(() {});
      },
      child: Padding(
        padding: EdgeInsets.only(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
          height: 100,
          width: 60,
          child: Stack(
            children: <Widget>[
              if (current_position_month != index)
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        height: 30,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            color: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? Colors.black12
                                : Colors.white30))),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: (current_position_month == index)
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: (current_position_month == index)
                          ? Colors.white30
                          : Colors.transparent)),
              Padding(
                padding: EdgeInsets.all(4),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(formatter_date_builder.format(this_date),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 20,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCatsGraph(int index, CatModel this_cat) {
    String count = "";
    String image = this_cat.image;

    return GestureDetector(
      onTap: () {
        setState(() {
          chosen_expense_cat = index;
          if (select_list_type == 1) {
            to_show = all_categories[index + 1].cast<ExpenseModel>();
          } else if (select_list_type == 2) {
            to_show = last_month_categories[index + 1].cast<ExpenseModel>();
          } else if (select_list_type == 3) {
            to_show = last_week_categories[index + 1].cast<ExpenseModel>();
          }
        });
      },
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Container(
          margin: EdgeInsets.only(
              right: (MediaQuery.of(context).size.width - 365) / 10),
          decoration: BoxDecoration(
            color: (chosen_expense_cat == index)
                ? Colors.grey.withOpacity(.3)
                : Colors.transparent,
            border: Border.all(
                color: (chosen_expense_cat == index)
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 2, right: 0, left: 0),
                child: Icon(
                  toic(image),
                  size: 20,
                ),
              ),
              RotatedBox(
                quarterTurns: -1,
                child: Padding(
                    padding:
                        EdgeInsets.only(left: 0, right: 30, bottom: 0, top: 0),
                    child: Text(
                      this_cat.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCats(int index, CatModel this_cat) {
    String count = "";
    String image = this_cat.image;

    return GestureDetector(
      onTap: () {
        setState(() {
          chosen_expense_cat = index;
          if (select_list_type == 1) {
            to_show = all_categories[index + 1].cast<ExpenseModel>();
          } else if (select_list_type == 2) {
            to_show = last_month_categories[index + 1].cast<ExpenseModel>();
          } else if (select_list_type == 3) {
            to_show = last_week_categories[index + 1].cast<ExpenseModel>();
          }
        });
      },
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4.0),
          height: 120,
          decoration: BoxDecoration(
            color: (chosen_expense_cat == index)
                ? Colors.grey.withOpacity(.3)
                : Colors.transparent,
            border: Border.all(
                color: (chosen_expense_cat == index)
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 2, right: 8, left: 8),
                child: Icon(toic(image)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 14, right: 8, left: 8),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    this_cat.name,
                    style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriends(int index, FriendModel this_cat) {
    String count = "";

    return GestureDetector(
      onTap: () {
        setState(() {
          chosen_friend = index;

          to_show = all_friends[index + 1].cast<ExpenseModel>();
        });
      },
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4.0),
          height: 120,
          decoration: BoxDecoration(
            color: (chosen_friend == index)
                ? Colors.grey.withOpacity(.3)
                : Colors.transparent,
            border: Border.all(
                color: (chosen_friend == index)
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 8, left: 8),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    this_cat.name,
                    style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData toic(String str) {
    if (str == "Icons.restaurant")
      return (Icons.restaurant);
    else if (str == "Icons.receipt")
      return (Icons.receipt);
    else if (str == "Icons.movie_filter")
      return (Icons.movie_filter);
    else if (str == "Icons.healing")
      return (Icons.healing);
    else if (str == "Icons.directions_bus")
      return (Icons.directions_bus);
    else if (str == "Icons.ev_station")
      return (Icons.ev_station);
    else if (str == "Icons.local_atm")
      return (Icons.local_atm);
    else if (str == "Icons.trending_up")
      return (Icons.trending_up);
    else if (str == "Icons.home")
      return (Icons.home);
    else if (str == "Icons.library_books")
      return (Icons.library_books);
    else if (str == "Icons.scatter_plot")
      return (Icons.scatter_plot);
    else
      return Icons.scatter_plot;
  }

  IconData toic_id(int id) {
    if (id == 1)
      return (Icons.restaurant);
    else if (id == 2)
      return (Icons.receipt);
    else if (id == 3)
      return (Icons.movie_filter);
    else if (id == 4)
      return (Icons.healing);
    else if (id == 5)
      return (Icons.directions_bus);
    else if (id == 6)
      return (Icons.ev_station);
    else if (id == 7)
      return (Icons.local_atm);
    else if (id == 8)
      return (Icons.trending_up);
    else if (id == 9)
      return (Icons.home);
    else if (id == 10)
      return (Icons.library_books);
    else if (id == 11)
      return (Icons.scatter_plot);
    else
      return Icons.scatter_plot;
  }

  List<Color> colorList = [
    Colors.deepPurple,
    Colors.amber.shade900,
    Colors.blueGrey,
    Colors.redAccent,
    Colors.cyan,
    Colors.purpleAccent,
    Colors.amber.shade900,
    Colors.yellowAccent,
    Colors.brown,
    Colors.lightGreenAccent,
    Colors.pink
  ];

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.blueAccent,
    double width = 14,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 0.2 : y,
          color: isTouched ? Theme.of(context).primaryColor : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 1,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() =>
      List.generate(categories.length, (i) {
        if (_radioValue1 == 0)
          return makeGroupData(
              i, all_expense_cat_total[i + 1] / (max_all_cat * 1.2),
              isTouched: i == touchedIndex, barColor: colorList[i]);
        else if (_radioValue1 == 1)
          return makeGroupData(
              i, last_month_cat_total[i + 1] / (max_past_month_cat * 1.2),
              isTouched: i == touchedIndex, barColor: colorList[i]);
        else
          return makeGroupData(
              i, last_week_cat_total[i + 1] / (max_past_week_cat * 1.2),
              isTouched: i == touchedIndex, barColor: colorList[i]);
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              weekDay = categories[group.x.toInt()].name;

              return BarTooltipItem(
                  weekDay +
                      '\n ₹' +
                      ((rod.y - .2) * (1.2 * max_all_cat)).toInt().toString(),
                  TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ZillaSlab',
                    fontSize: 18,
                  ));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: false,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 0,
          getTitles: (double value) {
            return "";
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontFamily: 'ZillaSlab',
              fontSize: 20),
          getTitles: (value) {
            if (swich_month_graph == 1) {
              if (value == 3)
                return formatter_only_month.format(pastMonths[value.toInt()]) +
                    "            .";
              return formatter_only_month.format(pastMonths[value.toInt()]);
            } else if (swich_month_graph == 2) {
              if (value == 3)
                return formatter_only_month
                        .format(pastMonths[value.toInt() + 4]) +
                    "            .";
              return formatter_only_month.format(pastMonths[value.toInt() + 4]);
            } else {
              if (value == 3)
                return formatter_only_month
                        .format(pastMonths[value.toInt() + 8]) +
                    "           .";
              return formatter_only_month.format(pastMonths[value.toInt() + 8]);
            }
          },
          margin: 8,
        ),
        rightTitles: SideTitles(
          showTitles: false,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return (max_all_months * 1.2).toString() + " ₹";
            }
            return '';
          },
          reservedSize: 0,
          margin: 0,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                {
                  String to_print = max_all_months.floor().toString();
                  if (max_all_months > 999) {
                    to_print = (max_all_months / 1000).toInt().toString() + "K";
                  }

                  return to_print + " ₹";
                }

              case 0:
                return "0  ₹       ";
            }
            return '';
          },
          reservedSize: 50,
          margin: 0,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 0)),
      minX: 0,
      maxX: 3,
      minY: 0,
      maxY: 1,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, .5),
            FlSpot(11, .5),
          ],
          isCurved: true,
          colors: [Colors.grey, Colors.black45],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.2)).toList(),
          ),
        ),
        LineChartBarData(
          spots: to_show_month_graph,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.4)).toList(),
          ),
        ),
      ],
    );
  }

  void _handleRadioValueChange1(value) {
    setState(() {
      _radioValue1 = value;
    });
  }
}
