import 'package:flutter/material.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';

class FacilityItemContainer extends StatelessWidget {
  FacilityItemContainer({
    super.key,
    this.unit = 0,
    this.img = "",
  });

  int unit;
  String img;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: white,
              ),
              child: Center(
                child: SizedBox(
                  height: 75,
                  width: 75,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Center(child: Image.network(img)),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: orangeAccent,
              ),
              child: Center(
                child: Text(
                  unit.toString(),
                  style: helveticaText.copyWith(
                    fontSize: 22,
                    color: culturedWhite,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
