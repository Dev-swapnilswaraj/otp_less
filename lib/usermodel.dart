class UserData {
  String? waId;
  String? waNumber;
  String? waName;
  String? timestamp;

  UserData({this.waId, this.waNumber, this.waName, this.timestamp});

  UserData.fromJson(Map<String, dynamic> json) {
    waId = json['waId'];
    waNumber = json['waNumber'];
    waName = json['waName'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['waId'] = this.waId;
    data['waNumber'] = this.waNumber;
    data['waName'] = this.waName;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
