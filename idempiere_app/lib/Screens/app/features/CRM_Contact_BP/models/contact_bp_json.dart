class ContactJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  ContactJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  ContactJson.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => Records.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'records-size': recordssize,
        'skip-records': skiprecords,
        'row-count': rowcount,
        'records': records?.map((e) => e.toJson()).toList()
      };
}

class Records {
  final int? id;
  final String? uid;
  final String? name;
  final String? description;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? eMail;
  final CBPartnerID? cBPartnerID;
  final MDiscountSchemaID? mDiscountSchemaID;
  final String? eMailUser;
  final NotificationType? notificationType;
  final bool? isFullBPAccess;
  final String? value;
  final bool? isInPayroll;
  final bool? isSalesLead;
  final bool? isLocked;
  final int? failedLoginCount;
  final String? datePasswordChanged;
  final bool? isNoPasswordReset;
  final bool? isExpired;
  final bool? isAddMailTextAutomatically;
  final RDefaultMailTextID? rDefaultMailTextID;
  final bool? isNoExpire;
  final bool? isSupportUser;
  final bool? isShipTo;
  final bool? isBillTo;
  final bool? isVendorLead;
  final bool? isLegalUser;
  final bool? lITIsWebTicket;
  final bool? lITIsMailReader;
  final bool? lITIsPartner;
  final bool? isPublic;
  final bool? isFavourite;
  final ADUser2ID? adUser2ID;
  final ADUserID? adUserID;
  final String? modelname;
  final String? phone;

  Records({
    this.id,
    this.uid,
    this.name,
    this.description,
    this.aDClientID,
    this.aDOrgID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.eMail,
    this.cBPartnerID,
    this.mDiscountSchemaID,
    this.eMailUser,
    this.notificationType,
    this.isFullBPAccess,
    this.value,
    this.isInPayroll,
    this.isSalesLead,
    this.isLocked,
    this.failedLoginCount,
    this.datePasswordChanged,
    this.isNoPasswordReset,
    this.isExpired,
    this.isAddMailTextAutomatically,
    this.rDefaultMailTextID,
    this.isNoExpire,
    this.isSupportUser,
    this.isShipTo,
    this.isBillTo,
    this.isVendorLead,
    this.isLegalUser,
    this.lITIsWebTicket,
    this.lITIsMailReader,
    this.lITIsPartner,
    this.isPublic,
    this.isFavourite,
    this.adUser2ID,
    this.adUserID,
    this.modelname,
    this.phone,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        name = json['Name'] as String?,
        description = json['Description'] as String?,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        isActive = json['IsActive'] as bool?,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        updated = json['Updated'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        eMail = json['EMail'] as String?,
        phone = json['Phone'] as String?,
        cBPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        mDiscountSchemaID =
            (json['M_DiscountSchema_ID'] as Map<String, dynamic>?) != null
                ? MDiscountSchemaID.fromJson(
                    json['M_DiscountSchema_ID'] as Map<String, dynamic>)
                : null,
        eMailUser = json['EMailUser'] as String?,
        notificationType =
            (json['NotificationType'] as Map<String, dynamic>?) != null
                ? NotificationType.fromJson(
                    json['NotificationType'] as Map<String, dynamic>)
                : null,
        isFullBPAccess = json['IsFullBPAccess'] as bool?,
        value = json['Value'] as String?,
        isInPayroll = json['IsInPayroll'] as bool?,
        isSalesLead = json['IsSalesLead'] as bool?,
        isLocked = json['IsLocked'] as bool?,
        failedLoginCount = json['FailedLoginCount'] as int?,
        datePasswordChanged = json['DatePasswordChanged'] as String?,
        isNoPasswordReset = json['IsNoPasswordReset'] as bool?,
        isExpired = json['IsExpired'] as bool?,
        isAddMailTextAutomatically =
            json['IsAddMailTextAutomatically'] as bool?,
        rDefaultMailTextID =
            (json['R_DefaultMailText_ID'] as Map<String, dynamic>?) != null
                ? RDefaultMailTextID.fromJson(
                    json['R_DefaultMailText_ID'] as Map<String, dynamic>)
                : null,
        isNoExpire = json['IsNoExpire'] as bool?,
        isSupportUser = json['IsSupportUser'] as bool?,
        isShipTo = json['IsShipTo'] as bool?,
        isBillTo = json['IsBillTo'] as bool?,
        isVendorLead = json['IsVendorLead'] as bool?,
        isLegalUser = json['isLegalUser'] as bool?,
        lITIsWebTicket = json['LIT_isWebTicket'] as bool?,
        lITIsMailReader = json['LIT_isMailReader'] as bool?,
        lITIsPartner = json['LIT_IsPartner'] as bool?,
        isPublic = json['IsPublic'] as bool?,
        isFavourite = json['IsFavourite'] as bool?,
        adUser2ID = (json['AD_User2_ID'] as Map<String, dynamic>?) != null
            ? ADUser2ID.fromJson(json['AD_User2_ID'] as Map<String, dynamic>)
            : null,
        adUserID = (json['AD_User_ID'] as Map<String, dynamic>?) != null
            ? ADUserID.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
            : null,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'Name': name,
        'Description': description,
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'IsActive': isActive,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'EMail': eMail,
        'Phone': phone,
        'C_BPartner_ID': cBPartnerID?.toJson(),
        'EMailUser': eMailUser,
        'NotificationType': notificationType?.toJson(),
        'IsFullBPAccess': isFullBPAccess,
        'Value': value,
        'IsInPayroll': isInPayroll,
        'IsSalesLead': isSalesLead,
        'IsLocked': isLocked,
        'FailedLoginCount': failedLoginCount,
        'DatePasswordChanged': datePasswordChanged,
        'IsNoPasswordReset': isNoPasswordReset,
        'IsExpired': isExpired,
        'IsAddMailTextAutomatically': isAddMailTextAutomatically,
        'R_DefaultMailText_ID': rDefaultMailTextID?.toJson(),
        'IsNoExpire': isNoExpire,
        'IsSupportUser': isSupportUser,
        'IsShipTo': isShipTo,
        'IsBillTo': isBillTo,
        'IsVendorLead': isVendorLead,
        'isLegalUser': isLegalUser,
        'LIT_isWebTicket': lITIsWebTicket,
        'LIT_isMailReader': lITIsMailReader,
        'LIT_IsPartner': lITIsPartner,
        'IsPublic': isPublic,
        'IsFavourite': isFavourite,
        'model-name': modelname
      };
}

class ADClientID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADClientID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADClientID.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as int?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class ADOrgID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADOrgID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADOrgID.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as int?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class CreatedBy {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CreatedBy({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CreatedBy.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as int?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class UpdatedBy {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  UpdatedBy({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  UpdatedBy.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as int?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class ADUser2ID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADUser2ID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADUser2ID.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as int?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class ADUserID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADUserID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADUserID.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as int?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class CBPartnerID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CBPartnerID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBPartnerID.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as int?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class MDiscountSchemaID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MDiscountSchemaID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MDiscountSchemaID.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as int?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class NotificationType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  NotificationType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  NotificationType.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as String?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class RDefaultMailTextID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  RDefaultMailTextID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  RDefaultMailTextID.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as int?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}
