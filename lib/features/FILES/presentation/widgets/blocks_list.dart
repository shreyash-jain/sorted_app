import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/models/link.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:sorted/features/PLAN/presentation/widgets/add_link.dart';

String horseUrl = 'https://i.stack.imgur.com/Dw6f7.png';
String cowUrl = 'https://i.stack.imgur.com/XPOr3.png';
String camelUrl = 'https://i.stack.imgur.com/YN0m7.png';
String sheepUrl = 'https://i.stack.imgur.com/wKzo8.png';
String goatUrl = 'https://i.stack.imgur.com/Qt4JP.png';
LinkModel thisLink = LinkModel(url: "");

class BlockListWidget extends StatelessWidget {
  TextEditingController _newMediaLinkAddressController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Gparam.height,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: Gparam.heightPadding,
          ),
          Center(
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    BlocProvider.of<NoteBloc>(context).add(GoBackFromSelect());
                  },
                ),
                RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  text: TextSpan(
                    text: "Select",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: Gparam.textSmall,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor),
                    children: <TextSpan>[
                      TextSpan(
                          text: " Block",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: Gparam.textSmall,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            subtitle: Text('Text Blocks'),
          ),
          ListTile(
            leading: Icon(
              Icons.text_format,
              size: 25,
            ),
            title: Text('Rich Text'),
            subtitle: Text('A strong animal'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              BlocProvider.of<NoteBloc>(context).add(AddRichTextBlock(
                  position: (BlocProvider.of<NoteBloc>(context).state
                          as OpenSelectBlock)
                      .position));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.short_text,
              size: 25,
            ),
            title: Text('Simple Text'),
            subtitle: Text('Provider of milk'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('cow');
            },
          ),
          ListTile(
            subtitle: Text('Media Blocks'),
          ),
          ListTile(
            leading: Icon(
              Icons.image,
              size: 25,
            ),
            title: Text('Image'),
            subtitle: Text('Comes with humps'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              BlocProvider.of<NoteBloc>(context).add(AddImageBlock(
                  position: (BlocProvider.of<NoteBloc>(context).state
                          as OpenSelectBlock)
                      .position));
            },
            enabled: true,
          ),
          ListTile(
            leading: Icon(
              Icons.view_week,
              size: 25,
            ),
            title: Text('Image Colossal'),
            subtitle: Text('Provides wool'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              BlocProvider.of<NoteBloc>(context).add(AddColossalBlock(
                  position: (BlocProvider.of<NoteBloc>(context).state
                          as OpenSelectBlock)
                      .position));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.video_library,
              size: 25,
            ),
            title: Text('Video'),
            subtitle: Text('Provides wool'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('sheep');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.audiotrack,
              size: 25,
            ),
            title: Text('Audio'),
            subtitle: Text('Provides wool'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('sheep');
            },
          ),
          ListTile(
            subtitle: Text('Widget Blocks'),
          ),
          ListTile(
            leading: Icon(
              OMIcons.title,
              size: 25,
            ),
            title: Text('Heading'),
            subtitle: Text('Some have horns'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              BlocProvider.of<NoteBloc>(context).add(AddTodolistBlock(
                  position: (BlocProvider.of<NoteBloc>(context).state
                          as OpenSelectBlock)
                      .position));
            },
          ),
          ListTile(
            leading: Icon(
              OMIcons.forum,
              size: 25,
            ),
            title: Text('Form Field'),
            subtitle: Text('Some have horns'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              BlocProvider.of<NoteBloc>(context).add(AddTodolistBlock(
                  position: (BlocProvider.of<NoteBloc>(context).state
                          as OpenSelectBlock)
                      .position));
            },
          ),
          ListTile(
            leading: Icon(
              OMIcons.list,
              size: 25,
            ),
            title: Text('Todo List'),
            subtitle: Text('Some have horns'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              BlocProvider.of<NoteBloc>(context).add(AddTodolistBlock(
                  position: (BlocProvider.of<NoteBloc>(context).state
                          as OpenSelectBlock)
                      .position));
            },
          ),
          ListTile(
            leading: Icon(
              OMIcons.dateRange,
              size: 25,
            ),
            title: Text('Date Item'),
            subtitle: Text('Some have horns'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('goat');
            },
          ),
          ListTile(
            leading: Icon(
              OMIcons.swapHorizontalCircle,
              size: 25,
            ),
            title: Text('Slider'),
            subtitle: Text('Some have horns'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('goat');
            },
          ),
          ListTile(
            leading: Icon(
              OMIcons.checkBox,
              size: 25,
            ),
            title: Text('Checkbox'),
            subtitle: Text('Some have horns'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('goat');
            },
          ),
          ListTile(
            leading: Icon(
              OMIcons.indeterminateCheckBox,
              size: 25,
            ),
            title: Text('Divider'),
            subtitle: Text('Some have horns'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('goat');
            },
          ),
          ListTile(
            subtitle: Text('Attachment Blocks'),
          ),
          ListTile(
            leading: Icon(
              OMIcons.link,
              size: 25,
            ),
            title: Text('Link'),
            subtitle: Text('Some have horns'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              _NewLinkBottomSheet(context, BlocProvider.of<NoteBloc>(context));
            },
          ),
          ListTile(
            subtitle: Text('Data Blocks'),
          ),
          ListTile(
            leading: Icon(
              OMIcons.calendarToday,
              size: 25,
            ),
            title: Text('Calender'),
            subtitle: Text('Some have horns'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('goat');
            },
          ),
          ListTile(
            leading: Icon(
              OMIcons.tableChart,
              size: 25,
            ),
            title: Text('Data Table'),
            subtitle: Text('Some have horns'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('goat');
            },
          ),
          ListTile(
            leading: Icon(
              OMIcons.barChart,
              size: 25,
            ),
            title: Text('Bar Graph'),
            subtitle: Text('Some have horns'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('goat');
            },
          ),
          ListTile(
            leading: Icon(
              OMIcons.pieChart,
              size: 25,
            ),
            title: Text('Pie Graph'),
            subtitle: Text('Some have horns'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('goat');
            },
          ),
          ListTile(
            subtitle: Text('Reference Blocks'),
          ),
          ListTile(
            leading: Icon(
              OMIcons.note,
              size: 25,
            ),
            title: Text('Note Reference'),
            subtitle: Text('Some have horns'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('goat');
            },
          ),
          ListTile(
            leading: Icon(
              OMIcons.timeline,
              size: 25,
            ),
            title: Text('Track Reference'),
            subtitle: Text('Some have horns'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('goat');
            },
          ),
          ListTile(
            leading: Icon(
              OMIcons.eventAvailable,
              size: 25,
            ),
            title: Text('Task Reference'),
            subtitle: Text('Some have horns'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('goat');
            },
          ),
          ListTile(
            leading: Icon(
              OMIcons.attachMoney,
              size: 25,
            ),
            title: Text('Expense Reference'),
            subtitle: Text('Some have horns'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('goat');
            },
          ),
        ],
      ),
    );
  }

  void _NewLinkBottomSheet(context1, noteBloc) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
        backgroundColor: Colors.transparent,
        context: context1,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return AddLink(
              newMediaLinkAddressController: _newMediaLinkAddressController,
              onUrlChanged: (url) {
                print("hello");
                print(BlocProvider.of<NoteBloc>(context1));
                Navigator.pop(context);
                noteBloc.add(AddLinkBlock(
                    link: thisLink
                        .copyWith(id: DateTime.now().millisecondsSinceEpoch)
                        .copyWith(url: url),
                    position: (noteBloc.state as OpenSelectBlock).position));
              },
              onTitleChanged: (title) {
                print("hello1");

                thisLink = thisLink.copyWith(title: title);
              },
            );
          });
        });
  }

  onTitleChanged(String title) {}
}
