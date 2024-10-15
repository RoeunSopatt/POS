
import 'package:mobile/entity/enum/e_variable.dart';

class Product {
  String? status;
  List<ProductData>? data;
  Pagination? pagination;

  Product({this.status, this.data, this.pagination});

  Product.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data!.add(ProductData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  get name => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class ProductData {
  int? id;
  String? code;
  String? name;
  String? image;
  int? unitPrice;
  String? createdAt;
  TypeData? type;

  ProductData({
    this.id,
    this.code,
    this.name,
    this.image,
    this.unitPrice,
    this.createdAt,
    this.type,
  });

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    image = mainUrlFile + json['image'];
    unitPrice = json['unit_price'];
    createdAt = json['created_at'];
    type = json['type'] != null ? TypeData.fromJson(json['type']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['image'] = image;
    data['unit_price'] = unitPrice;
    data['created_at'] = createdAt;
    if (type != null) {
      data['type'] = type!.toJson();
    }
    return data;
  }
}

class TypeData {
  int? id;
  String? name;

  TypeData({this.id, this.name});

  TypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? perPage;
  int? totalPages;
  int? totalItems;

  Pagination({
    this.currentPage,
    this.perPage,
    this.totalPages,
    this.totalItems,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    perPage = json['perPage'];
    totalPages = json['totalPages'];
    totalItems = json['totalItems'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['currentPage'] = currentPage;
    data['perPage'] = perPage;
    data['totalPages'] = totalPages;
    data['totalItems'] = totalItems;
    return data;
  }
}
