class LeadJson {
  final int? pagecount;
  final int? pagesize;
  final int? pagenumber;
  final int? rowcount;
  final List<Windowrecords>? windowrecords;

  LeadJson({
    this.pagecount,
    this.pagesize,
    this.pagenumber,
    this.rowcount,
    this.windowrecords,
  });

  LeadJson.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        pagesize = json['page-size'] as int?,
        pagenumber = json['page-number'] as int?,
        rowcount = json['row-count'] as int?,
        windowrecords = (json['window-records'] as List?)
            ?.map((dynamic e) =>
                Windowrecords.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'page-size': pagesize,
        'page-number': pagenumber,
        'row-count': rowcount,
        'window-records': windowrecords?.map((e) => e.toJson()).toList()
      };
}

class Windowrecords {
  final int? id;
  final String? uid;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final String? value;
  final LeadStatus? leadStatus;
  final SalesRepID? salesRepID;
  final bool? isActive;
  final String? name;
  final bool? isVendorLead;
  final CJobID? cJobID;
  final LeadSource? leadSource;
  final String? phone;
  final String? eMail;
  final String? name2;
  final String? bPName;
  final BPLocationID? bPLocationID;
  final bool? isPublic;
  final bool? lITIsPartner;
  final bool? isConfirmed;
  final String? slug;

  Windowrecords({
    this.id,
    this.uid,
    this.aDClientID,
    this.aDOrgID,
    this.value,
    this.leadStatus,
    this.salesRepID,
    this.isActive,
    this.name,
    this.isVendorLead,
    this.cJobID,
    this.leadSource,
    this.phone,
    this.eMail,
    this.name2,
    this.bPName,
    this.bPLocationID,
    this.isPublic,
    this.lITIsPartner,
    this.isConfirmed,
    this.slug,
  });

  Windowrecords.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        value = json['Value'] as String?,
        leadStatus = (json['LeadStatus'] as Map<String, dynamic>?) != null
            ? LeadStatus.fromJson(json['LeadStatus'] as Map<String, dynamic>)
            : null,
        salesRepID = (json['SalesRep_ID'] as Map<String, dynamic>?) != null
            ? SalesRepID.fromJson(json['SalesRep_ID'] as Map<String, dynamic>)
            : null,
        isActive = json['IsActive'] as bool?,
        name = json['Name'] as String?,
        isVendorLead = json['IsVendorLead'] as bool?,
        cJobID = (json['C_Job_ID'] as Map<String, dynamic>?) != null
            ? CJobID.fromJson(json['C_Job_ID'] as Map<String, dynamic>)
            : null,
        leadSource = (json['LeadSource'] as Map<String, dynamic>?) != null
            ? LeadSource.fromJson(json['LeadSource'] as Map<String, dynamic>)
            : null,
        phone = json['Phone'] as String?,
        eMail = json['EMail'] as String?,
        name2 = json['Name2'] as String?,
        bPName = json['BPName'] as String?,
        bPLocationID = (json['BP_Location_ID'] as Map<String, dynamic>?) != null
            ? BPLocationID.fromJson(
                json['BP_Location_ID'] as Map<String, dynamic>)
            : null,
        isPublic = json['IsPublic'] as bool?,
        lITIsPartner = json['LIT_IsPartner'] as bool?,
        isConfirmed = json['IsConfirmed'] as bool?,
        slug = json['slug'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'Value': value,
        'LeadStatus': leadStatus?.toJson(),
        'SalesRep_ID': salesRepID?.toJson(),
        'IsActive': isActive,
        'Name': name,
        'IsVendorLead': isVendorLead,
        'C_Job_ID': cJobID?.toJson(),
        'LeadSource': leadSource?.toJson(),
        'Phone': phone,
        'EMail': eMail,
        'Name2': name2,
        'BPName': bPName,
        'BP_Location_ID': bPLocationID?.toJson(),
        'IsPublic': isPublic,
        'LIT_IsPartner': lITIsPartner,
        'IsConfirmed': isConfirmed,
        'slug': slug
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

class LeadStatus {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  LeadStatus({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LeadStatus.fromJson(Map<String, dynamic> json)
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

class SalesRepID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  SalesRepID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  SalesRepID.fromJson(Map<String, dynamic> json)
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

class CJobID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CJobID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CJobID.fromJson(Map<String, dynamic> json)
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

class LeadSource {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  LeadSource({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LeadSource.fromJson(Map<String, dynamic> json)
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

class BPLocationID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  BPLocationID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  BPLocationID.fromJson(Map<String, dynamic> json)
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
