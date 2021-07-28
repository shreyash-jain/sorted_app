import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/features/CONNECT/presentation/class_enroll_bloc/class_enroll_bloc.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/class_content.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/class_timetable.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/classroom_preview.dart';

class ClassListPage extends StatefulWidget {
  final String classId;
  ClassListPage({Key key, this.classId}) : super(key: key);

  @override
  _ClassListPageState createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {
  ClassEnrollBloc classEnrollBloc;

  @override
  void initState() {
    classEnrollBloc = ClassEnrollBloc(sl())
      ..add(GetClassDetails(widget.classId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => classEnrollBloc,
        child: BlocBuilder<ClassEnrollBloc, ClassEnrollState>(
          builder: (context, state) {
            if (state is ClassEnrollLoaded)
              return SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.isLoading) LinearProgressIndicator(),
                        SizedBox(
                          height: 0,
                        ),
                        Container(
                          padding: EdgeInsets.all(Gparam.widthPadding),
                          child: Gtheme.stext(state.classroom.name,
                              size: GFontSize.M, weight: GFontWeight.B1),
                        ),
                        ClassroomPreview(
                            coverImageUrl: (state.classroom.coverUrl != null &&
                                    state.classroom.coverUrl != "")
                                ? state.classroom.coverUrl
                                : "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/classrooms%2Fplaceholders%2F19347.jpg?alt=media&token=06651a7f-2dd5-4eef-96f5-5a34210df824",
                            topics: state.topics),
                        SizedBox(
                          height: 10,
                        ),
                        ExpansionTile(
                          title: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Gparam.widthPadding / 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Gtheme.stext("Time Table",
                                    size: GFontSize.S, weight: GFontWeight.B1),
                              ],
                            ),
                          ),
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Gparam.widthPadding / 2),
                              child: ClassTimeTableWidget(
                                  classModel: state.classroom),
                            ),
                          ],
                        ),
                        if (state.classroom.description != '')
                          ExpansionTile(
                            title: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Gparam.widthPadding / 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Gtheme.stext("About Classroom",
                                      size: GFontSize.S,
                                      weight: GFontWeight.B1),
                                ],
                              ),
                            ),
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Gparam.widthPadding / 2),
                                child: ClassDescription(
                                  classroom: state.classroom,
                                ),
                              )
                            ],
                          ),
                        ExpansionTile(
                          title: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Gparam.widthPadding / 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Gtheme.stext("About Trainer",
                                    size: GFontSize.S, weight: GFontWeight.B1),
                              ],
                            ),
                          ),
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Gparam.widthPadding / 2),
                              child: ClassDescription(
                                classroom: state.classroom,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              height: 50,
                              elevation: 0,
                              minWidth: Gparam.width - Gparam.widthPadding,
                              onPressed: (state.userEnrollState == 0)
                                  ? () {
                                      print("something");
                                      if (!state.isLoading)
                                        classEnrollBloc.add(EnrollRequestEvent(
                                            state.classroom));
                                    }
                                  : null,
                              color: Colors.grey.shade200,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.live_tv,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Gtheme.stext(
                                      (state.userEnrollState == 0)
                                          ? "Enroll"
                                          : (state.userEnrollState == 1)
                                              ? "Requested"
                                              : "Already Enrolled",
                                      weight: GFontWeight.B1),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            else if (state is ClassEnrollInitial) {
              return Center(child: Container(child: LoadingWidget()));
            } else if (state is ClassEnrollError) {
              return Center(
                  child: Container(child: Gtheme.stext(state.message)));
            }
          },
        ),
      ),
    );
  }
}
