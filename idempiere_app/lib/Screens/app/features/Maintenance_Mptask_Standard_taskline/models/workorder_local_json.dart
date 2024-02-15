class WorkOrderLocalJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  List<WORecords>? records;

  WorkOrderLocalJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  WorkOrderLocalJson.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => WORecords.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'records-size': recordssize,
        'skip-records': skiprecords,
        'row-count': rowcount,
        'records': records?.map((e) => e.toJson()).toList()
      };
}

class WORecords {
  final int? id;
  final MPOTID? mPOTID;
  final ADClientID? aDClientID;
  final String? documentNo;
  final String? documentNo2;
  final UpdatedBy? updatedBy;
  final String? created;
  final CreatedBy? createdBy;
  final String? dateTrx;
  final String? dateNextRun;
  final String? dateLastRun;
  String? description;
  final DocStatus? docStatus;
  final bool? isActive;
  final MPMaintainID? mPMaintainID;
  final bool? processed;
  final String? updated;
  final ADOrgID? aDOrgID;
  final CDocTypeID? cDocTypeID;
  final String? mPOTUU;
  final String? dateWorkStart;
  final CBPartnerID? cBPartnerID;
  final CBPartnerLocationID? cBPartnerLocationID;
  final JPTeamID? jPTeamID;
  final String? mpOtAdUserName;
  final int? mpOtTaskQty;
  String? mpOtTaskStatus;
  final String? cBpartnerLocationPhone;
  final String? cBpartnerLocationEmail;
  final String? cBpartnerLocationName;
  final String? cLocationAddress1;
  final String? cLocationCity;
  final String? cLocationPostal;
  final String? cCountryTrlName;
  final MPOTTaskID? mPOTTaskID;
  final MPMaintainTaskID? mPMaintainTaskID;
  final String? modelname;
  final String? phone;
  final String? phone2;
  final String? refname;
  final String? ref2name;
  final String? team;
  String? jpToDoStartDate;
  String? jpToDoEndDate;
  final String? jpToDoStartTime;
  final String? jpToDoEndTime;
  final String? litMpMaintainHelp;
  final String? note;
  String? manualNote;
  final COrderID? cOrderID;
  final LITCDocTypeODVID? litcDocTypeODVID;
  String? attachment;
  JPToDoID? jPToDoID;
  JPToDoStatus? jpToDoStatus;
  PaymentRule? paymentRule;
  int? litSignImageID;
  CInvoiceID? cInvoiceID;
  num? paidAmt;
  bool? isPaid;
  String? contracttypename;
  String? name;
  bool? isPrinted;

  WORecords(
      {this.id,
      this.mPOTID,
      this.aDClientID,
      this.documentNo,
      this.documentNo2,
      this.dateNextRun,
      this.dateLastRun,
      this.updatedBy,
      this.created,
      this.createdBy,
      this.dateTrx,
      this.description,
      this.docStatus,
      this.isActive,
      this.mPMaintainID,
      this.processed,
      this.updated,
      this.aDOrgID,
      this.cDocTypeID,
      this.mPOTUU,
      this.dateWorkStart,
      this.cBPartnerID,
      this.cBPartnerLocationID,
      this.jPTeamID,
      this.mpOtAdUserName,
      this.mpOtTaskQty,
      this.mpOtTaskStatus,
      this.cBpartnerLocationPhone,
      this.cBpartnerLocationEmail,
      this.cBpartnerLocationName,
      this.cLocationAddress1,
      this.cLocationCity,
      this.cLocationPostal,
      this.cCountryTrlName,
      this.mPOTTaskID,
      this.mPMaintainTaskID,
      this.modelname,
      this.phone,
      this.phone2,
      this.refname,
      this.ref2name,
      this.team,
      this.jpToDoStartDate,
      this.jpToDoEndDate,
      this.jpToDoStartTime,
      this.jpToDoEndTime,
      this.litMpMaintainHelp,
      this.note,
      this.manualNote,
      this.attachment,
      this.litcDocTypeODVID,
      this.jPToDoID,
      this.jpToDoStatus,
      this.cOrderID,
      this.paymentRule,
      this.litSignImageID,
      this.cInvoiceID,
      this.paidAmt,
      this.isPaid,
      this.name,
      this.contracttypename,
      this.isPrinted});

