import 'dart:developer';

import 'package:meet_app/models/chatroommodel.dart';
import 'package:meet_app/models/usersmodel.dart';
import 'package:meet_app/screens/Chat/chats_details.dart';
import 'package:meet_app/service/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../auth/widget/selectusertochat_page.dart';


class ChatScreen extends StatefulWidget {
  final ChatUser? chatUser;
  const ChatScreen({Key? key, this.chatUser}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot<Map<String, dynamic>>> stream;

  @override
  void initState() {
    final user = auth.currentUser;
    stream = FirebaseFirestore.instance
        .collection("Chatrooms")
        .where("participants.${user!.uid}", isEqualTo: true)
    // .orderBy("time", descending: true)
        .snapshots();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: ((context) {
            return SelectUserToChat(chatUser: user);
          })));
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color(0xffFFFFFF),
          backgroundColor: Colors.teal,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(14),
        ),
        child: const Icon(
          Icons.add,
          size: 36,
        ),
      ),
      body: StreamBuilder(
          stream: stream,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot chatroomsnapshot = snapshot.data as QuerySnapshot;
                return ListView.builder(
                  itemCount: chatroomsnapshot.docs.length,
                  itemBuilder: ((context, index) {
                    ChatRoomModel chatRoomModel = ChatRoomModel.fromJson(
                        chatroomsnapshot.docs[index].data()
                        as Map<String, dynamic>);
                    Map<String, dynamic> participants =
                    chatRoomModel.participants!;
                    List<String> participantkeys = participants.keys.toList();
                    participantkeys.remove(user!.uid);
                    return FutureBuilder(
                      future:
                      FirebaseService.getUserModelbyId(participantkeys[0]),
                      builder: (context, userdata) {
                        if (userdata.connectionState == ConnectionState.done) {
                          if (userdata.data != null) {
                            ChatUser targetuser = userdata.data as ChatUser;
                            log("In Future builder");
                            return Padding(
                              padding: const EdgeInsets.only(
                                top: 5,
                                left: 10,
                                bottom: 5,
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) {
                                        return ChatPage(
                                            targetuser: targetuser,
                                            chatroom: chatRoomModel,
                                            currentuser: user,
                                            firebaseuser: user);
                                      }),
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(
                                    targetuser.profilepic.toString(),
                                  ),
                                ),
                                title: Text(
                                  targetuser.username.toString(),
                                ),
                                subtitle: (chatRoomModel.lastmessage!.contains(
                                    'https://firebasestorage.googleapis.com'))
                                    ? Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                    ),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.image,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Image",
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Text(""),
                                      ],
                                    ))
                                    : Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      chatRoomModel.lastmessage.toString(),
                                    ),
                                    Text(
                                      (chatRoomModel.lastmsgtime == null)
                                          ? ""
                                          : DateFormat.jm().format(
                                          chatRoomModel.lastmsgtime!),
                                    ),
                                  ],
                                ),
                                trailing: Image.asset(
                                  "assets/right.png",
                                  scale: 3.5,
                                ),
                              ),
                            );
                          } else {
                            return Text("User data is null");
                          }
                        } else {
                          return const SizedBox(
                            height: 30,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                              ),
                              child: Center(
                                child: CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.black,
                                  value: 5,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }),
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return Center(
                  child: Text("No Chat found"),
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Connection State Waiting");
            } else {
              return Center(child: Text("Error: Check Internet Connection"));
            }
          })),

    );


  }
}

// Widget contact(
//     String urlImage, String title, var time, onOff, String msgs, context) {
//   return Padding(
//     padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
//     child: ListTile(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => message(urlImage, title, onOff, context)),
//         );
//       },
//       leading: Container(
//         height: 50,
//         width: 50,
//         child: ClipOval(
//           child: Image.asset(
//             urlImage,
//             fit: BoxFit.fill,
//           ),
//         ),
//       ),
//       title: Text(title),
//       subtitle: Row(
//         children: [
//           const Icon(
//             Icons.done_all,
//             size: 20,
//             color: Colors.blue,
//           ),
//           const SizedBox(
//             width: 4.0,
//           ),
//           Text(
//             msgs,
//           ),
//         ],
//       ),
//       trailing: Text(time),
//     ),
//   );
// }

// Widget message(String urlImage, String title, String onOff, context) {
//   // clickContact
//   return Scaffold(
//     appBar: AppBar(
//       titleSpacing: 0.0,
//       leading: IconButton(
//         onPressed: () {
//           Navigator.pop(context);
//         },
//         icon: const Icon(Icons.arrow_back_rounded),
//       ),
//       title: Row(
//         children: [
//           Container(
//             height: 40,
//             width: 40,
//             child: ClipOval(
//               child: Image.asset(
//                 urlImage,
//                 fit: BoxFit.fill,
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title),
//               const SizedBox(
//                 height: 2,
//               ),
//               Text(
//                 onOff,
//                 style: const TextStyle(fontSize: 12),
//               ),
//             ],
//           ),
//         ],
//       ),
//       actions: const [
//         Icon(Icons.videocam),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           child: Icon(Icons.call),
//         ),
//         Icon(Icons.more_vert),
//       ],
//     ),
//     body: const ChatScr(),
//   );
// }

class ChatMess extends StatelessWidget {
  final String text;
  final AnimationController animationController;

  const ChatMess(
      {Key? key, required this.text, required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: const Color(0xffdcf8c6),
            borderRadius: BorderRadius.circular(4.0)),
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        child: Text(text),
      ),
    );
  }
}

class ChatScr extends StatefulWidget {
  const ChatScr({Key? key}) : super(key: key);

  @override
  State<ChatScr> createState() => _ChatScrState();
}

class _ChatScrState extends State<ChatScr> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final List<ChatMess> _messages = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _textController.clear();

    var message = ChatMess(

      text: text,
      animationController: AnimationController(

        duration: const Duration(milliseconds: 700), // NEW
        vsync: this,
      ),
    );
    setState(() {

      _messages.insert(0, message); // NEW
    });
    _focusNode.requestFocus();
    message.animationController.forward();
  }

  Widget _buildTextComposer() {
    bool sendMic = false;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 50,
              child: TextField(
                controller: _textController,
                onChanged: (text) {
                  setState(() {
                    sendMic = true;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.7),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.grey,
                  ),
                  hintText: 'Message',
                  hintStyle: const TextStyle(fontSize: 20, color: Colors.grey),
                  suffixIconConstraints:
                      const BoxConstraints(minWidth: 80, maxWidth: 100),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.attach_file_outlined,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                focusNode: _focusNode,
              ),
            ),
          ),
          IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
            child: Container(
              height: 65,
              width: 65,
              child: IconButton(
                icon: _textController.text == ''
                    ? const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.teal,
                        child: Icon(
                          Icons.mic,
                          color: Colors.white,
                        ))
                    : const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.teal,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                onPressed: () => // MODIFIED
                    _handleSubmitted(_textController.text) // MODIFIED
                ,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/chatBack.jpg"), fit: BoxFit.cover)),
      child: Column(
        // MODIFIED
        children: [
          // NEW
          Flexible(
            // NEW
            child: ListView.builder(
              // NEW
              padding: const EdgeInsets.all(8.0), // NEW
              reverse: true, // NEW
              itemBuilder: (_, index) => _messages[index], // NEW
              itemCount: _messages.length, // NEW
            ), // NEW
          ), // NEW
          Container(
            child: _buildTextComposer(), // MODIFIED
          ), // NEW
        ], // NEW
      ),
    );
  }
}
