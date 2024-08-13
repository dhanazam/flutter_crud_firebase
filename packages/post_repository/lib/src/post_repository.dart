import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_pref/shared_pref.dart';
import 'package:post_repository/post_repository.dart';

class PostRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final SharedPreferencesManager _sharedPreferencesManager =
      SharedPreferencesManager();

  Future<void> addPost(Map<String, Object?> postModel) async {
    await _db.collection("posts").add(postModel);
  }

  Future<void> updatePost(String id, Map<String, Object?> postModel) async {
    await _db.collection("posts").doc(id).update(postModel);
  }

  Future<void> deletePost(String documentId) async {
    await _db.collection("posts").doc(documentId).delete();
  }

  Future<List<Posts>> retrieveMyPost(String uid) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("posts").where("userId", isEqualTo: uid).get();
    return snapshot.docs
        .map((docSnapshot) => Posts.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<String?> getUserId() {
    return _sharedPreferencesManager.getString("user_uid");
  }
}
