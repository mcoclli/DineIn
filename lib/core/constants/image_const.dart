import 'package:cached_firestorage/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
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
  const CloudImage({super.key, required this.name, required this.type});
  final String? name;
  final String type;

  @override
  State<CloudImage> createState() => _CloudImageState();
}

class _CloudImageState extends State<CloudImage> {
  Future<String> getDownloadURL(String fileName) async {
    try {
      CommonUtils.log("Getting image from $fileName");
      var instance = CachedFirestorage.instance;
      return await instance.getDownloadURL(
        mapKey: fileName,
        filePath: fileName,
      );
    } catch (e) {
      CommonUtils.log("Error occurred while getting file ${e.toString()}");
      return "NA";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.name != null) {
      return FutureBuilder(
        future: getDownloadURL(widget.name!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // while data is loading:
            return const CircularProgressIndicator.adaptive();
          } else {
            // data loaded:
            final image = snapshot.data;
            if (image != null && image != "NA") {
              return Image.network(
                image,
                fit: BoxFit.contain,
              );
            } else {
              return Image.asset(
                'assets/image/defaults/${widget.type}.png',
                fit: BoxFit.contain,
              );
            }
          }
        },
      );
    }
    return Image.asset(
      "assets/image/defaults/profile-pic.png",
      // 'assets/image/defaults/$type.png',
      fit: BoxFit.scaleDown,
    );
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
