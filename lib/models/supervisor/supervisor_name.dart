class Supervisorname{
  String supervisorFirstName;
  String? supervisorMiddleName;
  String supervisorLastName;

  Supervisorname({
    required this.supervisorFirstName,
    this.supervisorMiddleName,
    required this.supervisorLastName,
  });

  Map<String, dynamic> toJson(){
    return {
      'supervisorFirstName' : supervisorFirstName,
      'supervisorMiddleName' : supervisorMiddleName,
      'supervisorLastName' : supervisorLastName,
    };
  }

  factory Supervisorname.fromJson(Map<String, dynamic> json){
    return Supervisorname(
      supervisorFirstName: json['supervisorFirstName'],
      supervisorMiddleName: json['supervisorMiddleName'],
      supervisorLastName: json['supervisorLastName'],
    );
  }
}