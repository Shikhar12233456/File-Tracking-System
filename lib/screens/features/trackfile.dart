import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pr301s/Firebase/file.dart';

// Tracking Files
class Track extends StatefulWidget {
  final double height;
  final double width;
  const Track({super.key, required this.height, required this.width});

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {
  final String? _currentUser = FirebaseAuth.instance.currentUser?.email;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("user")
              .doc(_currentUser!)
              .collection("sendfiles")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(
                height: widget.height,
                width: widget.width,
                child: const Text("No data"),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data =
                      snapshot.data?.docs[index] as DocumentSnapshot<Object?>;
                  String id = data['file'];
                  print(id);
                  return FutureBuilder(
                      future: File().getFilebyId(id),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          if (snap.data != null) {
                            Map<String, dynamic> file = snap.data!;
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => StatefulBuilder(
                                        builder: (context, setState) =>
                                            AlertDialog(
                                                title: const Text(
                                                    "File Status...."),
                                                content: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.7,
                                                    color: Colors.white,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.3,
                                                          child:
                                                              Column(children: [
                                                            Text(
                                                                "titile: ${file['title']}"),
                                                            Text(
                                                                "status: ${file['status']}"),
                                                            Text(
                                                                "remark: ${file['remark']}"),
                                                            Text(
                                                                "discription: ${file['discription']}"),
                                                          ]),
                                                        ),
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.4,
                                                          child: Column(
                                                            children: [
                                                              const Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      "Sender"),
                                                                  Text(
                                                                      "Receiver"),
                                                                  Text("Date")
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.35,
                                                                child: StreamBuilder<
                                                                    QuerySnapshot>(
                                                                  stream: FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "files")
                                                                      .doc(id)
                                                                      .collection(
                                                                          "history")
                                                                      .snapshots(),
                                                                  builder: (context,
                                                                      snapshot2) {
                                                                    if (!snapshot2
                                                                        .hasData) {
                                                                      return const SizedBox(
                                                                        child: Text(
                                                                            "No data"),
                                                                      );
                                                                    }
                                                                    return ListView
                                                                        .builder(
                                                                            itemCount:
                                                                                snapshot2.data?.docs.length,
                                                                            itemBuilder: (context, index) {
                                                                              DocumentSnapshot data2 = snapshot2.data?.docs[index] as DocumentSnapshot<Object?>;
                                                                              print(data2.toString());
                                                                              return Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(data2['sender']),
                                                                                  const SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Text(data2['receiver']),
                                                                                  const SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Text(data2['time'])
                                                                                ],
                                                                              );
                                                                            });
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )))));
                              },
                              child: SizedBox(
                                child: Text(file['title']),
                              ),
                            );
                          }
                        }
                        return const CircularProgressIndicator();
                      });
                });
          }),
    );
  }
}