  WORecords.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        mPOTID = (json['MP_OT_ID'] as Map<String, dynamic>?) != null
            ? MPOTID.fromJson(json['MP_OT_ID'] as Map<String, dynamic>)
            : null,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        documentNo = json['DocumentNo'] as String?,
        documentNo2 = json['maintain_documentno'] as String?,
        dateNextRun = json['DateNextRun'] as String?,
        dateLastRun = json['DateLastRun'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        dateTrx = json['DateTrx'] as String?,
        description = json['Description'] as String?,
        docStatus = (json['DocStatus'] as Map<String, dynamic>?) != null
            ? DocStatus.fromJson(json['DocStatus'] as Map<String, dynamic>)
            : null,
        isActive = json['IsActive'] as bool?,
        mPMaintainID = (json['MP_Maintain_ID'] as Map<String, dynamic>?) != null
            ? MPMaintainID.fromJson(
                json['MP_Maintain_ID'] as Map<String, dynamic>)
            : null,
        processed = json['Processed'] as bool?,
        updated = json['Updated'] as String?,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        cDocTypeID = (json['C_DocType_ID'] as Map<String, dynamic>?) != null
            ? CDocTypeID.fromJson(json['C_DocType_ID'] as Map<String, dynamic>)
            : null,
        mPOTUU = json['MP_OT_UU'] as String?,
        dateWorkStart = json['DateWorkStart'] as String?,
        cBPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        cBPartnerLocationID =
            (json['C_BPartner_Location_ID'] as Map<String, dynamic>?) != null
                ? CBPartnerLocationID.fromJson(
                    json['C_BPartner_Location_ID'] as Map<String, dynamic>)
                : null,
        jPTeamID = (json['JP_Team_ID'] as Map<String, dynamic>?) != null
            ? JPTeamID.fromJson(json['JP_Team_ID'] as Map<String, dynamic>)
            : null,
        mpOtAdUserName = json['mp_ot_ad_user_name'] as String?,
        mpOtTaskQty = json['mp_ot_task_qty'] as int?,
        mpOtTaskStatus = json['mp_ot_task_status'] as String?,
        cBpartnerLocationPhone = json['c_bpartner_location_phone'] as String?,
        cBpartnerLocationEmail = json['c_bpartner_location_email'] as String?,
        cBpartnerLocationName = json['c_bpartner_location_name'] as String?,
        cLocationAddress1 = json['c_location_address1'] as String?,
        cLocationCity = json['c_location_city'] as String?,
        cLocationPostal = json['c_location_postal'] as String?,
        cCountryTrlName = json['c_country_trl_name'] as String?,
        mPOTTaskID = (json['MP_OT_Task_ID'] as Map<String, dynamic>?) != null
            ? MPOTTaskID.fromJson(json['MP_OT_Task_ID'] as Map<String, dynamic>)
            : null,
        cOrderID = (json['C_Order_ID'] as Map<String, dynamic>?) != null
            ? COrderID.fromJson(json['C_Order_ID'] as Map<String, dynamic>)
            : null,
        cInvoiceID = (json['C_Invoice_ID'] as Map<String, dynamic>?) != null
            ? CInvoiceID.fromJson(json['C_Invoice_ID'] as Map<String, dynamic>)
            : null,
        mPMaintainTaskID =
            (json['MP_Maintain_Task_ID'] as Map<String, dynamic>?) != null
                ? MPMaintainTaskID.fromJson(
                    json['MP_Maintain_Task_ID'] as Map<String, dynamic>)
                : null,
        phone = json['Phone'] as String?,
        phone2 = json['Phone2'] as String?,
        refname = json['ref_name'] as String?,
        ref2name = json['ref2_name'] as String?,
        modelname = json['model-name'] as String?,
        team = json['team'] as String?,
        jpToDoStartDate = json['JP_ToDo_ScheduledStartDate'] as String?,
        jpToDoEndDate = json['JP_ToDo_ScheduledEndDate'] as String?,
        jpToDoStartTime = json['JP_ToDo_ScheduledStartTime'] as String?,
        jpToDoEndTime = json['JP_ToDo_ScheduledEndTime'] as String?,
        note = json['Note'] as String?,
        manualNote = json['ManualNote'] as String?,
        attachment = json['attachment'] as String?,
        litcDocTypeODVID =
            (json['LIT_C_DocTypeODV_ID'] as Map<String, dynamic>?) != null
                ? LITCDocTypeODVID.fromJson(
                    json['LIT_C_DocTypeODV_ID'] as Map<String, dynamic>)
                : null,
        jPToDoID = (json['JP_ToDo_ID'] as Map<String, dynamic>?) != null
            ? JPToDoID.fromJson(json['JP_ToDo_ID'] as Map<String, dynamic>)
            : null,
        jpToDoStatus = (json['JP_ToDo_Status'] as Map<String, dynamic>?) != null
            ? JPToDoStatus.fromJson(
                json['JP_ToDo_Status'] as Map<String, dynamic>)
            : null,
        paymentRule = (json['PaymentRule'] as Map<String, dynamic>?) != null
            ? PaymentRule.fromJson(json['PaymentRule'] as Map<String, dynamic>)
            : null,
        paidAmt = json['PaidAmt'] as num?,
        litSignImageID = json['LIT_Sign_Image_ID'] as int?,
        isPaid = json['IsPaid'] as bool?,
        contracttypename = json['contracttypename'] as String?,
        name = json['Name'] as String?,
        isPrinted = json['IsPrinted'] as bool?,
        litMpMaintainHelp = json['mp_maintain_help'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'MP_OT_ID': mPOTID?.toJson(),
        'AD_Client_ID': aDClientID?.toJson(),
        'DocumentNo': documentNo,
        'maintain_documentno': documentNo2,
        'DateNextRun': dateNextRun,
        'DateLastRun': dateLastRun,
        'UpdatedBy': updatedBy?.toJson(),
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'DateTrx': dateTrx,
        'Description': description,
        'DocStatus': docStatus?.toJson(),
        'IsActive': isActive,
        'MP_Maintain_ID': mPMaintainID?.toJson(),
        'Processed': processed,
        'Updated': updated,
        'AD_Org_ID': aDOrgID?.toJson(),
        'C_DocType_ID': cDocTypeID?.toJson(),
        'MP_OT_UU': mPOTUU,
        'DateWorkStart': dateWorkStart,
        'C_BPartner_ID': cBPartnerID?.toJson(),
        'C_BPartner_Location_ID': cBPartnerLocationID?.toJson(),
        'JP_Team_ID': jPTeamID?.toJson(),
        'C_Order_ID': cOrderID?.toJson(),
        'mp_ot_ad_user_name': mpOtAdUserName,
        'mp_ot_task_qty': mpOtTaskQty,
        'mp_ot_task_status': mpOtTaskStatus,
        'c_bpartner_location_phone': cBpartnerLocationPhone,
        'c_bpartner_location_email': cBpartnerLocationEmail,
        'c_bpartner_location_name': cBpartnerLocationName,
        'c_location_address1': cLocationAddress1,
        'c_location_city': cLocationCity,
        'c_location_postal': cLocationPostal,
        'c_country_trl_name': cCountryTrlName,
        'MP_OT_Task_ID': mPOTTaskID?.toJson(),
        'MP_Maintain_Task_ID': mPMaintainTaskID?.toJson(),
        'Phone': phone,
        'Phone2': phone2,
        'ref_name': refname,
        'ref2_name': ref2name,
        'model-name': modelname,
        'team': team,
        'JP_ToDo_ScheduledStartDate': jpToDoStartDate,
        'JP_ToDo_ScheduledEndDate': jpToDoEndDate,
        'JP_ToDo_ScheduledStartTime': jpToDoStartTime,
        'JP_ToDo_ScheduledEndTime': jpToDoEndTime,
        'Note': note,
        'ManualNote': manualNote,
        'attachment': attachment,
        'mp_maintain_help': litMpMaintainHelp,
        'JP_ToDo_ID': jPToDoID?.toJson(),
        'JP_ToDo_Status': jpToDoStatus?.toJson(),
        'PaymentRule': paymentRule?.toJson(),
        'C_Invoice_ID': cInvoiceID?.toJson(),
        'IsPaid': isPaid,
        'Name': name,
        'IsPrinted': isPrinted,
        'contracttypename': contracttypename,
      };
}

class PaymentRule {
  final String? propertyLabel;
  String? id;
  String? identifier;
  final String? modelname;

