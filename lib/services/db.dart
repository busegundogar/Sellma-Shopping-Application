import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future addUserAutoID(String mail, String username, String token) async{
    userCollection.add({
      'email': mail,
      'username': username,
      'token': token
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: ${error.toString()}"));
  }

  Future addUser(String username, String mail, String token) async {
    userCollection.doc(token).set({
      'username': username,
      'userToken': token,
      'email': mail
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: ${error.toString()}"));
  }

}