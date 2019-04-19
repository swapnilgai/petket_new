import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petket/model/UserData.dart';


class LoginService{
  //To verify new User
  Future<bool> updateUser ( String id, String name, String profilePicUrl) async{
    Firestore db = Firestore.instance;
    DocumentReference userDoc = db.collection('user').document(id);

    return db.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(userDoc);
      if (postSnapshot.exists) {
        // Extend 'favorites' if the list does not contain the recipe ID:
        await tx.update(userDoc, <String, dynamic>{
          "id" : id,
          "name" : name,
          "profilePicUrl" : profilePicUrl
        });
      } else {
        // Create a document for the current user in collection 'users'
        // and add a new array 'favorites' to the document:
        await tx.set(userDoc, {
          "id" : id,
           "name" : name,
           "profilePicUrl" : profilePicUrl
        });
      }
    }).then((result) {
      return true;
    }).catchError((error) {
      print('Error: $error');
      return false;
    });
  }
}