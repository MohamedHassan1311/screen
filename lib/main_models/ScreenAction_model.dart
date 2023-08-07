// To parse this JSON data, do
//
//     final screenAction = screenActionFromJson(jsonString);

import 'dart:convert';

List<ScreenAction> screenActionFromJson(String str) => List<ScreenAction>.from(json.decode(str).map((x) => ScreenAction.fromJson(x)));



class ScreenAction {
  String? orderNo;
  int? screenId;
  int? tbStoreScreensId;
  int? tentId;
  bool? isDeleted;
  int? id;

  ScreenAction({
    this.orderNo,
    this.screenId,
    this.isDeleted,
    this.id,
    this.tbStoreScreensId,
    this.tentId
  });

  static List<ScreenAction> listFromJson(list) =>
      List<ScreenAction>.from(list.map((x) => ScreenAction.fromJson(x)));
  factory ScreenAction.fromJson(Map<String, dynamic> json) => ScreenAction(
    orderNo: json["orderNo"],
    screenId: json["tbBranchsId"],
    isDeleted: json["isDeleted"],
    id: json["id"],
    tentId: json["creatorUserId"],
    tbStoreScreensId: json["tbStoreScreensId"],
  );

  Map<String, dynamic> toJson() => {
    "orderNo": orderNo,
    "tbBranchsId": screenId,
    "isDeleted": isDeleted,
    "id": id,
  };
}
