import 'dart:async';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:pet_finder/import.dart';

// TODO: ImagePicker().pickMultiImage();
// TODO: ImagePicker().retrieveLostData(); // need for Android
// TODO: переслать картинку из галереи в приложение (как в Телеге)
// TODO: drag'n'drop для очерёдности картинок

class ImagesField extends StatefulWidget {
  ImagesField({
    Key? key,
    this.initialValue,
  }) : super(key: key);

  final List<ImageModel>? initialValue;

  @override
  ImagesFieldState createState() => ImagesFieldState();
}

class ImagesFieldState extends State<ImagesField> {
  ImageSource? _imageSource;
  final _images = <_ImageData>[];
  Future<void> _uploadQueue = Future.value();

  Future<List<ImageModel>> getValue() async {
    await _uploadQueue;
    final result = <ImageModel>[];
    for (final image in _images) {
      if (image.model != null) {
        result.add(image.model!);
      }
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      for (final imageModel in widget.initialValue!) {
        final image = getImageProvider(imageModel.url);
        _images.add(_ImageData(image));
      }
    }
    WidgetsBinding.instance.addPostFrameCallback(_onAfterBuild);
  }

  @override
  Widget build(BuildContext context) {
    const gridSpacing = 8.0;
    return GridView.count(
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
    );
  }

  Widget _buildAddImageButton(int index) {
    final isExistIndex = _images.length > index;
    return _AddImageButton(
      hasIcon: _images.length == index,
      onLongPress: isExistIndex ? _handleDeleteImage(index) : null,
      onTap: isExistIndex ? null : _handleAddImage(index),
      image: isExistIndex ? _images[index].image : null,
      uploadStatus: isExistIndex ? _images[index].uploadStatus : null,
    );
  }

  void _onAfterBuild(Duration timeStamp) {
    BotToast.closeAllLoading();
    if (widget.initialValue != null) {
      return;
    }
    _showImageSourceDialog().then((ImageSource? imageSource) {
      if (imageSource == null) return;
      _pickImage(0, imageSource).then((bool result) {
        if (!result) return;
        _imageSource = imageSource;
      });
    });
  }

  void Function() _handleDeleteImage(int index) {
    return () async {
      final result = await showConfirmDialog(
          context: context,
          title: 'Вы уверены, что хотите удалить картинку?',
          ok: 'Удалить');
      if (result) {
        _cancelUploadImage(_images[index]);
        setState(() {
          _images.removeAt(index);
        });
      }
    };
  }

  void Function() _handleAddImage(int index) {
    return () {
      if (_imageSource == null) {
        _showImageSourceDialog().then((ImageSource? imageSource) {
          if (imageSource == null) return;
          _pickImage(index, imageSource).then((bool result) {
            if (!result) return;
            _imageSource = imageSource;
          });
        });
        return;
      }
      _pickImage(index, _imageSource!);
    };
  }

