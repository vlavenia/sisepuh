import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sisepuh/controller/auth_controller.dart';
import 'package:sisepuh/controller/formdata_controller.dart';
import 'package:sisepuh/screens/Home/View/home_screen.dart';
import 'package:sisepuh/services/countfirebase_service.dart';
import 'package:sisepuh/widget/bottomnav_widget.dart';
import 'package:sisepuh/widget/header_nav.dart';

class FormView extends StatelessWidget {
  FormView({Key? key, this.item}) : super(key: key);
  QueryDocumentSnapshot? item;

  var FromdataController = Get.put(FromDataController());
  var countFirebase = Get.put(CountFirebase());
  //var formattedDate = DateTime.now().toString();
  final List<String> genderItems = [
    'laki-laki',
    'perempuan',
  ];
  var selectdedgender;
  final List<String> rtItems = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
  ];

  var difference;

  var countAge;
  var idx;
  var birthdate;
  var nama;
  var gender;
  // var rt;
  var enabledRTDropdown = true;
  User? loged = AuthController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    idx = item?.id;
    nama = item?['nama'];
    birthdate = item?['birthdate'];
    gender = item?['gender'];
    var selectedrt = item?['rt'];
    print("[FormView]=> value selectedrt $selectedrt");
    return Scaffold(
      appBar: headerNav(title: "Form Input Data Penduduk"),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    margin: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      initialValue: nama = item?['nama'],
                      // controller: FromdataController.namaC,
                      // initialValue: 'admin@gmail.com',
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        labelStyle: TextStyle(fontSize: 14),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                      ),
                      onChanged: (value) {
                        FromdataController.namaC.text = value;
                        nama = value;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  SizedBox(
                    height: 200,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      maximumDate: DateTime.now(),
                      initialDateTime: idx != null
                          ? DateTime.parse('${item?['birthdate']}')
                          : DateTime(1970, 1, 1),
                      // DateTime.parse('${item?['birthdate']}'),
                      onDateTimeChanged: (DateTime newDateTime) {
                        FromdataController.formattedDate =
                            DateFormat('yyyy-MM-dd').format(newDateTime);
                        birthdate =
                            DateFormat('yyyy-MM-dd').format(newDateTime);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: DropdownButtonFormField2(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 14),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                      ),
                      hint: const Text(
                        ' Pilih Gender',
                        style: TextStyle(fontSize: 14),
                      ),
                      value: item?['gender'].toString(),
                      items: genderItems
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select gender.';
                        }
                        return null;
                      },
                      onChanged: (String? value) {
                        FromdataController.selectedgender = value;
                        gender = value;
                      },
                      onSaved: (value) {},
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 24,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blue.shade400),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  loged!.email != 'testdukuhh@gmail.com'
                      ? Text("RT Disabled")
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: DropdownButtonFormField2(
                            isExpanded: true,
                            decoration: InputDecoration(
                                // Add Horizontal padding using menuItemStyleData.padding so it matches
                                // the menu padding when button's width is not specified.
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey))
                                // Add more decoration..
                                ),
                            hint: const Text(
                              ' RT Berapa?',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: item?['rt'].toString(),
                            items: rtItems
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Select Your RT.';
                              }
                              return null;
                            },
                            onChanged: (String? value) {
                              FromdataController.selectedrt = value;
                              selectedrt = value;
                            },
                            onSaved: (value) {
                              // selectedValue = value.toString();
                            },
                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.only(right: 8),
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black45,
                              ),
                              iconSize: 24,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.blue.shade400),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        )
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
              Container(
                width: 330,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () {
                      if (idx == null) {
                        FromdataController.AddDataMethod(
                            formattedDate: FromdataController.formattedDate);
                      } else {
                        FromdataController.UpdateDataMethod(
                            id: idx,
                            nama: nama,
                            formattedDate: birthdate,
                            gender: gender,
                            selectedrt: selectedrt);
                      }
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => bottomNavbar()),
                      // );
                      Get.to(bottomNavbar());
                    },
                    child: Text("Simpan")),
              ),
              Container(
                  width: 330,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Hapus'),
                        content: const Text(
                            'Apakah anda yakin ingin menghapus data ini?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'OK');
                              FromdataController.DeleteDataMethod(id: idx);
                              FromdataController.getDataMethods();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => bottomNavbar()),
                              );
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ),
                    child: const Text('Hapus'),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
