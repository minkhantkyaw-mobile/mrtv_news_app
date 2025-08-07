import 'package:mrtv_new_app_sl/models/base_record.dart';

class RadioNewModel {
  bool? status;
  String? message;
  Pagination? pagination;
  List<Records>? records;

  RadioNewModel({this.status, this.message, this.pagination, this.records});

  RadioNewModel.fromJson(Map<String, dynamic> json) {
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
  @override
  final int? nid;

  @override
  final String? title;

  final String? audio;
  final String? body;

  @override
  final String? video; // ← use this to hold audio too!

  @override
  final String? image;

  @override
  final String? postedDate;

  Records({
    this.nid,
    this.title,
    this.postedDate,
    this.image,
    this.audio,
    this.video,
    this.body,
  });

  factory Records.fromJson(Map<String, dynamic> json) {
    return Records(
      nid: json['nid'],
      title: json['title'],
      postedDate: json['posted_date'],
      image: json['image'],
      audio: json['audio'],
      video: json['video'] ?? json['audio'], // 👈 fallback
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nid'] = this.nid;
    data['title'] = this.title;
    data['posted_date'] = this.postedDate;
    data['image'] = this.image;
    data['audio'] = this.audio;
    data['video'] = this.video;
    data['body'] = this.body;
    return data;
  }
}
