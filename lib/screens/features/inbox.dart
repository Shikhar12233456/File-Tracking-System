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
  String chosenacad = "director.ac.in";
  List<String> senditemsAcad = [
    "nitintripathi@iiitdmj.ac.in",
    "irshaahmed@iiitdmj.ac.in",
    "deanstudent.ac.in",
    "director.ac.in"
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
            print(l.toString());
            // return ListView();
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
                                                  children: [
                                                    Text(file["sender"]),
                                                    Text(file["title"]),
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
                                                    Row(
                                                      children: [
                                                        TextButton(
                                                            onPressed: () {
                                                              File().acceptFile(
                                                                  data['file'],
                                                                  _currentUser!);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Accept")),
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
                                                            child: const Text(
                                                                "Forward")),
                                                        TextButton(
                                                            onPressed: () {
                                                              File().rejectFile(
                                                                  data['file'],
                                                                  _currentUser!);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Reject"))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )));
                              },
                              child: SizedBox(
                                child: Row(
                                  children: [
                                    Text(file["title"]),
                                    Text(file["sender"])
                                  ],
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
