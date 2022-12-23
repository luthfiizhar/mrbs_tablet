import 'package:flutter/material.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';

class FacilityItemContainer extends StatelessWidget {
  FacilityItemContainer({
    super.key,
    this.unit = 0,
    this.img = "",
    this.isFood = false,
  });

  int unit;
  String img;
  bool isFood;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: lightGray,
              ),
              padding: const EdgeInsets.all(1),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: white,
                ),
                child: Center(
                  child: Container(
                    width: isFood ? 50 : 80,
                    height: isFood ? 50 : 60,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.network(img).image,
                        fit: BoxFit.contain,
                      ),
                    ),
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
