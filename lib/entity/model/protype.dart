class ProductTypeModel {
  List<DataProductType>? data;

  ProductTypeModel({this.data});

  ProductTypeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataProductType>[];
      json['data'].forEach((v) {
        data!.add(new DataProductType.fromJson(v));
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

class DataProductType {
  int? id;
  String? name;
  String? createdAt;
  String? nOfProducts;

  DataProductType({this.id, this.name, this.createdAt, this.nOfProducts});

  DataProductType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    nOfProducts = json['n_of_products'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['n_of_products'] = nOfProducts;
    return data;
  }
}
