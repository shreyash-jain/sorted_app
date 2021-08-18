import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/utility/url_preview/url_preview.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';
import 'package:sorted/features/CONNECT/data/models/resource_message.dart';
import 'package:sorted/features/CONNECT/presentation/consultation/widgets/youtube_video.dart';
import 'package:sorted/features/CONNECT/presentation/resource_bloc/resource_bloc.dart';

class ConsultationResourcesWidget extends StatefulWidget {
  final ClientConsultationModel consultation;
  ConsultationResourcesWidget({Key key, this.consultation}) : super(key: key);

  @override
  _ConsultationResourcesWidgetState createState() =>
      _ConsultationResourcesWidgetState();
}

class _ConsultationResourcesWidgetState
    extends State<ConsultationResourcesWidget> {
  ResourceBloc resourceBloc;
  TextEditingController textController = TextEditingController();
  @override
  void initState() {
    resourceBloc = ResourceBloc(sl())
      ..add(LoadConsultationResources(widget.consultation));
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocProvider(
        create: (context) => resourceBloc,
        child: BlocBuilder<ResourceBloc, ResourceState>(
          builder: (context, state) {
            if (state is ResourceLoaded)
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Gtheme.stext("Class Resources",
                            size: GFontSize.S, weight: GFontWeight.B2),
                        Spacer(),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                    thickness: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Gtheme.stext("Added Resources",
                            size: GFontSize.S, weight: GFontWeight.B2),
                        Spacer(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  if (state.messages.length == 0)
                    Center(
                        child: Container(
                            child: Column(
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        Gtheme.stext("No resources added by you"),
                      ],
                    ))),
                  if (state.messages.isNotEmpty)
                    ...state.messages.asMap().entries.map((e) => Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Gparam.widthPadding / 2),
                          child: messageToWidget(e.value),
                        )),
                  SizedBox(
                    height: 16,
                  ),
                ],
              );
            else if (state is ResourceInitial)
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(child: LoadingWidget()),
                  ],
                ),
              );
            else if (state is ResourceError)
              return MessageDisplay(message: state.message);
            else
              return Container(
                width: 0,
              );
          },
        ),
      ),
    );
  }

  Widget messageToWidget(ResourceMessage message) {
    switch (message.type) {
      case 0:
        return Container(
          margin: EdgeInsets.all(Gparam.widthPadding / 2),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  child: Gtheme.stext(message.resourceUrl),
                ),
              ),
              SimpleUrlPreview(
                url: message.resourceUrl,
                bgColor: Colors.white,
                previewHeight: 160,
                previewContainerPadding: EdgeInsets.all(10),
              ),
            ],
          ),
        );
        break;
      case 1:
        return YoutubeVideo(
          youtubeUrl: message.resourceUrl,
        );
      default:
    }
  }

  onClickLinkAdd() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child:
                        Text('Enter link url', style: Gtheme.blackShadowBold32),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ));
  }

  onClickYoutubeVideoAdd() {}
}
