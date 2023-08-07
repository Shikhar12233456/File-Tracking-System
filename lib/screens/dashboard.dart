import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pr301s/Firebase/file.dart';
import 'package:pr301s/Firebase/user_save.dart';
import 'package:pr301s/screens/features/inbox.dart';
import 'package:pr301s/screens/features/trackfile.dart';

class Dash extends StatefulWidget {
  const Dash({Key? key}) : super(key: key);

  @override
  State<Dash> createState() => _DashState();
}

class _DashState extends State<Dash> {
  Uint8List? file;
  String? fileName = "No files selected";
  bool showText = false;
  int postion = 1;
  Map<String, dynamic> user = {};
  final _tittletextEditingController = TextEditingController();
  final _descriptionTextEditingController = TextEditingController();
  final _remarkTextEditingController = TextEditingController();
  final String? _currentUser = FirebaseAuth.instance.currentUser!.email;
  String chosen = "xyz2@iiitdmj.ac.in";
  List<String> senditems = [
    "nitintripathi@iiitdmj.ac.in",
    "xyz2@iiitdmj.ac.in",
    "xyz3@iiitdmj.ac.in",
    "xyz4@iiitdmj.ac.in"
  ];
  String chosenacad = "director.ac.in";
  List<String> senditemsAcad = [
    "nitintripathi@iiitdmj.ac.in",
    "irshaahmed@iiitdmj.ac.in",
    "deanstudent.ac.in",
    "director.ac.in"
  ];
  renew() {
    setState(() {
      fileName = "No files selected";
      chosen = "xyz2@iiitdmj.ac.in";
    });
    _tittletextEditingController.clear();
    _descriptionTextEditingController.clear();
    _remarkTextEditingController.clear();
  }

  _getUserProfile() async {
    user = await Save().getUSerInfo(_currentUser!);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
          actions: [
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                "Logout",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
            IconButton(
                onPressed: () {
                  print("Logout");
                },
                icon: const Icon(Icons.logout_outlined)),
            const SizedBox(
              width: 20,
            )
          ],
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerRight,
              // height: height * 0.9,
              width: width * 0.25,
              child: SizedBox(
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  borderOnForeground: true,
                  child: Column(
                    children: [
                      CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.black,
                          child: Image.network(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSmWs4rlQpsv-g9EqXzCglLYTvPM233WyCSaeCEvllSZreaMbZKeDgRcECmDEWowZV16MQ&usqp=CAU",
                            height: 80,
                            width: 80,
                          )),
                      _line(width),
                      SizedBox(
                        height: height * 0.3,
                      ),
                      _line(width),
                      button("Send File", 1),
                      _line(width),
                      button("Inbox", 2),
                      _line(width),
                      button("Sent", 3),
                      _line(width),
                      button("Track File", 4)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
                height: height * 0.9,
                width: width * 0.5,
                child: _selectChild(postion, height * 0.9, width * 0.5)),
            Container(
              alignment: Alignment.centerLeft,
              height: height * 0.9,
              width: width * 0.25,
              child: Container(
                height: height * 0.7,
                width: width * 0.2,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      width: 1.5,
                      style: BorderStyle.solid,
                      color: Colors.grey.withOpacity(0.6),
                    )),
                child: Column(
                  children: [
                    const Text(
                      "Notifications",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    _line(width * 0.2),
                    SizedBox(
                      width: width * 2,
                      height: height * 0.6 - 20,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("user")
                              .doc(_currentUser!)
                              .collection("receivedfiles")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView.builder(
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot data =
                                      snapshot.data?.docs[index]
                                          as DocumentSnapshot<Object?>;
                                  String id = data['file'];
                                  return FutureBuilder(
                                      future: File().getFilebyId(id),
                                      builder: (context, snap) {
                                        if (snap.hasData) {
                                          if (snap.data != null) {
                                            Map<String, dynamic> file =
                                                snap.data!;
                                            return Row(
                                              children: [
                                                Text(
                                                    "You have a file from ${fetchUserName(file["sender"])}"),
                                              ],
                                            );
                                          }
                                        }
                                        return Container();
                                      });
                                });
                          }),
                    ),
                    TextButton(onPressed: () {}, child: const Text(""))
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _line(double width) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Container(
        width: width,
        height: 1,
        color: Colors.grey,
      ),
    );
  }

  _selectChild(int position, double height, double width) {
    switch (position) {
      case 1:
        return _makeForm(_tittletextEditingController,
            _descriptionTextEditingController, _remarkTextEditingController);
      case 2:
        return Inbox(height: height, width: width);
      case 3:
        return const Text("case 3");
      case 4:
        return Track(height: height, width: width);
    }
  }

  Widget button(String text, int check) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
        onPressed: () {
          setState(() {
            postion = check;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.7)),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black.withOpacity(0.7),
            )
          ],
        ));
  }

  Widget _makeForm(TextEditingController title,
      TextEditingController discription, TextEditingController remark) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headingText("Title"),
          _textfield("Title", title),
          _headingText("Add Discription"),
          _textfield("Discription", discription),
          Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: Colors.black.withOpacity(0.7))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  child: Text(fileName.toString()),
                ),
                TextButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    file = result!.files.single.bytes;
                    setState(() {
                      showText = true;
                      fileName = result.files.single.name;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.7))),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child: Text(
                        "Upload",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DropdownButton2(
            value: chosen,
            onChanged: (newval) {
              setState(() {
                chosen = newval!;
              });
            },
            items: senditems.map((e) {
              return DropdownMenuItem(value: e, child: Text(e));
            }).toList(),
          ),
          _headingText("Ramark *"),
          _textfield("Remark", remark),
          TextButton(
              onPressed: () async {
                if (title.text.isEmpty ||
                    discription.text.isEmpty ||
                    _currentUser!.isEmpty) {
                  const snackBar =
                      SnackBar(content: Text("Feilds Cann't be empty"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  File().savetoFirebase(file, fileName, _currentUser!, chosen,
                      title.text, discription.text, remark.text);

                  renew();
                }
              },
              child: const Text("Send"))
        ],
      ),
    );
  }

  Widget _headingText(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
      ),
    );
  }

  Widget _textfield(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          hintText: hint,
          enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              borderSide: BorderSide(color: Colors.black.withOpacity(0.7))),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              borderSide: BorderSide(color: Colors.black.withOpacity(0.7)))),
    );
  }

  String fetchUserName(String email) {
    var indx = email.indexOf('@');
    String username = email.substring(0, indx);
    if (kDebugMode) {
      print(indx);
      print(username);
    }
    return username;
  }
}
