

class Message{
  String content;
  int time;
  String senderName;
  bool sent;
  String language;

  Message({required this.content, required this.time , required this.senderName, required this.sent, required this.language});


  factory Message.fromJson(Map<String, dynamic> json){
    return Message(
        content: json["text"] as String,
        time: 122222,
        senderName: json["speaker"] as String,
        sent: false,//recieved
        language: ""
    );
  }
}