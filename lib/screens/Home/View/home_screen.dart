import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:sisepuh/LineChartData.dart';
import 'package:sisepuh/controller/auth_controller.dart';
import 'package:sisepuh/controller/formdata_controller.dart';
import 'package:sisepuh/screens/Home/widget/card_sensus.dart';
// import 'package:sisepuh/main.dart';
// import 'package:sisepuh/screens/Home/widget/line_chart.dart';
import 'package:sisepuh/screens/Home/widget/pie_chart.dart';
import 'package:sisepuh/screens/Home/widget/pie_chart_sensus.dart';
import 'package:sisepuh/screens/login/login_screens.dart';
// import 'package:sisepuh/screens/login/login_screens.dart';
import 'package:sisepuh/screens/mastertable/view/master_table_screen.dart';
import 'package:sisepuh/screens/mastertable/widget/streambuilder_data.dart';
import 'package:sisepuh/services/auth_service.dart';
import 'package:sisepuh/services/countfirebase_service.dart';
import 'package:sisepuh/services/firebase_service.dart';
import 'package:sisepuh/widget/indicator_chart.dart';

class HomeScreen extends StatelessWidget {
  // int currentIndexPage = 0;

  var FromdataController = Get.put(FromDataController());
  var countFirebase = Get.put(CountFirebase());
  // var getCountGender = CountFirebase().getCountGender();
  var AuthDataController = Get.put(AuthController());
  var AuthServices = AuthService();
  var curruserview = true;
  var dataL;
  User? loged = AuthController().getCurrentUser();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.0, // Atur tinggi toolbar menjadi 0
          automaticallyImplyLeading: false, // Jangan menampilkan tombol kembali
          elevation: 0, // Hilangkan bayangan di bawah AppBar
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Container(
                padding: EdgeInsets.only(top: 30),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dashboard SI-Sepuh",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Open Sans',
                                ),
                              ),
                              const SizedBox(
                                height: 2.0,
                              ),
                              FutureBuilder(
                                  future: countFirebase.getallCollection(),
                                  builder: (context, snapshot) {
                                    return FutureBuilder(
                                        future:
                                            countFirebase.getallCollection(),
                                        builder: (context, snapshot) {
                                          return GetBuilder<CountFirebase>(
                                            init: CountFirebase(),
                                            initState: (_) => countFirebase
                                                .getallCollection(),
                                            builder: (AuthController) {
                                              return loged!.email !=
                                                      'testdukuhh@gmail.com'
                                                  ? Text(
                                                      "Wellcome,RT${countFirebase.currUserCollectionRT}",
                                                      style: TextStyle(
                                                          fontSize: 28,
                                                          fontFamily:
                                                              'Open Sans'),
                                                    )
                                                  : Text(
                                                      "Wellcome, Pak Dukuh",
                                                      style: TextStyle(
                                                          fontSize: 28,
                                                          fontFamily:
                                                              'Open Sans'),
                                                    );
                                            },
                                          );
                                        });
                                  }),
                            ],
                          ),
                          IconButton(
                            onPressed: () async {
                              //SIgnout secara session login
                              AuthDataController.signOut();
                            },
                            icon: const Icon(
                              Icons.logout_outlined,
                              size: 24.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Container(
                      padding: EdgeInsets.all(12),
                      width: MediaQuery.of(context).size.width - 50,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.blue, Colors.purple]),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          // color: Color.fromARGB(172, 68, 137, 255),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(83, 0, 0, 0),
                                blurRadius: 20,
                                offset: Offset(8, 20))
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GetBuilder<CountFirebase>(
                            init: CountFirebase(),
                            initState: (_) => countFirebase.getallCollection(),
                            builder: (CountFirebase) {
                              return loged!.email == 'testdukuhh@gmail.com'
                                  ? Text(
                                      textAlign: TextAlign.center,
                                      "Total Pencatatan Penduduk Kentolan Lor",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 23,
                                      ),
                                    )
                                  : Text(
                                      textAlign: TextAlign.center,
                                      "Jumlah Pencatatan Penduduk\n Kentolan Lor RT ${countFirebase.currUserCollectionRT}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 23,
                                      ),
                                    );
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          FutureBuilder<dynamic>(
                              future: countFirebase.getAllColection2(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return GetBuilder<CountFirebase>(
                                    init: CountFirebase(),
                                    initState: (_) =>
                                        countFirebase.getallCollection(),
                                    builder: (countFirebase) => Text(
                                      "${countFirebase.total} Penduduk",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                } else {
                                  return Text("Nothing");
                                }
                              }),
                          const SizedBox(
                            height: 18.0,
                          ),
                          FutureBuilder<dynamic>(
                              future: countFirebase.getNumCol(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return GetBuilder<CountFirebase>(
                                      init: CountFirebase(),
                                      initState: (_) =>
                                          countFirebase.getNumCol(),
                                      builder: (countFirebase) {
                                        return loged!.email !=
                                                'testdukuhh@gmail.com'
                                            ? Text(
                                                //ini ya
                                                textAlign: TextAlign.center,
                                                "${(countFirebase.NumLength != 0 ? countFirebase.NumLength : 0 / countFirebase.NumColData != 0 ? countFirebase.NumColData : 0 * 100).round()} % Penduduk RT${countFirebase.currUserCollectionRT != 0 ? countFirebase.currUserCollectionRT : 0} - Kentolan Lor",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Text("");
                                      });
                                } else {
                                  return Text("Nothing");
                                }
                              }),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FutureBuilder(
                                  future: CountFirebase().getCountGender(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.active) {
                                      return Text("Connection Active Testing");
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Row(
                                        children: [
                                          GetBuilder<CountFirebase>(
                                            init: CountFirebase(),
                                            initState: (_) =>
                                                countFirebase.getCountGender(
                                                    gender: "perempuan"),
                                            builder: (countFirebase) {
                                              return Indicator(
                                                color: Colors.pink,
                                                text:
                                                    "Perempuan ${countFirebase.NumLengthGenderP != 0 ? ((countFirebase.NumLengthGenderP / (countFirebase.NumLengthGenderL + countFirebase.NumLengthGenderP)) * 100).round() : 0}% : ${countFirebase.NumLengthGenderP}",
                                                textColor: Colors.white,
                                                isSquare: true,
                                              );
                                            },
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          GetBuilder<CountFirebase>(
                                            init: CountFirebase(),
                                            initState: (_) =>
                                                countFirebase.getCountGender(
                                                    gender: "laki-laki"),
                                            builder: (countFirebase) {
                                              return Indicator(
                                                color: Colors.amber,
                                                text:
                                                    'Laki-Laki ${countFirebase.NumLengthGenderL != 0 ? (countFirebase.NumLengthGenderL / (countFirebase.NumLengthGenderL + countFirebase.NumLengthGenderP) * 100).round() : 0}% : ${countFirebase.NumLengthGenderL != 0 ? countFirebase.NumLengthGenderL : 0} ',
                                                textColor: Colors.white,
                                                isSquare: true,
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                    return Text("Loading");
                                  }),
                            ],
                          ),
                          const SizedBox(
                            height: 17.0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: FutureBuilder<dynamic>(
                            future: countFirebase.getCountBirth(),
                            builder: (context, snapshot) {
                              // if (snapshot.connectionState ==
                              //     ConnectionState.waiting) {
                              //   return Center(child: CircularProgressIndicator());
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Kategori Usia",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontFamily: 'Open Sans',
                                        ),
                                      ),
                                      PieChartSample2(),
                                    ],
                                  ),
                                );
                                // PieChartSample2();
                              }
                              return Text("loading");
                            })),
                    const SizedBox(
                      height: 10.0,
                    ),
                    loged!.email == 'testdukuhh@gmail.com'
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: FutureBuilder<dynamic>(
                                future: countFirebase.getAllColection2(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Text(
                                              "Sebaran presentase penduduk :",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Open Sans',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          CardSensus(),
                                        ],
                                      ),
                                    );
                                  }
                                  return Text("loading");
                                }))
                        : Text(""),

                    Container(
                      width: MediaQuery.of(context).size.width - 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Data Terbaru",
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 22,
                                fontFamily: 'Open Sans'
                                //color: Color.fromARGB(255, 68, 137, 255),
                                ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MasterTableScreen()),
                              );
                            },
                            child: Text(
                              "View All",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Streambuilderdata(
                      refreshCallback: () {},
                      takes: 2,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),

                    //LineChartSample2(),
                  ],
                )),
          ),
        ));
  }
}
