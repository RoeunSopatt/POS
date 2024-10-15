class StatisticSales {
  List<String>? labels;
  List<int>? data;

  StatisticSales({this.labels, this.data});

  StatisticSales.fromJson(Map<String, dynamic> json) {
    labels = json['labels'].cast<String>();
    data = json['data'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['labels'] = this.labels;
    data['data'] = this.data;
    return data;
  }
}