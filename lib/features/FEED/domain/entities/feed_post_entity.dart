import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sorted/features/FEED/data/models/feed_model.dart';

class FeedPostEntity {
  List<PostModel> posts;
  DocumentSnapshot lastDoc;
  FeedPostEntity({
    this.posts = const [],
    this.lastDoc,
  });
}
