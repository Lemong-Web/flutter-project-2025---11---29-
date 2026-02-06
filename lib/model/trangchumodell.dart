
class TrangChuModel {
  List<TheloaiTrangChuModel>? lstTheLoai = [];
  List<TrangChuTruyenHot>? lstTruyenHot = [];
  List<TrangChuMoiCapNhat>? lstTruyenMoiCapNhat = [];

  String? version = "1.0.0";
  int? theoDoiChuaDoc = 0;
  int? thongBaoMoi = 0;
  int? versionNumber = 1;

  TrangChuModel({
    this.lstTheLoai,
    this.lstTruyenHot,
    this.lstTruyenMoiCapNhat,
    this.version,
    this.theoDoiChuaDoc,
    this.thongBaoMoi,
    this.versionNumber
  });

  static TrangChuModel fromJson(dynamic data) {
    List<TheloaiTrangChuModel> lstTheLoai = [];
    if (data['theloai'] != null) {
      lstTheLoai = TheloaiTrangChuModel.fromJson(data['theloai']);
    }
    List<TrangChuTruyenHot> lstHot = [];
    if (data['truyenhot'] != null) {
      lstHot = TrangChuTruyenHot.listFromJson(data['truyenhot']);
    }
    List<TrangChuMoiCapNhat> lstMoiCapNhat = [];
    if (data['truyenmoicapnhat'] != null) {
      lstMoiCapNhat = TrangChuMoiCapNhat.listFromJson(data['truyenmoicapnhat']);
    }
    
    return TrangChuModel(
      lstTheLoai: lstTheLoai,
      lstTruyenHot: lstHot,
      lstTruyenMoiCapNhat: lstMoiCapNhat,
      version: data['version'] ?? "1.0.0",
      theoDoiChuaDoc: data['theoDoiChuaDoc'],
      thongBaoMoi: data['thongBaoMoi'],
      versionNumber: data['versionNumber']
    );
  }
}


class TheloaiTrangChuModel {
  String? tenTheLoai;
  String? moTa;
  String? iD;
  List<TrangchuStoryTheLoai>? truyen;

  TheloaiTrangChuModel({
    this.tenTheLoai,
    this.moTa,
    this.iD,
    this.truyen
  });

  static List<TheloaiTrangChuModel> fromJson (List data) {
    return data.map((e) => TheloaiTrangChuModel(
      iD: e['ID'],
      moTa: e['MoTa'],
      tenTheLoai: e['TenTheLoai'],
      truyen: e['Truyen']
    )).toList();
  }
}

class TrangchuStoryTheLoai {
  String? storyImage;
  String? storyName;
  String? storyTitleLastChap;
  String? storyID;
  String? storyUpdateTime;
  String? storyNameK;

  TrangchuStoryTheLoai({
    this.storyImage,
    this.storyName,
    this.storyTitleLastChap,
    this.storyID,
    this.storyUpdateTime,
    this.storyNameK,
  });

  factory TrangchuStoryTheLoai.fromJson(Map<String, dynamic> json) {
    return TrangchuStoryTheLoai(
      storyImage: json['StoryImage'],
      storyName: json['StoryName'],
      storyTitleLastChap: json['StoryTitleLastChap'],
      storyID: json['StoryID'],
      storyUpdateTime: json['StoryUpdateTime'],
      storyNameK: json['StoryNameK'],
    );
  }

  static List<TrangchuStoryTheLoai> listFromJson(List data) {
    return data.map((e) => TrangchuStoryTheLoai.fromJson(e)).toList();
  }
}

class TrangChuMoiCapNhat {
  String? storyID;
  String? storyName;
  String? storyImage;
  String? storyUpdateTime;
  String? storyTitleLastChap;
  String? nameKLastChap;
  String? storyNameK;
  int? storyView;
  int? storyTrangChuType;
  int? isKhuyenKhichDoc;
  List? storyTheLoai;
  String? storyDescription;
  String? iD;
  String? mongoID;

  TrangChuMoiCapNhat({
    this.storyID,
    this.storyName,
    this.storyImage,
    this.storyUpdateTime,
    this.storyTitleLastChap,
    this.storyNameK,
    this.storyView,
    this.storyTrangChuType,
    this.isKhuyenKhichDoc,
    this.storyTheLoai,
    this.mongoID
  });

  factory TrangChuMoiCapNhat.fromJson(Map<String, dynamic> json) {
    return TrangChuMoiCapNhat(
      storyID: json['StoryID'],
      storyName: json['StoryName'],
      storyImage: json['StoryImage'],
      storyUpdateTime: json['StoryUpdateTime'],
      storyTitleLastChap: json['StoryTitleLastChap'],
      storyNameK: json['StoryNameK'],
      storyView: json['StoryView'],
      storyTrangChuType: json['StoryTrangChuType'],
      isKhuyenKhichDoc: json['IsKhuyenKhichDoc'],
      storyTheLoai: json['StoryTheLoai'],
    );
  }

  static List<TrangChuMoiCapNhat> listFromJson(List data) {
    return data.map((e) => TrangChuMoiCapNhat.fromJson(e)).toList();
  }
}

class TrangChuTruyenHot {
  String? storyID;
  String? storyName;
  String? storyImage;
  String? storyUpdateTime;
  String? storyTitleLastChap;
  String? nameKLastChap;
  String? storyNameK;
  int? storyView;
  int? storyTrangChuType;
  int? isKhuyenKhichDoc;
  List? storyTheLoai;
  String? storyDescription;
  String? iD;
  String? mongoID;

  TrangChuTruyenHot({
    this.storyID,
    this.storyName,
    this.storyImage,
    this.storyUpdateTime,
    this.storyTitleLastChap,
    this.storyNameK,
    this.storyView,
    this.storyTrangChuType,
    this.isKhuyenKhichDoc,
    this.storyTheLoai,
    this.mongoID
  });

  factory TrangChuTruyenHot.fromJson(Map<String, dynamic> json) {
    return TrangChuTruyenHot(
      storyID: json['StoryID'],
      storyName: json['StoryName'],
      storyImage: json['StoryImage'],
      storyUpdateTime: json['StoryUpdateTime'],
      storyTitleLastChap: json['StoryTitleLastChap'],
      storyNameK: json['StoryNameK'],
      storyView: json['StoryView'],
      storyTrangChuType: json['StoryTrangChuType'],
      isKhuyenKhichDoc: json['IsKhuyenKhichDoc'],
      storyTheLoai: json['StoryTheLoai'],
    );
  }

  static List<TrangChuTruyenHot> listFromJson(List data) {
    return data.map((e) => TrangChuTruyenHot.fromJson(e)).toList();
  }
}