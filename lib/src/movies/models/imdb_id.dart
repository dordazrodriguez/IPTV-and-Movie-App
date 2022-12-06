class IMDBIDModel {
  List<D> d;

  IMDBIDModel({this.d});

  IMDBIDModel.fromJson(Map<String, dynamic> json) {
    if (json['d'] != null) {
      d = new List<D>();
      json['d'].forEach((v) {
        d.add(new D.fromJson(v));
      });
    }
  }
}

class D {
  String id;
  String l;
  String q;
  int rank;
  int y;

  D(
      {
      this.id,
      this.l,
      this.q,
      this.rank,
      this.y,});

  D.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    l = json['l'];
    q = json['q'];
    rank = json['rank'];
    y = json['y'];
  }

 
}
