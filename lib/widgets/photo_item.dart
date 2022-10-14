import 'package:flutter/material.dart';
import 'package:gm/util/image_utils.dart';
import 'package:gm/util/screen_util.dart';

class NftItem extends StatefulWidget {
  final Function()? onItemClickCallback;

  NftItem({
    Key? key,
    this.onItemClickCallback,
  }) : super(key: key);

  @override
  _NftItemState createState() => _NftItemState();
}

class _NftItemState extends State<NftItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onItemClickCallback?.call();
      },
      child: Container(
        width: 80.w,
        height: 80.w,
        child: Stack(
          children: [
            Positioned(
              bottom: 6.w,
              right: 6.w,
              child: imageUtils(
                'attest.svg',
                width: 18.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
