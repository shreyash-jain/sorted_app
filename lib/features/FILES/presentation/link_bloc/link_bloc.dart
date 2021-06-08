import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/models/link.dart';
import 'package:sorted/features/FILES/data/models/block_image.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:string_validator/string_validator.dart';


part 'link_event.dart';
part 'link_state.dart';

class LinkBloc extends Bloc<LinkEvent, LinkState> {
  final NoteRepository noteRepository;
  final NoteBloc noteBloc;
  LinkBloc(this.noteRepository, this.noteBloc) : super(LinkInitial());
  @override
  Stream<LinkState> mapEventToState(
    LinkEvent event,
  ) async* {
    if (event is GetLink) {
      print("UpdateTextbox  " + event.block.id.toString());
      Failure failure;
      LinkModel link;
      // var textboxOrFailure =
      //     await noteRepository.getImageOfId(event.block.itemId);
      // textboxOrFailure.fold((l) {
      //   failure = l;
      // }, (r) {
      //   link = r;
      // });
      link = new LinkModel(
          title: "Link",
          description:
              "Discover interesting projects and people to populate your personal news feed.",
          siteName: "https://github.com/",
          url:
              "https://docs.google.com/spreadsheets/d/1AXI0nXEyaeSdG-A95XAEGlg29Igz6ydwjo9SWgfPd_I/edit#gid=186001220");

      var linkOrFailure = await noteRepository.getLink(event.block.itemId);
      linkOrFailure.fold((l) {
        failure = l;
      }, (r) {
        link = r;
      });
     
      print("whats url " + link.id.toString());
      print("whats url " + link.title);
      print("whats url " + link.description);
      print("whats url " + link.url);
      if (failure == null) yield LinkLoaded(link, event.block);
    }
  }

  @override
  Future<void> close() {
    print(" update textbox");

    return super.close();
  }

  Future<LinkModel> _getUrlData(LinkModel link) async {
    if (!isURL(link.url)) {
      return link;
    }

    

    return link;
  }


}
