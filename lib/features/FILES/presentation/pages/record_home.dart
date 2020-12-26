import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/FILES/presentation/pages/record_page_loaded.dart';
import 'package:sorted/features/FILES/presentation/record_bloc/record_bloc.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';

class RecordTab extends StatefulWidget {
  const RecordTab({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RecordTabState();
}

class RecordTabState extends State<RecordTab> {
  RecordBloc bloc;
  @override
  void initState() {
    bloc = RecordBloc(sl(), sl())..add(GetRecordInitialData());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => bloc,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: SafeArea(child: new LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return BlocBuilder<RecordBloc, RecordState>(
                  builder: (context, state) {
                if (state is RecordError) {
              return MessageDisplay(
                message: state.message,
              );
                } else if (state is RecordLoading) {
              return Container(
                height: 0,
                width: 0,
              );
                } else if (state is RecordLoaded) {
              return RecordTabPage(
                state: state,
              );
                }
              });
            }))));
  }
}
