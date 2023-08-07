class MediaFile {
    dynamic tbStoreScreens;
    DateTime? daytimeToshow;
    DateTime? daytimeToshowTo;
    int? tbStoreScreensId;
    int? loopcount;
    int? duration;
    int? durationType;
    int? type;
    String? fileName;
    String? fileBaseString;
    bool? isDeleted;
    dynamic lastModificationTime;
    dynamic lastModifierUserId;
    DateTime? creationTime;
    int? creatorUserId;
    int? id;

    MediaFile({
        this.tbStoreScreens,
        this.daytimeToshow,
        this.daytimeToshowTo,
        this.tbStoreScreensId,
        this.loopcount,
        this.duration,
        this.durationType,
        this.type,
        this.fileName,
        this.fileBaseString,
        this.isDeleted,
        this.lastModificationTime,
        this.lastModifierUserId,
        this.creationTime,
        this.creatorUserId,
        this.id,
    });

    factory MediaFile.fromJson(Map<String, dynamic> json) => MediaFile(
        tbStoreScreens: json["tbStoreScreens"],
        daytimeToshow: json["daytimeToshow"] == null ? null : DateTime.parse(json["daytimeToshow"]),
        daytimeToshowTo: json["daytimeToshowTo"] == null ? null : DateTime.parse(json["daytimeToshowTo"]),
        tbStoreScreensId: json["tbStoreScreensId"],
        loopcount: json["loopcount"]??5,
        duration: json["duration"],
        durationType: json["durationType"]??60,
        type: json["type"],
        fileName: json["fileName"],
        fileBaseString: json["fileBaseString"],
        isDeleted: json["isDeleted"],
        lastModificationTime: json["lastModificationTime"],
        lastModifierUserId: json["lastModifierUserId"],
        creationTime: json["creationTime"] == null ? null : DateTime.parse(json["creationTime"]),
        creatorUserId: json["creatorUserId"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "tbStoreScreens": tbStoreScreens,
        "daytimeToshow": daytimeToshow?.toIso8601String(),
        "daytimeToshowTo": daytimeToshowTo?.toIso8601String(),
        "tbStoreScreensId": tbStoreScreensId,
        "loopcount": loopcount,
        "duration": duration,
        "durationType": durationType,
        "type": type,
        "fileName": fileName,
        "fileBaseString": fileBaseString,
        "isDeleted": isDeleted,
        "lastModificationTime": lastModificationTime,
        "lastModifierUserId": lastModifierUserId,
        "creationTime": creationTime?.toIso8601String(),
        "creatorUserId": creatorUserId,
        "id": id,
    };
}