class StoreBranches {
    List<BaseItem>? items;

    StoreBranches({
        this.items,
    });

    factory StoreBranches.fromJson(Map<String, dynamic> json) => StoreBranches(
        items: json["result"] == null ? [] : List<BaseItem>.from(json["result"]!.map((x) => BaseItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}

class BaseItem {
    String? aname;
    String? ename;
    String? address;
    String? taxrecord;
    String? commercialrecord;
    String? mobile1;
    String? mobile2;
    String? phone1;
    String? phone2;
    String? email;
    String? bankaccountnumber;
    dynamic tbAllAuthorizationId;
    bool? isDeleted;
    dynamic logo;
    dynamic portalId;
    dynamic accountId;
    dynamic licenseId;
    String? additionaldetails;
    int? tbCitiesId;
    dynamic tbBranchsSections;
    dynamic lastModificationTime;
    dynamic lastModifierUserId;
    DateTime? creationTime;
    int? creatorUserId;
    int? id;

    BaseItem({
        this.aname,
        this.ename,
        this.address,
        this.taxrecord,
        this.commercialrecord,
        this.mobile1,
        this.mobile2,
        this.phone1,
        this.phone2,
        this.email,
        this.bankaccountnumber,
        this.tbAllAuthorizationId,
        this.isDeleted,
        this.logo,
        this.portalId,
        this.accountId,
        this.licenseId,
        this.additionaldetails,
        this.tbCitiesId,
        this.tbBranchsSections,
        this.lastModificationTime,
        this.lastModifierUserId,
        this.creationTime,
        this.creatorUserId,
        this.id,
    });

    factory BaseItem.fromJson(Map<String, dynamic> json) => BaseItem(
        aname: json["aname"]?? json["name"]??"",
        ename: json["ename"],
        address: json["address"],
        taxrecord: json["taxrecord"],
        commercialrecord: json["commercialrecord"],
        mobile1: json["mobile1"],
        mobile2: json["mobile2"],
        phone1: json["phone1"],
        phone2: json["phone2"],
        email: json["email"],
        bankaccountnumber: json["bankaccountnumber"],
        tbAllAuthorizationId: json["tbAllAuthorizationId"],
        isDeleted: json["isDeleted"],
        logo: json["logo"],
        portalId: json["portalId"],
        accountId: json["accountId"],
        licenseId: json["licenseId"],
        additionaldetails: json["additionaldetails"],
        tbCitiesId: json["tbCitiesId"],
        tbBranchsSections: json["tbBranchsSections"],
        lastModificationTime: json["lastModificationTime"],
        lastModifierUserId: json["lastModifierUserId"],
        creationTime: json["creationTime"] == null ? null : DateTime.parse(json["creationTime"]),
        creatorUserId: json["creatorUserId"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "aname": aname,
        "name": ename,
        "address": address,
        "taxrecord": taxrecord,
        "commercialrecord": commercialrecord,
        "mobile1": mobile1,
        "mobile2": mobile2,
        "phone1": phone1,
        "phone2": phone2,
        "email": email,
        "bankaccountnumber": bankaccountnumber,
        "tbAllAuthorizationId": tbAllAuthorizationId,
        "isDeleted": isDeleted,
        "logo": logo,
        "portalId": portalId,
        "accountId": accountId,
        "licenseId": licenseId,
        "additionaldetails": additionaldetails,
        "tbCitiesId": tbCitiesId,
        "tbBranchsSections": tbBranchsSections,
        "lastModificationTime": lastModificationTime,
        "lastModifierUserId": lastModifierUserId,
        "creationTime": creationTime?.toIso8601String(),
        "creatorUserId": creatorUserId,
        "id": id,
    };
}
