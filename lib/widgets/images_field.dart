import 'dart:async';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:pet_finder/import.dart';

// TODO: перенести в minsk8

class ImagesField extends StatefulWidget {
  ImagesField({
    Key key,
    this.tooltip,
  }) : super(key: key);

  final String tooltip;

  @override
  ImagesFieldState createState() => ImagesFieldState();
}

class ImagesFieldState extends State<ImagesField> {
  ImageSource _imageSource;
  final _images = <_ImageData>[];
  Future<void> _uploadQueue = Future.value();

  List<ImageModel> get value {
    final result = <ImageModel>[];
    for (final image in _images) {
      if (image.model != null) {
        result.add(image.model);
      }
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onAfterBuild);
  }

  @override
  Widget build(BuildContext context) {
    final gridSpacing = 8.0;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisSpacing: gridSpacing,
        crossAxisCount: 2,
        children: <Widget>[
          _buildAddImageButton(0),
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: gridSpacing,
            crossAxisSpacing: gridSpacing,
            crossAxisCount: 2,
            children: List.generate(
              4,
              (int index) => _buildAddImageButton(index + 1),
            ),
          ),
        ],
      ),
    );

    // return Padding(
    //   padding: EdgeInsets.symmetric(vertical: 8),
    //   child: Tooltip(
    //     message: widget.tooltip,
    //     child: Material(
    //       child: InkWell(
    //         onTap: _onTap,
    //         child: AspectRatio(
    //           aspectRatio: kGoldenRatio,
    //           child: Center(
    //             child: Icon(FontAwesomeIcons.image),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  // void _onTap() {
  //   // _handleDeleteImage(0);
  //   // _handleAddImage(0);
  // }

  Widget _buildAddImageButton(int index) {
    final isExistIndex = _images.length > index;
    return _AddImageButton(
      index: index,
      hasIcon: _images.length == index,
      onTap: isExistIndex ? _handleDeleteImage : _handleAddImage,
      bytes: isExistIndex ? _images[index].bytes : null,
      uploadStatus: isExistIndex ? _images[index].uploadStatus : null,
      tooltip: widget.tooltip,
    );
  }

  void _onAfterBuild(Duration timeStamp) {
    _showImageSourceDialog().then((ImageSource imageSource) {
      if (imageSource == null) return;
      _pickImage(0, imageSource).then((bool result) {
        if (!result) return;
        _imageSource = imageSource;
      });
    });
  }

  void _handleDeleteImage(int index) {
    _cancelUploadImage(_images[index]);
    setState(() {
      _images.removeAt(index);
    });
  }

  void _handleAddImage(int index) {
    if (_imageSource == null) {
      _showImageSourceDialog().then((ImageSource imageSource) {
        if (imageSource == null) return;
        _pickImage(index, imageSource).then((bool result) {
          if (!result) return;
          _imageSource = imageSource;
        });
      });
      return;
    }
    _pickImage(index, _imageSource);
  }

  Future<ImageSource> _showImageSourceDialog() {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('What to use?'),
        children: <Widget>[
          _ImageSourceUnit(
            icon: FontAwesomeIcons.camera,
            text: 'Camera',
            result: ImageSource.camera,
          ),
          _ImageSourceUnit(
            icon: FontAwesomeIcons.solidImages,
            text: 'Gallery',
            result: ImageSource.gallery,
          ),
        ],
      ),
    );
  }

  Future<bool> _pickImage(int index, ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: imageSource).catchError((error) {
      out(error);
    });
    if (pickedFile == null) return false;
    final bytes = await pickedFile.readAsBytes();
    final imageData = _ImageData(bytes);
    setState(() {
      if (index < _images.length) {
        _images.removeAt(index);
        _images.insert(index, imageData);
      } else {
        _images.add(imageData);
      }
    });
    _uploadQueue = _uploadQueue.then((_) => _uploadImage(imageData));
    _uploadQueue = _uploadQueue.timeout(kImageUploadTimeoutDuration);
    _uploadQueue = _uploadQueue.catchError((error) {
      if (error is TimeoutException) {
        _cancelUploadImage(imageData);
      }
      imageData.uploadStatus = _ImageUploadStatus.error;
      if (mounted) setState(() {});
      BotToast.showNotification(
        crossPage: false,
        title: (_) => Text(
          'Image upload failed, please try again',
          overflow: TextOverflow.fade, // TODO: ??
          softWrap: false, // TODO: ??
        ),
      );
      out(error);
    });
    return true;
  }

  // TODO: [MVP] нужна оптимизация картинок или при загрузке, или при чтении

  Future<void> _uploadImage(_ImageData imageData) async {
    // final completer = Completer<void>();
    // // TODO: FirebaseStorage ругается "no auth token for request"
    // final storage =
    //     // FirebaseStorage.instance;
    //     FirebaseStorage(storageBucket: kStorageBucket);
    // final filePath = 'images/${DateTime.now()} ${Uuid().v4()}.png';
    // // TODO: оптимизировать размер данных картинок перед выгрузкой
    // final uploadTask = storage.ref().child(filePath).putData(bytes);
    // final streamSubscription = uploadTask.events.listen((event) async {
    //   // TODO: if (event.type == StorageTaskEventType.progress)
    //   if (event.type != StorageTaskEventType.success) return;
    //   final downloadUrl = await event.snapshot.ref.getDownloadURL();
    //   final image = ExtendedImage.memory(bytes);
    //   final size = await _calculateImageDimension(image);
    //   imageData.model = ImageModel(
    //     url: downloadUrl,
    //     width: size.width,
    //     height: size.height,
    //   );
    //   await Future.delayed(Duration(seconds: 10));
    //   completer.complete();
    // });
    // await uploadTask.onComplete;
    // streamSubscription.cancel();
    // await completer.future;
    final completer = Completer<void>();
    final fileName = '${DateTime.now()} ${Uuid().v4()}.png';
    final storageReference =
        FirebaseStorage.instance.ref().child('images').child(fileName);
    imageData.uploadTask = storageReference.putData(imageData.bytes);
    final streamSubscription =
        imageData.uploadTask.snapshotEvents.listen((TaskSnapshot event) async {
      if (event.state == TaskState.running) {
        out('progress ${event.bytesTransferred} / ${event.totalBytes}');
        // TODO: добавить индикатор загрузки и кнопку отмены
      } else if (event.state == TaskState.success) {
        completer.complete();
      } else if (event.state == TaskState.canceled) {
        completer.completeError(
            Exception('canceled')); // TODO: придёт сюда после TimeoutException?
      } else if (event.state == TaskState.error) {
        completer.completeError(Exception('error'));
      }
    });
    try {
      await imageData.uploadTask;
      await completer.future;
    } finally {
      await streamSubscription.cancel();
      imageData.uploadTask = null;
    }
    final downloadUrl = await storageReference.getDownloadURL();
    // out(downloadUrl);
    final image = ExtendedImage.memory(imageData.bytes);
    final size = await _calculateImageDimension(image);
    imageData.model = ImageModel(
      url: downloadUrl,
      width: size.width,
      height: size.height,
    );
    imageData.uploadStatus = null;
    if (mounted) setState(() {});
  }

  void _cancelUploadImage(_ImageData imageData) {
    imageData.uploadTask?.cancel();
  }
}

