import 'package:dayalbusinesspartner/utils/capitalize_text.dart';
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

class ShowSnackBar {
  customBar(String data, BuildContext context,
      [bool isSuccessPopup = false, bool capitalise = true]) {
    FocusManager.instance.primaryFocus!.unfocus();
    context = OneContext.instance.context!;
    return SnackBar(
        backgroundColor:
            isSuccessPopup ? const Color(0xD9C6FAB7) : const Color(0xE6FABDB7),
        action: SnackBarAction(
            label: isSuccessPopup ? "" : "X",
            onPressed: () {},
            textColor: const Color(0xFF000000)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        content: Row(
          children: [
            Row(
              children: [
                isSuccessPopup
                    ? const Icon(Icons.check,
                        color: Color(0XFF519F15), size: 25)
                    : const Icon(Icons.info,
                        color: Color(0xFFFF1800), size: 25),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                    width: 180,
                    child: Text(capitalise ? data.capitalize() : data,
                        style: const TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w700)
                            .copyWith(
                                color: const Color(0xFF000000), fontSize: 12))),
              ],
            ),
          ],
        ));
  }
}
