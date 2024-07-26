import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Post extends Equatable {
  String? id;
  String? userId;
  String? title;
  String? description;
  String? cover;
  int? status;
  Timestamp? timestamp;

  Post({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.cover,
    this.status,
    this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'cover': cover,
      'status': status,
      'timestamp': timestamp,
    };
  }

  Post.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        userId = doc.data()!['userId'],
        title = doc.data()!['title'],
        description = doc.data()!['description'],
        cover = doc.data()!['cover'],
        status = doc.data()!['status'],
        timestamp = doc.data()!['timestamp'];

  Post copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? cover,
    int? status,
    Timestamp? timestamp,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      cover: cover ?? this.cover,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }
  
  @override
  List<Object?> get props => [id, userId, title, description, cover, status, timestamp];
}
