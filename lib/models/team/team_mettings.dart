class Teammettings{
  DateTime teamMettingsDate;
  String teamMettingsNotes;

  Teammettings({
    required this.teamMettingsDate,
    required this.teamMettingsNotes,
  });

  Map<String, dynamic> toJson(){
    return {
      'teamMettingsDate' : teamMettingsDate.toString(),
      'teamMettingsNotes' : teamMettingsNotes,
    };
  }

  factory Teammettings.fromJson(Map<String, dynamic> json){
    return Teammettings(
      teamMettingsDate: DateTime.parse(json['teamMettingsDate']), 
      teamMettingsNotes: json['teamMettingsNotes'],
    );
  }
}