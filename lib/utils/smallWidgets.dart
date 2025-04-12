import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class OptionsWidget extends StatelessWidget {
  OptionsWidget({super.key, required this.pictureAsset, required this.action});
  String pictureAsset;
  String action;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 254, 182, 73),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          )),
      child: Column(
        children: [
          SvgPicture.asset(
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
            height: 35,
            width: 35,
            pictureAsset,
          ),
          Text(action, style: TextStyle(fontFamily: 'Roboto'))
        ],
      ),
    );
  }
}
