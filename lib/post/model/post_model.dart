class PostModel{
  String id;
  String userId;
  String username;
  String text;
  int timestamp;
  List<Images> images;
  List<Comments> comments;

  PostModel(this.id, this.userId, this.username, this.text, this.timestamp, this.images,
      this.comments);
}

class Images{
  String image;

  Images(this.image);
}

class Comments{
  String comment;
  String username;
  String userId;
  int timestamp;

  Comments(this.comment, this.username, this.userId, this.timestamp);
}