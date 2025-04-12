import 'package:ecalibre/pages/loginPage.dart';
import 'package:ecalibre/pages/productFile.dart';
import 'package:ecalibre/pages/voicePage.dart';
import 'package:ecalibre/provider/calculatorProvider.dart';
import 'package:ecalibre/utils/actions.dart';
import 'package:ecalibre/utils/addProduct.dart';
import 'package:ecalibre/utils/calculatorGraph.dart';
import 'package:ecalibre/utils/smallWidgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CalculatorMode extends StatelessWidget {
  CalculatorMode({super.key});

  DateTime now = DateTime.now();
  late String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  final user = FirebaseAuth.instance.currentUser;
  late String email = user!.email.toString();
  // ignore: unnecessary_null_comparison
  late String? username = email != null
      ? (email.contains('@') ? email.substring(0, email.indexOf('@')) : email)
      : null;

  @override
  Widget build(BuildContext context) {
    // Fetch data only once when the widget is built for the first time
    // Fetch data after the initial build phase

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.topRight,
              colors: [
            const Color.fromARGB(255, 205, 192, 240),
            const Color.fromARGB(255, 183, 238, 233),
            const Color.fromARGB(255, 205, 192, 240),
          ])),
      margin: EdgeInsets.all(0.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30, left: 10, right: 10.0),
              child: Row(children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage('assets/images/boy.png'),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Text('Welcome Back!',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700)),
                    Text('$username',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                        ))
                  ],
                ),
                Spacer(),
                IconButton(
                    color: Colors.black,
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Loginpage()));
                    },
                    icon: Icon(
                      Icons.logout_rounded,
                      size: 25,
                    ))
              ]),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, left: 10, right: 10.0),
              child: Card(
                color: const Color.fromARGB(255, 145, 160, 234),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Sales ",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 19),
                      ),
                      FutureBuilder<double>(
                        future: Provider.of<CalculatorProvider>(context,
                                listen: false)
                            .getTotalSumForDate(formattedDate
                                .toString()), // Replace with your dynamic date
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text("Error fetching total");
                          } else {
                            final total = snapshot.data ?? 0.0;
                            return Text(
                              '₹${total.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 25),
                            );
                          }
                        },
                      ),
                      Text(
                        "Calculating Options :",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 19,
                            fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VoicePage()));
                              },
                              child: OptionsWidget(
                                pictureAsset: 'assets/images/voice.svg',
                                action: 'VoiceBill',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductFile()));
                              },
                              child: OptionsWidget(
                                  pictureAsset: 'assets/images/inventory.svg',
                                  action: 'Products'),
                            ),
                            GestureDetector(
                                child: OptionsWidget(
                                    pictureAsset: 'assets/images/stats.svg',
                                    action: 'Statistics'),
                                onTap: () {}),
                            GestureDetector(
                                child: OptionsWidget(
                                    pictureAsset: 'assets/images/edit.svg',
                                    action: 'Edit Prices'),
                                onTap: () {
                                  editPrice(context);
                                }),
                          ]),
                      SizedBox(
                        height: 15,
                      ),
                      MaterialButton(
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        color: const Color.fromARGB(255, 5, 73, 129),
                        onPressed: () {
                          addProduct(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_box, color: Colors.white),
                            SizedBox(width: 10),
                            Text('Add Product',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 15,
                                    color: Colors.white))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Sales on',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[700]),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[700]),
                    ),
                  ],
                )),
            _buildGraphForDate(formattedDate)
          ],
        ),
      ),
    );
  }

  Widget _buildGraphForDate(String date) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ChangeNotifierProvider(
        create: (_) => CalculatorProvider()..fetchCalculatorValues(date),
        child: CalciGraph(),
      ),
    );
  }
}
