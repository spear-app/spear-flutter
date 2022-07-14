
class Notificationn {
  String NotificationTitle;
  String NotififcationBody;
  DateTime time;
  int id;

  Notificationn( this.NotificationTitle, this.NotififcationBody, this.time,this.id,);

  factory Notificationn.fromJson(dynamic json){
    return Notificationn(
        "title" as String,
        "body" as String,
        DateTime.now(),
        "user_id" as int );
  }
}
