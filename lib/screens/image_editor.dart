import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pet_finder/import.dart';

class ImageEditorScreen extends StatefulWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/image_editor',
      builder: (_) => this,
      fullscreenDialog: true,
    );
  }

  const ImageEditorScreen({
    Key? key,
    required this.bytes,
  }) : super(key: key);

  final Uint8List bytes;

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  bool _cropping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Image Editor'),
      ),
      body: ExtendedImage.memory(
        widget.bytes,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.editor,
        enableLoadState: true,
        extendedImageEditorKey: editorKey,
        cacheRawData: true,
        initEditorConfigHandler: (ExtendedImageState? state) {
          return EditorConfig(
              maxScale: 8.0,
              cropRectPadding: const EdgeInsets.all(20.0),
              hitTestSize: 20.0,
              initCropRectType: InitCropRectType.imageRect,
              cropAspectRatio: CropAspectRatios.ratio1_1,
              editActionDetailsIsChanged: (EditActionDetails? details) {
                //print(details?.totalScale);
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Crop Image',
        child: Icon(defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoIcons.crop
            : Icons.crop),
        onPressed: cropImage,
      ),
    );
  }

  Future<void> cropImage() async {
    if (_cropping) {
      return;
    }
    _cropping = true;
    try {
      final Uint8List bytes = Uint8List.fromList(
          // kIsWeb
          //   ? (await cropImageDataWithDartLibrary(
          //       state: editorKey.currentState!))!
          //   :
          (await cropImageDataWithNativeLibrary(
              state: editorKey.currentState!))!);
      navigator.pop(bytes);
    } finally {
      _cropping = false;
    }
  }
}
