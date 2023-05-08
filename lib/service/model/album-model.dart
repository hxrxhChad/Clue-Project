class Album {
  String image;
  String? docId;
  String? time;

  Album({
    required this.image,
    this.docId,
    this.time,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      image: json['Image'] as String,
      docId: json['docId'] as String,
      time: json['time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Image': image,
      'docId': docId,
      'time': time,
    };
  }
}
