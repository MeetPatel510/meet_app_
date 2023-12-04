import 'dart:developer';

import 'package:meet_app/camera/camera_page.dart';
import 'package:meet_app/main.dart';
import 'package:meet_app/models/chatroommodel.dart';
import 'package:meet_app/models/fcmmodel.dart';
import 'package:meet_app/models/messagemodel.dart';
import 'package:meet_app/models/usersmodel.dart';
import 'package:meet_app/screens/Chat/showmessage.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_app/service/api_end_point.dart';
import 'package:meet_app/service/firstor_helper.dart';
import 'package:meet_app/service/http_helper.dart';

import '../../camera/previewimage_chatpage.dart';

enum ChatMenuItem { item1, item2, item3, item4, item5, item6 }

class ChatPage extends StatefulWidget {
  final ChatUser targetuser;
  final ChatRoomModel chatroom;
  final User currentuser;
  final User firebaseuser;

  const ChatPage({
    Key? key,
    required this.targetuser,
    required this.chatroom,
    required this.currentuser,
    required this.firebaseuser,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  var _focusNode = FocusNode();

  XFile? imagefile;

  focusListener() {
    setState(() {});
  }

  @override
  void initState() {
    _focusNode.addListener(focusListener);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(focusListener);
    super.dispose();
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.teal,
            title: Text(
              "Upload Image",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    imageSelect(ImageSource.gallery);
                  },
                  leading: Icon(
                    Icons.photo_album,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Gallery",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ListTile(
                  onTap: () async {
                    Navigator.pop(context);
                    await availableCameras().then((value) => Navigator.push(
                            context, MaterialPageRoute(builder: (context) {
                          return CameraPage(
                            cameras: value,
                            chatroom: widget.chatroom,
                            currentuser: widget.currentuser,
                            targetuser: widget.targetuser,
                          );
                        })));
                  },
                  leading: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Camera",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void imageSelect(ImageSource source) async {
    XFile? pickedimage = await ImagePicker().pickImage(source: source);
    if (pickedimage != null) {
      cropImage(pickedimage);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? cropedImage = (await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 20,
    ));

    if (cropedImage != null) {
      setState(() {
        imagefile = XFile(cropedImage.path);
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewImage(
                    picture: imagefile,
                    chatroom: widget.chatroom,
                    currentuser: widget.currentuser,
                    targetuser: widget.targetuser,
                  )));
    }
  }

  TextEditingController msgcontroller = TextEditingController();

  void sendmessage() async {
    String message = msgcontroller.text.trim();
    msgcontroller.clear();
    if (message != "") {
      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        messagetext: message,
        sender: widget.currentuser.uid,
        seen: false,
        timecreated: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection("Chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("Messages")
          .doc(newMessage.messageid)
          .set(newMessage.toJson());

      widget.chatroom.lastmsgtime = DateTime.now();
      widget.chatroom.lastmessage = message;

      await FirebaseFirestore.instance
          .collection("Chatrooms")
          .doc(widget.chatroom.chatroomid)
          .set(widget.chatroom.toJson());
      log("Message sent");

      var email = ChatUser().username;

      var documentSnapshot = await FireStoreHelper().firestore.collection("Users").doc(email).get();
      String? token = documentSnapshot.data()?["fcmToken"] ?? "";

      print("Token  $token");


      var fcmModel = FcmModel(
        to: token ?? "",
        notification: Data(title: FirebaseAuth.instance.currentUser?.displayName ?? "", body: msgcontroller.text),
        data: Data(title: FirebaseAuth.instance.currentUser?.email ?? "", body: msgcontroller.text),
      );
      HttpHelper().postHttp(sendEndPoint, fcmModel.toJson());

    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        appBar: AppBar(
          toolbarHeight: 60,
          elevation: 5,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
            PopupMenuButton<ChatMenuItem>(
              onSelected: (value) {
                if (value == ChatMenuItem.item5) {}
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: ChatMenuItem.item1,
                  child: ListTile(
                    title: Text('View contact'),
                  ),
                ),
                const PopupMenuItem(
                  value: ChatMenuItem.item2,
                  child: ListTile(
                    title: Text('Media, links, and docs'),
                  ),
                ),
                const PopupMenuItem(
                  value: ChatMenuItem.item3,
                  child: ListTile(
                    title: Text('Mute notifications'),
                  ),
                ),
                const PopupMenuItem(
                  value: ChatMenuItem.item4,
                  child: ListTile(
                    title: Text('Disappearing messages'),
                  ),
                ),
                const PopupMenuItem(
                  value: ChatMenuItem.item5,
                  child: ListTile(
                    title: Text('Wallpaper'),
                  ),
                ),
                const PopupMenuItem(
                  value: ChatMenuItem.item6,
                  child: ListTile(
                    title: Text('More'),
                  ),
                ),
              ],
            ),
          ],
          titleSpacing: 0,
          title: Container(
            margin: const EdgeInsets.all(2),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      NetworkImage(widget.targetuser.profilepic.toString()),
                  // child: Image.network(widget.image!),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.targetuser.username.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "Last seen  at 14:28",
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: ShowMessages(
                    chatroom: widget.chatroom,
                    chatuser: widget.currentuser,
                    targetuser: widget.targetuser,
                  ),
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20, left: 20),
                      width: MediaQuery.of(context).size.width - 100,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xffF3F3F3),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xffDBDBDB),
                            blurRadius: 15,
                            spreadRadius: 1.5,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        keyboardAppearance: Brightness.dark,
                        controller: msgcontroller,
                        maxLines: 35,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Message...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16,
                            color: Color(0xffB5B4B4),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                            top: 19,
                            left: 20,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 10, right: 10),
                            child: GestureDetector(
                              onTap: () {
                                EmojiPicker();
                              },
                              child: Icon(Icons.emoji_emotions_outlined,color: Colors.grey,)
                            ),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 3, right: 15),
                            child: InkWell(
                              onTap: () {
                                showPhotoOptions();
                              },
                              child: Icon(Icons.camera_alt,color: Colors.grey,),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        right: 0,
                        left: 10,
                      ),
                      child: FloatingActionButton(
                        elevation: 15,
                        onPressed: () {},
                        child: ElevatedButton(
                          onPressed: () {
                            sendmessage();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.teal,
                            backgroundColor: Colors.teal,
                            shape: CircleBorder(),

                            padding: EdgeInsets.all(10),
                          ),
                          child: Image.asset(
                            (msgcontroller.value.text == "t")
                                ? "assets/mic.png"
                                : "assets/send1.png",
                            color: Colors.white,
                            height: 36,
                            width: 27,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