  PaymentRule({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  PaymentRule.fromJson(Map<String, dynamic> json)
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

class LITSignImageID {
  final String? propertyLabel;
  int? id;
  String? identifier;
  final String? modelname;

  LITSignImageID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITSignImageID.fromJson(Map<String, dynamic> json)
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

class MPOTID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPOTID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPOTID.fromJson(Map<String, dynamic> json)
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

class JPToDoID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  JPToDoID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  JPToDoID.fromJson(Map<String, dynamic> json)
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

class JPToDoStatus {
  final String? propertyLabel;
  String? id;
  String? identifier;
  final String? modelname;

  JPToDoStatus({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  JPToDoStatus.fromJson(Map<String, dynamic> json)
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

class DocStatus {
  final String? propertyLabel;
  String? id;
  final String? identifier;
  final String? modelname;

  DocStatus({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DocStatus.fromJson(Map<String, dynamic> json)
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

class MPMaintainID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPMaintainID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPMaintainID.fromJson(Map<String, dynamic> json)
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

class LITCDocTypeODVID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITCDocTypeODVID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITCDocTypeODVID.fromJson(Map<String, dynamic> json)
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

class CDocTypeID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CDocTypeID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CDocTypeID.fromJson(Map<String, dynamic> json)
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

class COrderID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  COrderID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  COrderID.fromJson(Map<String, dynamic> json)
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

class CInvoiceID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CInvoiceID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CInvoiceID.fromJson(Map<String, dynamic> json)
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

class CBPartnerLocationID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CBPartnerLocationID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBPartnerLocationID.fromJson(Map<String, dynamic> json)
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

class JPTeamID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  JPTeamID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  JPTeamID.fromJson(Map<String, dynamic> json)
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

class MPOTTaskID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPOTTaskID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPOTTaskID.fromJson(Map<String, dynamic> json)
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

class MPMaintainTaskID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPMaintainTaskID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPMaintainTaskID.fromJson(Map<String, dynamic> json)
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
