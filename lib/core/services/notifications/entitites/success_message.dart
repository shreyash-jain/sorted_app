class SuccessOTPResponse {
  String message;
  String otp;

  SuccessOTPResponse({this.message, this.otp});

  SuccessOTPResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['otp'] = this.otp;
    return data;
  }
}
