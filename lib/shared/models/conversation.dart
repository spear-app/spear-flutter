import 'package:spear_ui/modules/chat/message.dart';
import 'package:spear_ui/shared/logic/text_to_speech.dart';

class Conversation{

  List<Message> messagesList = [];

  Future sendMessage( String messagee , String language) async {
    if (messagee.isEmpty) return;
    final message = Message(
        content: messagee,
        time: DateTime.now().microsecondsSinceEpoch,
        senderName: "You",
        sent: true,
        language: language
    );

    await speak(messagee, 1, language);
  }

}