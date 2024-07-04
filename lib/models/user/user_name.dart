class Username{
  String userFirstName;
  String? userMiddleName;
  String userLastName;

  Username({
    required this.userFirstName,
    this.userMiddleName,
    required this.userLastName,
  });

  Map<String, dynamic> toJson(){
    return {
      'userFirstName' : userFirstName,
      'userMiddleName' : userMiddleName,
      'userLastName' : userLastName,
    };
  }

  factory Username.fromJson(Map<String, dynamic> json){
    return Username(
      userFirstName: json['userFirstName'], 
      userMiddleName: json['userMiddleName'],
      userLastName: json['userLastName'],
    );
  }
}