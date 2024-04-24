import 'package:locachat/data/response/status.dart';

class ApiResponse<T> {
  Status? status;
  T? data;
  String? massage;

  ApiResponse(this.status, this.data, this.massage);

  ApiResponse.loading() : status = Status.LOADING;

  ApiResponse.completed(this.data) : status = Status.COMPLETED;

  ApiResponse.error(this.massage) : status = Status.ERROR;

  @override
  String toString() {
    return "status :$status \n data :$data \n massage :$massage";
  }
}
