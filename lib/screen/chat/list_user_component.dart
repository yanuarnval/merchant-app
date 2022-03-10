import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/colors_value.dart';

class ListUserComponent extends StatelessWidget {
  Map<String, dynamic> chatrooms;

  ListUserComponent({Key? key, required this.chatrooms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance
        .collection('chatrooms').doc(chatrooms['uidchat']).snapshots();
    print(chatrooms['photourl'] == null);
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: (chatrooms['photourl'] == null)
                ? Container(
              width: 40,
              height: 40,
              color: ColorsWeplant.colorPrimary,
              child: Center(
                child: Text(
                  chatrooms['name']
                      .toString()
                      .characters
                      .first,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24),
                ),
              ),
            )
                : Image.network(
              chatrooms['photourl'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chatrooms['name']),
                StreamBuilder<DocumentSnapshot>(
                    stream: stream,
                    builder:
                        (BuildContext c,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("");
                      }
                      List hello=snapshot.data!['message'];
                      return Text(
                        hello.last['msg'],
                        style: const TextStyle(fontSize: 12,color: Colors.grey),
                      );
                    })

              ],
            ),
          ),
          const Spacer(),
          StreamBuilder<DocumentSnapshot>(
              stream: stream,
              builder:
                  (BuildContext c,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("");
                }
                List hello=snapshot.data!['message'];
                return Text(
                  hello.last['created'],
                  style: const TextStyle(fontSize: 12,color: Colors.grey),
                );
              })
        ],
      ),
    );
  }
}
