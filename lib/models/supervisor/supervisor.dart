import 'package:mongo_dart/mongo_dart.dart';
import 'supervisor_name.dart';

class Supervisor{
  ObjectId? supervisorId;
  Supervisorname supervisorName;
  String supervisorPrimaryEmail;
  List<String>? supervisorSecondaryEmails;
  List<String>? supervisorContactNumber;
  
  Supervisor({
    this.supervisorId,
    required this.supervisorName,
    required this.supervisorPrimaryEmail,
    this.supervisorSecondaryEmails,
    this.supervisorContactNumber,
  });

  Map<String, dynamic> toJson(){
    return {
      '_id' : supervisorId,
      'supervisorName' : supervisorName.toJson(),
      'supervisorPrimaryEmail' : supervisorPrimaryEmail,
      'supervisorSecondaryEmails' : supervisorSecondaryEmails,
      'supervisorContactNumber' : supervisorContactNumber,
    };
  }

  factory Supervisor.fromJson(Map<String, dynamic> json){
    return Supervisor(
      supervisorId: ObjectId.parse(json['_id']),
      supervisorName: json['supervisorName'], 
      supervisorPrimaryEmail: json['supervisorPrimaryEmail'],
      supervisorSecondaryEmails: List<String>.from(json['supervisorSecondaryEmails']),
      supervisorContactNumber: List<String>.from(json['supervisorContactNumber']),
    );
  }
}