import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive/hive.dart';
import 'package:mrbs_tablet/api_request.dart';
import 'package:mrbs_tablet/constant/color.dart';
import 'package:mrbs_tablet/constant/text_style.dart';
import 'package:mrbs_tablet/model/model.dart';
import 'package:mrbs_tablet/widgets/buttons/regular_button.dart';
import 'package:mrbs_tablet/widgets/buttons/text_button.dart';
import 'package:mrbs_tablet/widgets/dialogs/alert_dialog.dart';
import 'package:mrbs_tablet/widgets/dialogs/check_nip_admin_dialog.dart';
import 'package:mrbs_tablet/widgets/dropdown.dart';
import 'package:mrbs_tablet/widgets/regular_input_field.dart';
import 'package:provider/provider.dart';

class InitiateRoomDialog extends StatefulWidget {
  InitiateRoomDialog({
    super.key,
    this.roomId = "0",
  });

  String roomId;
  @override
  State<InitiateRoomDialog> createState() => _InitiateRoomDialogState();
}

class _InitiateRoomDialogState extends State<InitiateRoomDialog> {
  ReqAPI apiReq = ReqAPI();
  final formKey = GlobalKey<FormState>();
  TextEditingController _nip = TextEditingController();

  FocusNode roomNode = FocusNode();

  String roomId = "0";
  String roomName = "";
  String roomAlias = "";

  List roomList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiReq.getRoomList().then((value) {
      print(value);
      if (value['Status'].toString() == "200") {
        setState(() {
          roomList = value['Data'];
          roomList.add({'RoomID': "0", "RoomAlias": "Choose"});
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogWhite(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogWhite(
          title: "Error",
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  List<DropdownMenuItem<dynamic>> addDividerItem(List items) {
    List<DropdownMenuItem<dynamic>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item['RoomID'],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                item['RoomAlias'] ?? "NULL",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: eerieBlack,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return _menuItems;
  }

  List<double> _getCustomItemsHeights(List items) {
    List<double> _itemsHeights = [];
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        _itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _itemsHeights.add(15);
      }
    }
    return _itemsHeights;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 200,
          maxHeight: 450,
          minWidth: 450,
          maxWidth: 665,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.only(
            left: 50,
            right: 40,
            top: 45,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Room Settings',
                    style: helveticaText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Select room for this device.',
                    style: helveticaText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // RegularInputField(
                  //   controller: _nip,
                  //   hintText: 'NIP here ...',
                  //   fontSize: 32,
                  //   // textAlign: TextAlign.center,
                  //   contentPadding: const EdgeInsets.symmetric(
                  //     horizontal: 25,
                  //     vertical: 20,
                  //   ),
                  //   onSave: (newValue) {
                  //     nip = newValue;
                  //   },
                  // ),
                  BlackDropdown(
                    focusNode: roomNode,
                    items: addDividerItem(roomList),
                    customHeights: _getCustomItemsHeights(roomList),
                    enabled: true,
                    onChanged: (value) {
                      roomId = value;
                    },
                    hintText: 'Choose Room',
                    suffixIcon: const Icon(Icons.keyboard_arrow_down_sharp),
                    fontSize: 24,
                    padding: const EdgeInsets.only(
                      left: 34,
                      top: 20,
                      bottom: 20,
                      right: 34,
                      // vertical: 15,
                    ),

                    // value: roomList.first['RoomID'],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TransparentButtonBlack(
                        text: 'Cancel',
                        disabled: false,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        fontSize: 24,
                        padding: ButtonSize().mediumSize(),
                      ),
                      const SizedBox(
                        width: 35,
                      ),
                      RegularButton(
                        text: 'Enter',
                        disabled: false,
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            // await widget.setNip!(nip, widget.isIn);
                            // Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (context) => CheckNipAdminDialog(),
                            ).then((value) async {
                              if (value) {
                                var box = await Hive.openBox('RoomInfo');
                                box.put('roomName', roomName);
                                box.put('roomId', roomId);
                                box.put('roomAlias', roomAlias);

                                Phoenix.rebirth(context);
                              }
                            });
                          }
                        },
                        fontSize: 24,
                        padding: ButtonSize().longSize(),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 35,
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
