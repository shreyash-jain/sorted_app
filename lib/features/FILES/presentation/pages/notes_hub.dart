import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/FILES/data/models/notebook_model.dart';
import 'package:sorted/features/FILES/presentation/notes_hub_bloc/notes_hub_bloc.dart';
import 'package:sorted/features/FILES/presentation/pages/notes_hub_page_loaded.dart';

class NotesHubPage extends StatefulWidget {
  const NotesHubPage({Key key, this.thisNotebook}) : super(key: key);
  final NotebookModel thisNotebook;

  @override
  State<StatefulWidget> createState() => NotesHubPageState();
}

class NotesHubPageState extends State<NotesHubPage> {
  NotesHubBloc bloc;
  @override
  void initState() {
    bloc = NotesHubBloc(sl(), sl())
      ..add(GetNotesHubInitialData(widget.thisNotebook));
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
              return BlocBuilder<NotesHubBloc, NotesHubState>(
                  builder: (context, state) {
                if (state is NotesHubError) {
                  return MessageDisplay(
                    message: state.message,
                  );
                } else if (state is NotesHubLoading) {
                  return Center(child: LoadingWidget());
                } else if (state is NotesHubLoaded) {
                  return NotesHubLoadedPage(
                    state: state,
                  );
                }
              });
            }))));
  }
}
