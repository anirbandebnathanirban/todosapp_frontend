class Error{
  String message;
  dynamic error;

  Error({
    required this.message,
    required this.error,
  });

  factory Error.fromJson(Map<String, dynamic> json){
    return Error(
      message: json['message'], 
      error: json['error'],
    );
  }
}