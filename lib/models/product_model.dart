class ProductModel {
  String id;
  String name;
  String detail;
  String path;
  String code;

  ProductModel({this.id, this.name, this.detail, this.path, this.code});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['Name'];
    detail = json['Detail'];
    path = json['Path'];
    code = json['Code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Name'] = this.name;
    data['Detail'] = this.detail;
    data['Path'] = this.path;
    data['Code'] = this.code;
    return data;
  }
}

