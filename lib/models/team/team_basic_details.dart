class Teambasicdetails{
  String? teamDescription;
  DateTime teamCreationTime;
  DateTime teamLastModificationTime;

  Teambasicdetails({
    this.teamDescription,
    required this.teamCreationTime,
    required this.teamLastModificationTime,
  });

  Map<String, dynamic> toJson(){
    return {
      'teamDescription' : teamDescription,
      'teamCreationTime' : teamCreationTime.toString(),
      'teamLastModificationTime' : teamLastModificationTime.toString(),
    };
  }

  factory Teambasicdetails.fromJson(Map<String, dynamic> json){
    return Teambasicdetails(
      teamDescription: json['teamDescription'],
      teamCreationTime: DateTime.parse(json['teamCreationTime']),
      teamLastModificationTime: DateTime.parse(json['teamLastModificationTime']),
    );
  }
}