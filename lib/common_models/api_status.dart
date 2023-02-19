class Success {
  int code;
  Object response;
  Success({this.code = 200, required this.response});
}

class Failure {
  int code;
  Object errorResponse;
  Failure({this.code = 200, this.errorResponse = ""});
}
