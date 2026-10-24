/// Non-web platforms never construct the browser speech recognizer.
library;

import 'speech.dart';

SpeechRecognizer? createWebSpeechRecognizer() => null;
