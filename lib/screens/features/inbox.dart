import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pr301s/Firebase/file.dart';

class Inbox extends StatefulWidget {
  final double height;
  final double width;
  const Inbox({super.key, required this.height, required this.width});

  @override
  State<Inbox> createState() => InboxState();
}

class InboxState extends State<Inbox> {
  final String? _currentUser = FirebaseAuth.instance.currentUser?.email;
  String chosenacad = "director@iiitdmj.ac.in";
  List<String> senditemsAcad = [
    "nitintripathi@iiitdmj.ac.in",
    "irshaahmed@iiitdmj.ac.in",
    "deanstudent.ac.in",
    "director@iiitdmj.ac.in",
    "atulgupta@iiitdmj.ac.in"
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
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
            var l = snapshot.data?.docs.length;
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data =
                      snapshot.data?.docs[index] as DocumentSnapshot<Object?>;
                  String id = data['file'];
                  // return Text(data['file']);
                  return FutureBuilder(
                      future: File().getFilebyId(id),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          if (snap.data != null) {
                            Map<String, dynamic> file = snap.data!;
                            // print(file.toString());
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => StatefulBuilder(
                                        builder: (context, setState) =>
                                            AlertDialog(
                                              title: const Text("File...."),
                                              content: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.7,
                                                color: Colors.white,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Text("Sender:- "),
                                                    Text(file["sender"]),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(file["title"]),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(file['discription']),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          File().openFile(
                                                              file['path']);
                                                        },
                                                        child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 40,
                                                            width: 150,
                                                            decoration: const BoxDecoration(
                                                                color:
                                                                    Colors.blue,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                            child: const Text(
                                                              "Download File",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ))),
                                                    // Text(file["discription"]),
                                                    DropdownButton2(
                                                      value: chosenacad,
                                                      onChanged: (newval) {
                                                        setState(() {
                                                          chosenacad = newval!;
                                                        });
                                                      },
                                                      items: senditemsAcad
                                                          .map((e) {
                                                        return DropdownMenuItem(
                                                            value: e,
                                                            child: Text(e));
                                                      }).toList(),
                                                    ),
                                                    const SizedBox(height: 200,),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        TextButton(
                                                            onPressed: () {
                                                              File().acceptFile(
                                                                  data['file'],
                                                                  _currentUser!);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 40,
                                                                width: 90,
                                                                decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .blue,
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            10))),
                                                                child:
                                                                    const Text(
                                                                  "Accept",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ))),
                                                        TextButton(
                                                            onPressed: () {
                                                              if (chosenacad !=
                                                                  "selectValue") {
                                                                File().forwardFile(
                                                                    data[
                                                                        'file'],
                                                                    _currentUser!,
                                                                    chosenacad);
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            },
                                                            child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 40,
                                                                width: 90,
                                                                decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .blue,
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            10))),
                                                                child:
                                                                    const Text(
                                                                  "Forward",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ))),
                                                        TextButton(
                                                            onPressed: () {
                                                              File().rejectFile(
                                                                  data['file'],
                                                                  _currentUser!);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 40,
                                                                width: 90,
                                                                decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .blue,
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            10))),
                                                                child:
                                                                    const Text(
                                                                  "Reject",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                )))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )));
                              },
                              child: Card(
                                elevation: 2,
                                child: Container(
                                  height: 100,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        file["sender"],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(file["title"]),
                                      Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          width: 90,
                                          decoration: const BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: const Text(
                                            "View",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Text("No Data");
                          }
                        }
                        return const CircularProgressIndicator();
                      });
                });
          }),
    );
  }
}
