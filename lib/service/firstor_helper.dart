import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FireStoreHelper{
  static final FireStoreHelper _storeHelper = FireStoreHelper._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FireStoreHelper._();

  factory FireStoreHelper() {
    return _storeHelper;
  }

  void updateToken() async{
    User? currentUser = FirebaseAuth.instance.currentUser;
    var token =await  FirebaseMessaging.instance.getToken();

    if (currentUser != null) {
      firestore.collection("Users").doc(currentUser.displayName?? "").update({
        "fcmToken": token,
      });
    }


  }
}