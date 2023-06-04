// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dayalbusinesspartner/pages/product_details_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SupplierHome extends StatefulWidget {
  final int id;
  final String userType;
  const SupplierHome({Key? key, required this.id, required this.userType})
      : super(key: key);

  @override
  State<SupplierHome> createState() => _SupplierHomeState();
}

class _SupplierHomeState extends State<SupplierHome> {
  final CarouselController _controller = CarouselController();
  int _current = 0;
 
  String userName = '';
  String contactNumber = '';


  Future<void> fetchCompanyPersonData() async {
    const apiUrl = 'http://66.94.34.21:8090/getCompanyPerson';
    final requestBody = {
      'id': widget.id,
      'domain': 'cf',
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final data = responseData['data'] as List<dynamic>;

      if (data.isNotEmpty) {
        final userData = data.first;
        setState(() {
          userName = userData['user_name'];
          contactNumber = userData['contact_no'];
        });
      } else {
        setState(() {
          // Handle no data case
          userName = 'No data available';
          contactNumber = 'No data available';
        });
      }
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCompanyPersonData();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFe3eef9),
      resizeToAvoidBottomInset: true,
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Container(
                      height: (height / 6) + 100,
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                          height: height / 3,
                          child: FutureBuilder(
                              future: _fetchBanners(),
                              builder: (context,
                                  AsyncSnapshot<List<dynamic>> projectSnap) {
                                if (projectSnap.data == null) {
                                  return Container();
                                } else {
                                  List<dynamic> bannerList = projectSnap.data!;

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      CarouselSlider(
                                        items: bannerList.map((i) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0.0),
                                                decoration: const BoxDecoration(
                                                    color: Colors.transparent),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Card(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    14))),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          14)),
                                                          image: DecorationImage(
                                                              image:
                                                                  NetworkImage(i[
                                                                      'image']),
                                                              fit: BoxFit
                                                                  .cover)),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }).toList(),
                                        carouselController: _controller,
                                        options: CarouselOptions(
                                          autoPlay: true,
                                          enlargeCenterPage: true,
                                          aspectRatio: 2.0,
                                          viewportFraction: 1,
                                          autoPlayInterval: const Duration(
                                              milliseconds: 10000),
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _current = index;
                                            });
                                          },
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: bannerList
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          return GestureDetector(
                                            onTap: () => _controller
                                                .animateToPage(entry.key),
                                            child: Container(
                                              width: 10.0,
                                              height: 10.0,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 4.0),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey
                                                      .withOpacity(
                                                          _current == entry.key
                                                              ? 0.9
                                                              : 0.4)),
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    ]),
                                  );
                                }
                              }))),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: width,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.amber,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10.0),
                        child: Text(
                          'दयाल पशु आहार',
                          style: TextStyle(
                            fontFamily: 'Baloo',
                            fontSize: 18,
                            color: Colors.black,
                            height: 1,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 150),
                        child: FutureBuilder(
                            future: _fetchProducts(),
                            builder: (context,
                                AsyncSnapshot<List<dynamic>> projectSnap) {
                              if (projectSnap.data == null) {
                                return Container();
                              } else {
                                projectSnap.data!.shuffle();
                                return ListView.builder(
                                  itemCount: projectSnap.data?.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      height: 150,
                                      width: 150, // card height
                                      child: Card(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child: Container(
                                            width: 150,
                                            height: 150,
                                            margin: const EdgeInsets.all(10),
                                            padding: const EdgeInsets.all(5),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFf4f4f4),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetailsPage(
                                                      product: projectSnap
                                                          .data![index],
                                                      id: widget.id,
                                                      userType: widget.userType,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Image.network(projectSnap
                                                  .data![index]['image']
                                                  .toString()),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            })),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: width,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.amber,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10.0),
                        child: Text(
                          'दयाल फीड सप्लीमेंट',
                          style: TextStyle(
                            fontFamily: 'Baloo',
                            fontSize: 18,
                            color: Colors.black,
                            height: 1,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 150),
                        child: FutureBuilder(
                            future: _fetchProducts(),
                            builder: (context,
                                AsyncSnapshot<List<dynamic>> projectSnap) {
                              if (projectSnap.data == null) {
                                return Container();
                              } else {
                                projectSnap.data!.shuffle();
                                return ListView.builder(
                                  itemCount: projectSnap.data?.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      height: 150,
                                      width: 150, // card height
                                      child: Card(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetailsPage(
                                                    product: projectSnap
                                                        .data![index],
                                                    id: widget.id,
                                                    userType: widget.userType,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 150,
                                              height: 150,
                                              margin: const EdgeInsets.all(10),
                                              padding: const EdgeInsets.all(5),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFf4f4f4),
                                              ),
                                              child: Image.network(projectSnap
                                                  .data![index]['image']
                                                  .toString()),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            })),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      elevation: 3,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://picsum.photos/200"), // No matter how big it is, it won't overflow
                        ),
                        title: Text(userName),
                        subtitle: const Text('Sales Person'),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            Uri url = Uri(scheme: 'tel', path: contactNumber);
                            await launchUrl(url);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder()),
                          child: const Text('Call'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<dynamic>> _fetchBanners() async {
    final response =
        await http.get(Uri.parse('http://66.94.34.21:9000/getBanners'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data'];
      return jsonResponse;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<List<dynamic>> _fetchProducts() async {
    const url = 'http://66.94.34.21:9000/getAllProducts';
    //var state = await getValueFromLocalMemory("state");
    Map data = {'state': 'Uttar Pradesh'};
    var body = json.encode(data);
    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data'];
      return jsonResponse;
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<String> getValueFromLocalMemory(String key) async {
    var pref = await SharedPreferences.getInstance();
    var value = pref.getString(key) ?? "";
    return value;
  }
}