Future<SizeInt> _calculateImageDimension(ExtendedImage image) {
  final completer = Completer<SizeInt>();
  image.image.resolve(ImageConfiguration()).addListener(
    ImageStreamListener(
      (ImageInfo image, bool synchronousCall) {
        final myImage = image.image;
        final size = SizeInt(myImage.width, myImage.height);
        completer.complete(size);
      },
    ),
  );
  return completer.future;
}

class _ImageSourceUnit extends StatelessWidget {
  _ImageSourceUnit({
    Key key,
    this.icon,
    this.text,
    this.result,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final ImageSource result;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {}, // чтобы сократить время для splashColor
      child: SimpleDialogOption(
        onPressed: () {
          navigator.pop(result);
        },
        child: Row(
          children: <Widget>[
            Icon(icon),
            Flexible(
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: 16),
                child: Text(text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _ImageUploadStatus { progress, error }

class _ImageData {
  _ImageData(this.bytes);

  final Uint8List bytes;
  UploadTask uploadTask;
  _ImageUploadStatus uploadStatus = _ImageUploadStatus.progress;
  ImageModel model;
}

class _AddImageButton extends StatelessWidget {
  _AddImageButton({
    Key key,
    this.index,
    this.hasIcon,
    this.onTap,
    this.bytes,
    this.uploadStatus,
    this.tooltip,
  }) : super(key: key);

  final int index;
  final bool hasIcon;
  final void Function(int) onTap;
  final Uint8List bytes;
  final _ImageUploadStatus uploadStatus;
  final String tooltip;

  // TODO: по длинному тапу - редактирование фотографии (кроп, поворот, и т.д.)

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        child: bytes == null
            // продублировал InkWell, чтобы не переопределять splashColor
            ? InkWell(
                onTap: _onTap,
                child: hasIcon
                    ? Icon(
                        FontAwesomeIcons.camera,
                        color: Colors.black.withOpacity(0.8),
                        // size: kBigButtonIconSize,
                      )
                    : Container(),
              )
            : InkWell(
                splashColor: Colors.white.withOpacity(0.4),
                onTap: _onTap,
                child: Ink.image(
                  fit: BoxFit.cover,
                  image: ExtendedImage.memory(bytes).image,
                  child: uploadStatus == null
                      ? null
                      : Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Container(color: Colors.white.withOpacity(0.4)),
                            if (uploadStatus == _ImageUploadStatus.progress)
                              Center(
                                child: ExtendedProgressIndicator(
                                  hasAnimatedColor: true,
                                ),
                              ),
                            if (uploadStatus == _ImageUploadStatus.error)
                              Center(
                                child: Icon(
                                  FontAwesomeIcons.solidTimesCircle,
                                  color: Colors.red,
                                  // size: kBigButtonIconSize,
                                ),
                              ),
                          ],
                        ),
                ),
              ),
      ),
    );
  }

  void _onTap() {
    onTap(index);
  }
}
