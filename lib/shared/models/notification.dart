
class Notificationn {
  String NotificationTitle;
  String NotififcationBody;
  DateTime time;
  int id;

  Notificationn( this.NotificationTitle, this.NotififcationBody, this.time,this.id,);

  factory Notificationn.fromJson(dynamic json){
    return Notificationn(
        json["title"] as String,
        json["body"] as String,
        DateTime.parse(json["created_at"] as String),
        json["id"] as int);
  }
}
