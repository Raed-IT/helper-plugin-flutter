class MediaModel {
  String? url;

  int? id;

  MediaModel(this.url, this.id);
  MediaModel.fromJson (Map<String ,dynamic> json ){
    id=json['id'];
    url=json['url'];
  }
}