  Future<ImageSource?> _showImageSourceDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('What to use?'),
          children: <Widget>[
            _ImageSourceUnit(
              icon: defaultTargetPlatform == TargetPlatform.iOS
                  ? CupertinoIcons.camera
                  : FontAwesomeIcons.camera,
              // Icons.camera,
              text: 'Camera',
              result: ImageSource.camera,
            ),
            _ImageSourceUnit(
              icon: defaultTargetPlatform == TargetPlatform.iOS
                  ? CupertinoIcons.photo_fill_on_rectangle_fill
                  : FontAwesomeIcons.solidImages,
              // Icons.photo_library,
              text: 'Gallery',
              result: ImageSource.gallery,
            ),
          ],
        );
      },
    );
  }

  // TODO: проверить на девайсе, т.к. на симуляторе нельзя выбирать первую фоку в галерее (цветы),
  // иначе выдает ошибку https://stackoverflow.com/questions/71199859/platformexceptionmultiple-request-cancelled-by-a-second-request-null-null-i

  Future<bool> _pickImage(int index, ImageSource imageSource) async {
    // XFile? pickedFile;
    // BotToast.showLoading();
    // try {
    //   await Future.delayed(Duration(milliseconds: 300));
    //   // TODO: добавить таймаут
    //   // TODO: https://github.com/flutter/flutter/issues/90373
    //   // Image gallery opens twice if we choose select photos permission.
    //   // https://github.com/flutter/flutter/issues/82602
    //   // PlatformException(multiple_request, Cancelled by a second request, null, null) - ios simulator
    //   // pickedFiles = await ImagePicker().pickMultiImage(
    //   //   maxWidth: kImageMaxWidth,
    //   //   maxHeight: kImageMaxHeight,
    //   //   imageQuality: kImageQuality,
    //   // );
    //   pickedFile = await ImagePicker().pickImage(
    //     source: imageSource,
    //     maxWidth: kImageMaxWidth,
    //     maxHeight: kImageMaxHeight,
    //     imageQuality: kImageQuality,
    //   );
    // } catch (error) {
    //   out(error);
    // } finally {
    //   BotToast.closeAllLoading();
    // }
    // // out(pickedFiles!.length);
    // if (pickedFile == null) return false;
    // final srcBytes = await pickedFile.readAsBytes();
    final model = PickMethod.image(1);
    late List<AssetEntity>? methodResult;
    try {
      methodResult = await model.method(context, []);
    } catch (error) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('$error'),
      //   ),
      // );
      BotToast.showNotification(
        crossPage: false,
        title: (_) => Text('$error'),
      );
      return false;
    }
    if (methodResult == null) {
      return false;
    }
    final assets = methodResult.toList();
    final srcBytes = (await assets[0].originBytes)!;
    final dstBytes = await navigator
        .push<Uint8List>(ImageEditorScreen(bytes: srcBytes).getRoute());
    if (dstBytes == null) return false;
    final image = ExtendedImage.memory(dstBytes).image;
    final imageData = _ImageData(image)
      ..uploadStatus = _ImageUploadStatus.progress;
    setState(() {
      if (index < _images.length) {
        _images.removeAt(index);
        _images.insert(index, imageData);
      } else {
        _images.add(imageData);
      }
    });
    _uploadQueue = _uploadQueue.then((_) => _uploadImage(imageData, dstBytes));
    _uploadQueue = _uploadQueue.timeout(kImageUploadTimeout);
    _uploadQueue = _uploadQueue.catchError((error) {
      // если уже удалили в _handleDeleteImage, то ничего не делать
      if (imageData.isCanceled) return;
      if (error is TimeoutException) {
        _cancelUploadImage(imageData);
      }
      imageData.uploadStatus = _ImageUploadStatus.error;
      if (mounted) setState(() {});
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Image upload failed, please try again.'),
      //   ),
      // );
      BotToast.showNotification(
        crossPage: false,
        title: (_) => Text('Image upload failed, please try again'),
      );
      out(error);
    });
    return true;
  }

  // TODO: [MVP] нужна оптимизация картинок или при загрузке, или при чтении

  Future<void> _uploadImage(_ImageData imageData, Uint8List bytes) async {
    final completer = Completer<void>();
    final fileName = '${Uuid().v4()}.png';
    final storageReference =
        FirebaseStorage.instance.ref().child('images').child(fileName);
    imageData.uploadTask = storageReference.putData(bytes);
    final streamSubscription =
        imageData.uploadTask!.snapshotEvents.listen((TaskSnapshot event) async {
      final cases = {
        TaskState.paused: () {},
        TaskState.running: () {
          out('progress ${event.bytesTransferred} / ${event.totalBytes}');
          // TODO: добавить индикатор загрузки и кнопку отмены
        },
        TaskState.success: () {
          completer.complete();
        },
        TaskState.canceled: () {
          completer.completeError(Exception('canceled'));
        },
        TaskState.error: () {
          completer.completeError(Exception('error'));
        },
      };
      assert(cases.length == TaskState.values.length);
      cases[event.state]!();
    });
    try {
      await imageData.uploadTask;
      await completer.future;
    } finally {
      await streamSubscription.cancel();
      imageData.uploadTask = null;
    }
    if (imageData.isCanceled) return;
    final downloadUrl = await storageReference.getDownloadURL();
    // final image = ExtendedImage.memory(imageData.bytes).image;
    final imageInfo = await _getImageInfo(imageData.image);
    // final size = await _calculateImageDimension(image);
    imageData.model = ImageModel(
      url: downloadUrl,
      width: imageInfo.image.width,
      height: imageInfo.image.height,
    );
    imageInfo.dispose();
    imageData.uploadStatus = null;
    if (mounted) setState(() {});
  }

  void _cancelUploadImage(_ImageData imageData) async {
    imageData.isCanceled = true;
    try {
      await imageData.uploadTask?.cancel();
    } catch (error) {
      out(error);
    }
  }
}

