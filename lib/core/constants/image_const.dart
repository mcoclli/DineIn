import 'dart:io';

import 'package:cached_firestorage/lib.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:reservation/core/util/common_utils.dart';

class ImageItems {
  final loginlogoImage = "image";
  final admin = 'admin';
  final menu = 'menu';
  static const logo = 'logo';
  static const logo1 = 'logo1';
  static const logo2 = 'logo2';
  static const logo3 = 'logo3';
  static const logo4 = 'logo4';
  static const logo5 = 'logo5';
  static const logo6 = 'logo6';
  static const clock = 'clock';
  static const favorite1 = 'heart1';
  static const favorite2 = 'heart2';
  static const favorite3 = 'heart3';
  static const favorite4 = 'heart4';
  static const favorite5 = 'heart5';
  static const favorite6 = 'heart6';
  static const profileImage = 'profil';
  static const stackImage = 'stack';
  static const logImage = 'logo';
  static const mask1 = 'mask1';
  static const mask2 = 'mask2';
  static const mask3 = 'mask3';
  static const mask4 = 'mask4';
  static const mask5 = 'mask5';
  static const mask6 = 'mask6';
  static const resto1 = 'resto1';
  static const resto4 = 'resto4';
  static const chinese = 'chinese';
  static const seafood = 'seafood';
  static const salad = 'salad';
  static const foodmail = 'foodmail';
  static const chinesehub = 'chinesehub';
  static const lunch = 'lunch';
  static const resto = 'resto';
  static const arsalan = 'arsalan';
  static const knife = 'knife';
}

class CloudImage extends StatefulWidget {
  const CloudImage(
      {super.key,
      required this.name,
      required this.type,
      this.isUploadAllowed = false,
      this.refreshFunction});

  final String? name;
  final String type;
  final bool isUploadAllowed;
  final void Function()? refreshFunction;

  @override
  State<CloudImage> createState() => _CloudImageState();
}

class _CloudImageState extends State<CloudImage> {
  final _instance = CachedFirestorage.instance;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> getDownloadURL(String fileName) {
    try {
      CommonUtils.log("Getting image from $fileName");
      return _instance.getDownloadURL(
        mapKey: fileName,
        filePath: fileName,
      );
    } catch (e) {
      CommonUtils.log("Error occurred while getting file ${e.toString()}");
      return Future.value("NA");
    }
  }

  Future<XFile> _compressImage(File file) async {
    final tempDir = await getTemporaryDirectory();
    final targetPath = path.join(tempDir.path, path.basename(file.path));

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 75, // Adjust compression quality
      minWidth: 1920, // Target width
      minHeight: 1080, // Target height
    );

    return compressedFile!;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.name != null) {
      return GestureDetector(
        onTap: () async {
          if (widget.isUploadAllowed) {
            await _executeUpload();
          } else {
            CommonUtils.log("Ignoring tap as this is not updatable");
          }
        },
        child: FutureBuilder(
          future: getDownloadURL(widget.name!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // while data is loading:
              return const CircularProgressIndicator.adaptive();
            } else {
              // data loaded:
              final image = snapshot.data;
              if (image != null && image.isNotEmpty && image != "NA") {
                CommonUtils.log("Image url loaded : [$image] ");
                return CachedNetworkImage(
                  imageUrl: image,
                  cacheKey: widget.name,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                );
              } else {
                if (image?.isEmpty == true) {
                  CommonUtils.log("Clearing image cache as the url was not fetched");
                  imageCache.clear();
                  imageCache.clearLiveImages();
                  DefaultCacheManager().removeFile(widget.name!).then((value) {
                    _instance.removeCacheEntry(mapKey: widget.name!);
                  });
                }
                return Image.asset(
                  'assets/image/defaults/${widget.type}.png',
                  fit: BoxFit.fitHeight,
                );
              }
            }
          },
        ),
      );
    }
    return Image.asset(
      'assets/image/defaults/${widget.type}.png',
      fit: BoxFit.scaleDown,
    );
  }

  Future<void> _executeUpload() async {
    CommonUtils.log("uploading image");
    // Let user select photo from gallery
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, // or ImageSource.camera for camera
      imageQuality: 50, // Adjust image quality
    );

    if (image != null) {
      // Compress image
      final XFile compressedImage = await _compressImage(File(image.path));

      // Upload compressed image
      await _storage
          .ref(widget.name)
          .putFile(File(compressedImage.path))
          .then((p0) async {
        CommonUtils.log("uploading done...$p0");
        CommonUtils.log("Removing ${widget.name} from cache");
        imageCache.clear();
        imageCache.clearLiveImages();
        await DefaultCacheManager().removeFile(widget.name!).then((value) {
          _instance.removeCacheEntry(mapKey: widget.name!);
          if (widget.refreshFunction != null) {
            widget.refreshFunction!();
          }
        });
      });
    }
  }
}

class PngImage extends StatelessWidget {
  const PngImage({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Image.asset(_nameWithPath, fit: BoxFit.fitHeight);
  }

  String get _nameWithPath => 'assets/image/$name.png';
}

class SvgImage extends StatelessWidget {
  const SvgImage({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(_nameWithPath, fit: BoxFit.cover);
  }

  String get _nameWithPath => 'assets/svgs/$name.svg';
}

class LottieImage extends StatelessWidget {
  const LottieImage({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(_nameWithPath, fit: BoxFit.cover);
  }

  String get _nameWithPath => 'assets/lotties/$name.json';
}
