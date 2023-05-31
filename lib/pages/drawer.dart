import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:dayalbusinesspartner/widgets/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SliderView extends StatefulWidget {
  final String name;
  final String address;
  final String district;
  final String region;
  const SliderView(
      {Key? key,
      required this.name,
      required this.address,
      required this.district,
      required this.region})
      : super(key: key);
  @override
  State<SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: getPadding(
          top: 50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: getPadding(right: 30, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: getPadding(
                      right: 20,
                    ),
                    child: Text(
                      widget.name,
                      style: TextStyle(
                          fontSize: 20,
                          color: ColorConstant.red700,
                          fontFamily: "Inter"),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(
                        'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_1280.png'),
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2,
              color: ColorConstant.gray600,
            ),
            Padding(
              padding: getPadding(right: 30, top: 30),
              child: Text(
                "Address",
                style: TextStyle(fontSize: 20, color: ColorConstant.black900),
              ),
            ),
            Padding(
              padding: getPadding(
                right: 30,
              ),
              child: Text(
                "${widget.address}, ${widget.region}",
                style: TextStyle(color: ColorConstant.gray600),
              ),
            ),
            Divider(
              thickness: 1,
              color: ColorConstant.gray600,
            ),
            const Spacer(),
            Divider(
              thickness: 0.5,
              color: ColorConstant.gray600,
            ),
            Padding(
              padding: getPadding(bottom: 60, right: 30, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Contact Us",
                    style: TextStyle(
                        fontSize: 20,
                        color: ColorConstant.black900,
                        fontFamily: "Inter"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "+91-9554950170",
                    style: TextStyle(
                        fontSize: 20,
                        color: ColorConstant.gray600,
                        fontFamily: "Inter"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "1800-10-1000",
                    style: TextStyle(
                        fontSize: 20,
                        color: ColorConstant.gray600,
                        fontFamily: "Inter"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 30,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () async {
                        Uri url = Uri(scheme: 'tel', path: "9554950170");
                        await launchUrl(url);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: ColorConstant.red700),
                      child: const Text('Enquiry'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class _SliderMenuItem extends StatelessWidget {
//   final String title;
//   final IconData iconData;
//   final Function(String)? onTap;

//   const _SliderMenuItem(
//       {Key? key,
//       required this.title,
//       required this.iconData,
//       required this.onTap})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//         minLeadingWidth: 0,
//         title: Text(title,
//             style: const TextStyle()),
//         leading: Icon(
//           iconData,
//           color: Colors.white,
//           size: 21,
//         ),
//         onTap: () => onTap?.call(title));
//   }
// }
