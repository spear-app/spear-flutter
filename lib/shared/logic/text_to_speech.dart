import 'dart:async';
import 'package:text_to_speech/text_to_speech.dart';

TextToSpeech tts = TextToSpeech();

Future speak(text, gender, language)
async{
  double pitch;
  if (gender == 1) {//female
    pitch = 0.88;
  } else {
    pitch = 0.55;
  }

  String? languageCode = await tts.getLanguageCodeByName(language!);
  tts.setLanguage(languageCode!);
  tts.setPitch(pitch);
  await tts.speak(text);
}