import 'dart:convert';

ChatbotResponse chatbotResponseFromJson(String str) => ChatbotResponse.fromJson(json.decode(str));

String chatbotResponseToJson(ChatbotResponse data) => json.encode(data.toJson());

class ChatbotResponse {
  String answer = '';
  bool isNormalQuestion = true;
  bool isShortcut = true;
  bool isTutorial = true;

  ChatbotResponse({
    this.answer,
    this.isNormalQuestion,
    this.isShortcut,
    this.isTutorial,
  });

  factory ChatbotResponse.fromJson(Map<String, dynamic> json) => ChatbotResponse(
    answer: json["answer"],
    isNormalQuestion: (json["is_normal_question"].toLowerCase() == 'true'),
    isShortcut: (json["is_shortcut"].toLowerCase() == 'true'),
    isTutorial: (json["is_tutorial"].toLowerCase() == 'true'),
  );

  Map<String, dynamic> toJson() => {
    "answer": answer,
    "is_normal_question": isNormalQuestion,
    "is_shortcut": isShortcut,
    "is_tutorial": isTutorial
  };

  String getAnswer() {
    return answer;
  }

  bool getIfNormalQuestion() {
    return isNormalQuestion;
  }

  bool getIfShortcut() {
    return isShortcut;
  }

  bool getIfTutorial() {
    return isTutorial;
  }
}