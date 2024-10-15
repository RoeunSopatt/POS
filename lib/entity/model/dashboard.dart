class Dashboard {
  Statatics? statatics;
  String? message;

  Dashboard({this.statatics, this.message});

  Dashboard.fromJson(Map<String, dynamic> json) {
    statatics = json['statatics'] != null
        ? new Statatics.fromJson(json['statatics'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.statatics != null) {
      data['statatics'] = this.statatics!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Statatics {
  int? totalProduct;
  int? totalProductType;
  int? totalUser;
  int? totalOrder;

  Statatics(
      {this.totalProduct,
      this.totalProductType,
      this.totalUser,
      this.totalOrder});

  Statatics.fromJson(Map<String, dynamic> json) {
    totalProduct = json['totalProduct'];
    totalProductType = json['totalProductType'];
    totalUser = json['totalUser'];
    totalOrder = json['totalOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalProduct'] = this.totalProduct;
    data['totalProductType'] = this.totalProductType;
    data['totalUser'] = this.totalUser;
    data['totalOrder'] = this.totalOrder;
    return data;
  }
}