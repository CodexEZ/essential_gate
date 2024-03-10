// To parse this JSON data, do
//
//     final leaveViewApiModel = leaveViewApiModelFromJson(jsonString);

import 'dart:convert';

List<LeaveViewApiModel> leaveViewApiModelFromJson(String str) => List<LeaveViewApiModel>.from(json.decode(str).map((x) => LeaveViewApiModel.fromJson(x)));

String leaveViewApiModelToJson(List<LeaveViewApiModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeaveViewApiModel {
  int? id;
  String? denialReason;
  String? status;
  String? reason;
  DateTime? departure;
  DateTime? arrival;
  String? hostel;
  String? gatePass;
  String? hash;
  DateTime? timestamp;
  Student? student;
  Profile? profile;
  String? college;
  dynamic hod;
  String? warden;

  LeaveViewApiModel({
    this.id,
    this.denialReason,
    this.status,
    this.reason,
    this.departure,
    this.arrival,
    this.hostel,
    this.gatePass,
    this.hash,
    this.timestamp,
    this.student,
    this.profile,
    this.college,
    this.hod,
    this.warden,
  });

  factory LeaveViewApiModel.fromJson(Map<String, dynamic> json) => LeaveViewApiModel(
    id: json["id"],
    denialReason: json["denial_reason"],
    status: json["status"],
    reason: json["reason"],
    departure: json["departure"] == null ? null : DateTime.parse(json["departure"]),
    arrival: json["arrival"] == null ? null : DateTime.parse(json["arrival"]),
    hostel: json["hostel"],
    gatePass: json["gate_pass"],
    hash: json["hash"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    student: json["student"] == null ? null : Student.fromJson(json["student"]),
    profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
    college: json["college"],
    hod: json["hod"],
    warden: json["warden"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "denial_reason": denialReason,
    "status": status,
    "reason": reason,
    "departure": departure?.toIso8601String(),
    "arrival": arrival?.toIso8601String(),
    "hostel": hostel,
    "gate_pass": gatePass,
    "hash": hash,
    "timestamp": timestamp?.toIso8601String(),
    "student": student?.toJson(),
    "profile": profile?.toJson(),
    "college": college,
    "hod": hod,
    "warden": warden,
  };
}

class Profile {
  String? rollNo;
  String? password;
  String? sex;
  String? parentNo;
  String? collegeEmail;
  String? branch;
  String? batch;
  String? hostel;
  String? room;
  String? user;
  String? college;

  Profile({
    this.rollNo,
    this.password,
    this.sex,
    this.parentNo,
    this.collegeEmail,
    this.branch,
    this.batch,
    this.hostel,
    this.room,
    this.user,
    this.college,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    rollNo: json["roll_no"],
    password: json["password"],
    sex: json["sex"],
    parentNo: json["parent_no"],
    collegeEmail: json["college_email"],
    branch: json["branch"],
    batch: json["batch"],
    hostel: json["hostel"],
    room: json["room"],
    user: json["user"],
    college: json["college"],
  );

  Map<String, dynamic> toJson() => {
    "roll_no": rollNo,
    "password": password,
    "sex": sex,
    "parent_no": parentNo,
    "college_email": collegeEmail,
    "branch": branch,
    "batch": batch,
    "hostel": hostel,
    "room": room,
    "user": user,
    "college": college,
  };
}

class Student {
  String? username;
  String? name;
  String? about;
  List<String>? interests;
  String? college;
  String? pfp;

  Student({
    this.username,
    this.name,
    this.about,
    this.interests,
    this.college,
    this.pfp,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    username: json["username"],
    name: json["name"],
    about: json["about"],
    interests: json["interests"] == null ? [] : List<String>.from(json["interests"]!.map((x) => x)),
    college: json["college"],
    pfp: json["pfp"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "name": name,
    "about": about,
    "interests": interests == null ? [] : List<dynamic>.from(interests!.map((x) => x)),
    "college": college,
    "pfp": pfp,
  };
}
