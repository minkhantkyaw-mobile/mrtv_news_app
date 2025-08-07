import 'package:mrtv_new_app_sl/models/base_record.dart';

class WorldNewModel {
  bool? status;
  String? message;
  Pagination? pagination;
  List<Records>? records;

  WorldNewModel({this.status, this.message, this.pagination, this.records});

  WorldNewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    pagination =
        json['pagination'] != null
            ? new Pagination.fromJson(json['pagination'])
            : null;
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records!.add(new Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.records != null) {
      data['records'] = this.records!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int? totalRecords;
  int? totalPages;
  String? currentPage;

  Pagination({this.totalRecords, this.totalPages, this.currentPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    totalRecords = json['total_records'];
    totalPages = json['total_pages'];
    currentPage = json['current_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_records'] = this.totalRecords;
    data['total_pages'] = this.totalPages;
    data['current_page'] = this.currentPage;
    return data;
  }
}

class Records extends BaseRecord {
  int? nid;
  String? postedDate;
  String? title;
  String? video;
  String? image;
  Null? body;

  Records({
    this.nid,
    this.postedDate,
    this.title,
    this.video,
    this.image,
    this.body,
  });

  Records.fromJson(Map<String, dynamic> json) {
    nid = json['nid'];
    postedDate = json['posted_date'];
    title = json['title'];
    video = json['video'];
    image = json['image'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nid'] = this.nid;
    data['posted_date'] = this.postedDate;
    data['title'] = this.title;
    data['video'] = this.video;
    data['image'] = this.image;
    data['body'] = this.body;
    return data;
  }
}
