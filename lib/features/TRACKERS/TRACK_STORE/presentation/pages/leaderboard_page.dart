import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/bloc/leaderboard/leaderboard_bloc.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  LeaderboardBloc bloc;
  @override
  void initState() {
    bloc = sl<LeaderboardBloc>();
    bloc.add(GetLeaderboardDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LeaderboardBloc>(
      create: (context) => bloc,
      child: DefaultTabController(
        length: 3,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text("Leaderboard"),
              bottom: TabBar(
                tabs: <Tab>[
                  Tab(child: Text("All time")),
                  Tab(child: Text("Last 7 days")),
                  Tab(child: Text("Last 30 days")),
                ],
              ),
            ),
            body: BlocBuilder<LeaderboardBloc, LeaderboardState>(
              builder: (context, state) {
                if (state is GetLeaderboardDataLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is GetLeaderboardDataLoadedState) {
                  return TabBarView(children: <Widget>[
                    LeaderboardWidget(data: state.alltime_data),
                    LeaderboardWidget(data: state.last7_data),
                    LeaderboardWidget(data: state.last30_data),
                  ]);
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LeaderboardWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  LeaderboardWidget({this.data});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (_, i) {
        if (i == 0) {
          return LeaderboardTopItem(
            name: data[i]["user"],
            rank: i + 1,
            score: data[i]["score"],
          );
        }
        return LeaderboardItem(
          name: data[i]["user"],
          rank: i + 1,
          score: data[i]["score"],
        );
      },
    );
  }
}

class LeaderboardItem extends StatelessWidget {
  final int rank;
  final String name;
  final double score;

  const LeaderboardItem({
    @required this.rank,
    @required this.name,
    @required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text("$rank."),
      title: Text("$name"),
      trailing: Text("${score.round()}"),
    );
  }
}

class LeaderboardTopItem extends StatelessWidget {
  final int rank;
  final String name;
  final double score;

  const LeaderboardTopItem({
    @required this.rank,
    @required this.name,
    @required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text("$rank."),
      title: Text(
        "Top Engager",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.amber,
        ),
      ),
      subtitle: Text(
        "$name",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      trailing: Text(
        "${score.round()}",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.amber,
        ),
      ),
    );
  }
}
