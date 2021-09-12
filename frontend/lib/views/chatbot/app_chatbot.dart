import 'package:flutter/material.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/globals.dart' as globals;

///commented dialogflow dependencies since we are using AI. It was just for testing.
///import 'package:googleapis/dialogflow/v2.dart';
///import 'package:googleapis_auth/auth_io.dart';
///import 'package:flutter/services.dart';

class ChatMessages extends StatefulWidget {
  static const routeName = "/chat_bot";
  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages>
    with TickerProviderStateMixin {
  List<ChatMessage> _messages = [];
  bool _isComposing = false;

  TextEditingController _controllerText = new TextEditingController();

  ///DialogflowApi _dialog;

  @override
  void initState() {
    super.initState();
    //_initChatbot();
    _addMessage(
       name: "Chat Bot",
       initials: "CB",
       bot: true,
       text: "Hello, I am the Coviduous ChatBot! Do you need any help?\n\nType 'tutorial' for a list of tutorials, 'shortcut' for a list of shortcuts, or ask me a question."
    );
  }

  //This function ensures that the app doesn't just close when you press a phone's physical back button
  Future<bool> _onWillPop() async {
    if (globals.chatbotPreviousPage != '' && globals.chatbotPreviousPage != null) {
      Navigator.of(context).pushReplacementNamed(globals.chatbotPreviousPage);
    } else {
      if (globals.loggedInUserType == 'ADMIN') {
        Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
      } else if (globals.loggedInUserType == 'USER') {
        Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      }
    }
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text("ChatBot"),
            elevation: 0,
            leading: BackButton( //Specify back button
              onPressed: (){
                if (globals.chatbotPreviousPage != '' && globals.chatbotPreviousPage != null) {
                  Navigator.of(context).pushReplacementNamed(globals.chatbotPreviousPage);
                } else {
                  if (globals.loggedInUserType == 'ADMIN') {
                    Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
                  } else if (globals.loggedInUserType == 'USER') {
                    Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
                  } else {
                    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                  }
                }
              },
            ),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                _buildList(),
                Container(
                  color: Colors.white,
                  child: _buildComposer(),
                ),
              ],
            ),
          )),
    );
  }

  _buildList() {
    return Flexible(
      child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          reverse: true,
          itemCount: _messages.length,
          itemBuilder: (_, index) {
            return Container(child: ChatMessageListItem(_messages[index]));
          }),
    );
  }

  _buildComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _controllerText,
              onChanged: (value) {
                setState(() {
                  _isComposing = _controllerText.text.length > 0;
                });
              },
              onSubmitted: _handleSubmit,
              decoration: InputDecoration.collapsed(hintText: "Ask your question"),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: globals.firstColor,
            ),
            onPressed:
            _isComposing ? () => _handleSubmit(_controllerText.text) : null,
          ),
        ],
      ),
    );
  }

  _handleSubmit(String value) {
    _controllerText.clear();
    if (globals.loggedInUser != null) {
      _addMessage(
        text: value,
        name: globals.loggedInUser.firstName + ' ' + globals.loggedInUser.lastName,
        initials: globals.loggedInUser.firstName.substring(0, 1) + globals.loggedInUser.lastName.substring(0, 1),
      );
    } else {
      _addMessage(
        text: value,
        name: "Visitor",
        initials: "V",
      );
    }

    _requestChatBot(value);
  }

  _requestChatBot(String text) async {
   /// var dialogSessionId = "projects/chatbot-gdg/agent/sessions/ChatbotGDG";
   //
   //  Map data = {
   //    "queryInput": {
   //      "text": {
   //        "text": text,
   //        "languageCode": "fr",
   //      }
   //    }
   //  };

    ///var request = GoogleCloudDialogflowV2DetectIntentRequest.fromJson(data);

    // var resp = await _dialog.projects.agent.sessions
    //     .detectIntent(request, dialogSessionId);
    // var result = resp.queryResult;
    // _addMessage(
    //     name: "Chat Bot",
    //     initials: "CB",
    //     bot: true,
    //     text: result.fulfillmentText);
  }

  // void _initChatbot() async {
  //   String configString = await rootBundle.loadString('config/dialogflow.json');
  //   String _dialogFlowConfig = configString;
  //
  //   var credentials = new ServiceAccountCredentials.fromJson(_dialogFlowConfig);
  //
  //   const _SCOPES = const [DialogflowApi.CloudPlatformScope];
  //
  //   var httpClient = await clientViaServiceAccount(credentials, _SCOPES);
  //   _dialog = new DialogflowApi(httpClient);
  // }

  void _addMessage(
      {String name, String initials, bool bot = false, String text}) {
    var animationController = AnimationController(
      duration: new Duration(milliseconds: 700),
      vsync: this,
    );

    var message = ChatMessage(
        name: name,
        text: text,
        initials: initials,
        bot: bot,
        animationController: animationController);

    setState(() {
      _messages.insert(0, message);
    });

    animationController.forward();
  }
}

class ChatMessage {
  final String name;
  final String initials;
  final String text;
  final bool bot;

  AnimationController animationController;

  ChatMessage(
      {this.name,
        this.initials,
        this.text,
        this.bot = false,
        this.animationController});
}

class ChatMessageListItem extends StatelessWidget {
  final ChatMessage chatMessage;

  ChatMessageListItem(this.chatMessage);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
          parent: chatMessage.animationController, curve: Curves.easeOut),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: CircleAvatar(
                child: Text(
                  chatMessage.initials ?? "V",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: chatMessage.bot
                    ? globals.focusColor
                    : globals.firstColor,
              ),
            ),
            Flexible(
                child: Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(chatMessage.name ?? "Visitor",
                            style: TextStyle(color: globals.lineColor)
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              chatMessage.text,
                              style: TextStyle(color: Colors.white),
                            )
                        )
                      ],
                    ))
            )
          ],
        ),
      ),
    );
  }
}