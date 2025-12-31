import 'dart:typed_data';

class UserModel {
  String fullName;
  String dob;
  String email;
  String phone;
  String studentId;
  Uint8List? imageBytes;

  UserModel({
    this.fullName = "",
    this.dob = "",
    this.email = "",
    this.phone = "",
    this.studentId = "",
    this.imageBytes,
  });
}