import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/pages/book_page.dart';
import 'package:mrbs_tablet/widgets/buttons/regular_button.dart';
import 'package:flutter/material.dart';

class SelectAmenitiesDialog extends StatefulWidget {
  SelectAmenitiesDialog({
    super.key,
    this.setListAmenities,
    this.roomId,
    this.listAmen,
  });

  Function? setListAmenities;
  String? roomId;
  List? listAmen;

  @override
  State<SelectAmenitiesDialog> createState() => _SelectAmenitiesDialogState();
}

class _SelectAmenitiesDialogState extends State<SelectAmenitiesDialog> {
  List listAmen = [];
  List<Amenities> amenities = [];

  List selectedAmen = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // getAmenitiesList(widget.roomId!).then((value) {
    //   // print(value);
    //   setState(() {
    //     listAmen = value['Data'];
    print(widget.listAmen!);
    for (var element in widget.listAmen!) {
      amenities.add(
        Amenities(
            amenitiesId: element['AmenitiesID'] ?? element.amenitiesId,
            amenitiesName: element['AmenitiesName'] ?? element.amenitiesName,
            qty:
                element['Default'] > 0 ? element['Default'] : element['Amount'],
            photo: element['ImageURL'] ?? element.photo),
      );
    }
    //     print(amenities.toString());
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      // shape: OutlinedBorder,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 550,
          minHeight: 200,
          minWidth: 450,
          maxWidth: 450,
        ),
        child: Container(
          // width: 450,
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 25,
          ),
          decoration: BoxDecoration(
            color: culturedWhite,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            // color: Colors.green,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Amenities',
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: amenities.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              bottom: index < amenities.length - 1 ? 5 : 0,
                              top: index != 0 ? 5 : 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    amenities[index].amenitiesName!,
                                    style: const TextStyle(
                                      height: 1.3,
                                      fontFamily: 'Helvetica',
                                      fontSize: 18,
                                      color: eerieBlack,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: RegularButton(
                                        fontSize: 18,
                                        disabled: false,
                                        text: '-',
                                        onTap: () {
                                          int min = amenities[index].qty!;

                                          if (min > 0) {
                                            min--;
                                          } else {
                                            min = 0;
                                            // amenities[index].qty = min;
                                          }
                                          setState(() {
                                            amenities[index].qty = min;
                                          });
                                        },
                                        padding: ButtonSize().itemQtyButton(),
                                        fontWeight: FontWeight.w300,
                                        radius: 5,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      amenities[index].qty.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Helvetica',
                                        fontSize: 18,
                                        color: eerieBlack,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: RegularButton(
                                        fontSize: 18,
                                        disabled: false,
                                        text: '+',
                                        onTap: () {
                                          // listAmen[index]['qty']++;
                                          setState(() {
                                            int plus = amenities[index].qty!;
                                            plus++;
                                            amenities[index].qty = plus;
                                          });
                                        },
                                        padding: ButtonSize().itemQtyButton(),
                                        fontWeight: FontWeight.w300,
                                        radius: 5,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          index < amenities.length - 1
                              ? const Divider(
                                  color: sonicSilver,
                                  thickness: 0.5,
                                )
                              : const SizedBox(),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RegularButton(
                        text: 'Confirm',
                        fontSize: 20,
                        disabled: false,
                        onTap: () {
                          // Amenities amen = Amenities();
                          selectedAmen = amenities
                              .where((element) => element.qty! > 0)
                              .toList();
                          widget.setListAmenities!(selectedAmen, amenities);
                          // print(selectedAmen);
                          Navigator.of(context).pop();
                        },
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
