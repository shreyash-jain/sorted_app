import 'dart:io';

import 'package:crop/crop.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'dart:ui' as ui;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/features/FILES/data/models/block_image.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/presentation/image_bloc/image_bloc.dart';
import 'package:sorted/features/FILES/presentation/textbox_bloc/textbox_bloc.dart';
import 'package:sorted/features/FILES/presentation/widgets/textbox_widget.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class ImageEdit extends StatefulWidget {
  final ImageBlock imageBlock;
  final ImageBloc imageBloc;
  final File initialFile;
  final BlockInfo blockInfo;

  const ImageEdit({
    Key key,
    this.imageBlock,
    this.imageBloc,
    this.initialFile,
    this.blockInfo,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ImageEditState();
}

class ImageEditState extends State<ImageEdit> {
  double height = 10;
  final controller = CropController(aspectRatio: 1);
  double _rotation = 0;
  CropShape shape = CropShape.box;

  var _focusNode = FocusNode();
  bool isUploading = false;
  File finalizedFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //currentTextbox.text = jsonEncode(_controller.document);
    //widget.updateTextbox(currentTextbox);
    if (finalizedFile != null)
      widget.imageBloc
          .add(UpdateImage(finalizedFile, widget.imageBlock, widget.blockInfo));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(body: SafeArea(child: new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SingleChildScrollView(
        child: Container(
          height: Gparam.height,
          child: Column(
            children: <Widget>[
              if (!isUploading)
                OutlineButton(
                  onPressed: () async {
                    print("pressed");
                    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
                    final cropped =
                        await controller.crop(pixelRatio: pixelRatio);
                    finalizedFile = await _saveScreenShot(cropped);
                    Navigator.pop(context);

                    widget.imageBloc.add(UpdateImage(
                        finalizedFile, widget.imageBlock, widget.blockInfo));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        (Icons.done),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Done",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'Montessart',
                              fontSize: 16,
                              shadows: [
                                Shadow(
                                  blurRadius: 60.0,
                                  color: Colors.white,
                                  offset: Offset(1.0, 1.0),
                                ),
                              ],
                              fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              if (isUploading)
                LinearProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                  minHeight: 8,
                ),
              SizedBox(
                height: Gparam.heightPadding,
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: EdgeInsets.all(8),
                  child: Crop(
                    onChanged: (decomposition) {
                      print(
                          "Scale : ${decomposition.scale}, Rotation: ${decomposition.rotation}, translation: ${decomposition.translation}");
                    },
                    controller: controller,
                    shape: shape,
                    child: Image.file(
                      widget.initialFile,
                      fit: BoxFit.cover,
                    ),
                    /* It's very important to set `fit: BoxFit.cover`.
                       Do NOT remove this line.
                       There are a lot of issues on github repo by people who remove this line and their image is not shown correctly.
                    */
                    foreground: IgnorePointer(
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          '',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    helper: shape == CropShape.box
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              if (!isUploading)
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.undo),
                      tooltip: 'Undo',
                      onPressed: () {
                        controller.rotation = 0;
                        controller.scale = 1;
                        controller.offset = Offset.zero;
                        setState(() {
                          _rotation = 0;
                        });
                      },
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: theme.sliderTheme,
                        child: Slider(
                          divisions: 361,
                          value: _rotation,
                          min: -180,
                          max: 180,
                          label: '$_rotation°',
                          onChanged: (n) {
                            setState(() {
                              _rotation = n.roundToDouble();
                              controller.rotation = _rotation;
                            });
                          },
                        ),
                      ),
                    ),
                    PopupMenuButton<double>(
                      icon: Icon(Icons.aspect_ratio),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text("Original"),
                          value: 1000 / 667.0,
                        ),
                        PopupMenuDivider(),
                        PopupMenuItem(
                          child: Text("16:9"),
                          value: 16.0 / 9.0,
                        ),
                        PopupMenuItem(
                          child: Text("4:3"),
                          value: 4.0 / 3.0,
                        ),
                        PopupMenuItem(
                          child: Text("1:1"),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: Text("3:4"),
                          value: 3.0 / 4.0,
                        ),
                        PopupMenuItem(
                          child: Text("9:16"),
                          value: 9.0 / 16.0,
                        ),
                      ],
                      tooltip: 'Aspect Ratio',
                      onSelected: (x) {
                        controller.aspectRatio = x;
                        setState(() {});
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
    })));
  }

  Future<File> _saveScreenShot(ui.Image img) async {
    File file;
    var byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    var buffer = byteData.buffer.asUint8List();

    final int result = 0;
    final status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      String dir = (await getApplicationDocumentsDirectory()).path;

      String fullPath = '$dir/' +
          "IMG_" +
          p.basename(widget.imageBlock.imagePath).hashCode.toString() +
          ".jpg";
      print("local file full path ${fullPath}");
      file = File(fullPath);
      await file.writeAsBytes(buffer);
      print(file.path);

      return file;
    }

    print(result);

    return file;
  }
}
