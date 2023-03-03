class PostModel{
  String? id;
  String? userId;
  String? username;
  String? text;
  String? country;
  String? timestamp;
  List<Images>? images;
  List<Comments>? comments;

  PostModel(this.id, this.userId, this.username, this.text, this.timestamp, this.country, this.images,
      this.comments);

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['userId'].toString();
    username = json['username'].toString();
    text = json['text'].toString();
    timestamp = json['timestamp'].toString();
    country = json['country'].toString();
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
 if (json['comments'] != null) {
   comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['username'] = username;
    data['text'] = text;
    data['country'] = country;
    data['timestamp'] = timestamp;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
   if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images{
  String? image;

  Images(this.image);

  Images.fromJson(Map<String, dynamic> json) {
    image = json['image'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    return data;
  }

}

class Comments{
  String? comment;
  String? username;
  String? userId;
  String? timestamp;
  String? image;

  Comments(this.comment, this.username, this.userId, this.timestamp, this.image);


  Comments.fromJson(Map<String, dynamic> json) {
    comment = json['comment'].toString();
    username = json['username'].toString();
    userId = json['userId'].toString();
    timestamp = json['timestamp'].toString();
    image = json['image'].toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'username': username,
      'userId': userId,
      'timestamp': timestamp,
      'image': image,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment'] = comment;
    data['username'] = username;
    data['userId'] = userId;
    data['timestamp'] = timestamp;
    data['image'] = image;
    return data;
  }

}


