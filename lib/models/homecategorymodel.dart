class HomeCategoriesModel {
  Record? record;
  Metadata? metadata;

  HomeCategoriesModel({this.record, this.metadata});

  HomeCategoriesModel.fromJson(Map<String, dynamic> json) {
    record =
        json['record'] != null ? new Record.fromJson(json['record']) : null;
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.record != null) {
      data['record'] = this.record!.toJson();
    }
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}

class Record {
  String? title;
  List<Categories>? categories;

  Record({this.title, this.categories});

  Record.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? id;
  String? name;
  String? image;

  Categories({this.id, this.name, this.image});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class Metadata {
  String? id;
  bool? private;
  String? createdAt;
  String? name;

  Metadata({this.id, this.private, this.createdAt, this.name});

  Metadata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    private = json['private'];
    createdAt = json['createdAt'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['private'] = this.private;
    data['createdAt'] = this.createdAt;
    data['name'] = this.name;
    return data;
  }
}
