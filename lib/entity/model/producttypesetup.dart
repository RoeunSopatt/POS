class ProductTypeSetUp {
  List<DataSetUp>? data;

  ProductTypeSetUp({this.data});

  ProductTypeSetUp.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataSetUp>[];
      json['data'].forEach((v) {
        data!.add(new DataSetUp.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataSetUp {
  int? id;
  String? name;

  DataSetUp({this.id, this.name});

  DataSetUp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}