// Future<SizeInt> _calculateImageDimension(ImageProvider image) {
//   final completer = Completer<SizeInt>();
//   final listener = ImageStreamListener(
//     (ImageInfo image, bool synchronousCall) {
//       final myImage = image.image;
//       final size = SizeInt(myImage.width, myImage.height);
//       completer.complete(size);
//     },
//     onError: (error, StackTrace? stackTrace) {
//       completer.completeError(error);
//     },
//   );
//   image.resolve(ImageConfiguration()).addListener(listener);
//   return completer.future;
// }

Future<ImageInfo> _getImageInfo(ImageProvider image) {
  final completer = Completer<ImageInfo>();
  final listener = ImageStreamListener(
    (ImageInfo imageInfo, _) {
      completer.complete(imageInfo);
    },
    onError: (error, StackTrace? stackTrace) {
      completer.completeError(error);
    },
  );
  image.resolve(ImageConfiguration()).addListener(listener);
  return completer.future;
}

class _ImageSourceUnit extends StatelessWidget {
  _ImageSourceUnit({
    Key? key,
    required this.icon,
    required this.text,
    required this.result,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final ImageSource result;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
  _ImageData(this.image);

  final ImageProvider image;
  UploadTask? uploadTask;
  bool isCanceled = false;
  _ImageUploadStatus? uploadStatus;
  ImageModel? model;
}

class _AddImageButton extends StatelessWidget {
  _AddImageButton({
    Key? key,
    required this.hasIcon,
    this.onLongPress,
    this.onTap,
    this.image,
    this.uploadStatus,
  }) : super(key: key);

  final bool hasIcon;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;
  final ImageProvider? image;
  final _ImageUploadStatus? uploadStatus;

  // TODO: по длинному тапу - редактирование фотографии (кроп, поворот, и т.д.)

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Tooltip(
        message: 'Add / Remove Image',
        child: image == null
            // продублировал InkWell, чтобы не переопределять splashColor
            ? InkWell(
                onLongPress: onLongPress,
                onTap: onTap,
                child: hasIcon
                    ? Icon(
                        defaultTargetPlatform == TargetPlatform.iOS
                            ? CupertinoIcons.photo_fill
                            : FontAwesomeIcons.image,
                        // Icons.photo
                        color: Colors.black.withOpacity(0.8),
                        size: kBigButtonIconSize,
                      )
                    : Container(),
              )
            : InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.white.withOpacity(0.24),
                onLongPress: onLongPress,
                onTap: onTap,
                child: Ink.image(
                  fit: BoxFit.cover,
                  image: image!,
                  child: uploadStatus == null
                      ? null
                      : Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Container(color: Colors.white.withOpacity(0.24)),
                            if (uploadStatus == _ImageUploadStatus.progress)
                              Center(
                                child: Progress(),
                              ),
                            if (uploadStatus == _ImageUploadStatus.error)
                              Center(
                                child: Icon(
                                  FontAwesomeIcons.solidTimesCircle,
                                  color: Colors.red,
                                  size: kBigButtonIconSize,
                                ),
                              ),
                          ],
                        ),
                ),
              ),
      ),
    );
  }
}
