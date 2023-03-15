class FileModel {
  String title;
  String discription;
  String path;
  String remark;
  String status;
  String time;
  String sender;
  FileModel(
      {required this.title,
      required this.discription,
      required this.path,
      required this.remark,
      required this.status,
      required this.time,
      required this.sender});

  Map<String, dynamic> tomap() {
    return {
      'title': title,
      'discription': discription,
      'path': path,
      'remark': remark,
      'status': status,
      'time': time,
      'sender': sender
    };
  }
}

class fileHistory {
  String sender;
  String receiver;
  String time;

  fileHistory(
      {required this.sender, required this.receiver, required this.time});

  Map<String, dynamic> tomap() {
    return {'sender': sender, 'receiver': receiver, 'time': time};
  }
}
