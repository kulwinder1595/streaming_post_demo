class ProfileModel {
  String? id;
  String? userId;
  String? username;
  String? profileImage;
  String? age;
  String? state;
  String? nationality;
  String? web;
  String? email;
  String? store;
  String? password;
  List<Videos>? videos;

  ProfileModel(
      this.id,
      this.userId,
      this.username,
      this.profileImage,
      this.age,
      this.state,
      this.nationality,
      this.web,
      this.email,
      this.store,
      this.password,
      this.videos);

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['userId'].toString();
    username = json['username'].toString();
    profileImage = json['profileImage'].toString();
    age = json['age'].toString();
    state = json['state'].toString();
    nationality = json['nationality'].toString();
    web = json['web'].toString();
    email = json['email'].toString();
    store = json['store'].toString();
    password = json['password'].toString();
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(Videos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'profileImage': profileImage,
      'age': age,
      'state': state,
      'nationality': nationality,
      'web': web,
      'email': email,
      'store': store,
      'password': password,
      'videos': videos,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['username'] = username;
    data['profileImage'] = profileImage;
    data['age'] = age;
    data['state'] = state;
    data['nationality'] = nationality;
    data['web'] = web;
    data['email'] = email;
    data['store'] = store;
    data['password'] = password;
    if (this.videos != null) {
      data['videos'] = this.videos!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Videos {
  String? videoFile;

  Videos(this.videoFile);

  Videos.fromJson(Map<String, dynamic> json) {
    videoFile = json['video'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['video'] = videoFile;
    return data;
  }
}
