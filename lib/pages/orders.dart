
import 'package:dayalbusinesspartner/widgets/color_constant.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<bool> numberTruthList = [true, true, true, true, true, true];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.blueGray001,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 24.0, horizontal: 5),
                child: Text(
                  'मेरे ऑर्डर्स',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 24,
                    color: Colors.black,
                    height: 1,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                  flex: 9,
                  child: ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, i) {
                      return numberTruthList[i]
                          ? Card(
                              elevation: 3,
                              child: ListTile(
                                  visualDensity: const VisualDensity(vertical: 3),
                                dense: true,
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Order Number : $i',
                                      style: const TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 12,
                                        color: Colors.grey,
                                        height: 1,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      '10 Jan 2023 ',
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 16,
                                        color: Colors.black,
                                        height: 1,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      'Qty : $i',
                                      style: const TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 12,
                                        color: Colors.grey,
                                        height: 1,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                                trailing: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 25,
                                        width: 100,
                                        child: TextButton(
                                          onPressed: () {},
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                side: const BorderSide(width: 1, color: Colors.red),
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            'Delivered',
                                            style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 10,
                                              color: Colors.grey,
                                              height: 1,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      SizedBox(
                                        height: 25,
                                        width: 100,
                                        child: TextButton(
                                          onPressed: () {},
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                side: const BorderSide(width: 1, color: Colors.red),
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            'view Details',
                                            style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 10,
                                              color: Colors.grey,
                                              height: 1,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                              width: 0,
                            );
                    },
                  )),
            ]));
  }
}
