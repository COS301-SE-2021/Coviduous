import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/user_homepage.dart';

import 'package:frontend/controllers/chatbot/chatbot_controller.dart' as chatbotController;
import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

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

  @override
  void initState() {
    super.initState();
    _initChatbot();
  }

  //This function ensures that the app doesn't just close when you press a phone's physical back button
  Future<bool> _onWillPop() async {
    if (globals.previousPage != '' && globals.previousPage != null) {
      Navigator.of(context).pushReplacementNamed(globals.previousPage);
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
            title: Text("Chat Bot"),
            elevation: 0,
            leading: BackButton( //Specify back button
              onPressed: (){
                if (globals.previousPage != '' && globals.previousPage != null) {
                  Navigator.of(context).pushReplacementNamed(globals.previousPage);
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

  _requestChatBot(String message) async {
    chatbotController.sendAndReceive(message).then((result) {
      if (result != null) {
        _addMessage(
            name: "Chat Bot",
            initials: "CB",
            bot: true,
            showImage: (result.getIfTutorial()) ? true : false,
            isShortcut: (result.getIfShortcut()) ? true : false,
            text: result.getAnswer()
        );
      }
    });
  }

  void _initChatbot() async {
    _addMessage(
        name: "Chat Bot",
        initials: "CB",
        bot: true,
        text: "Hello, I am the Coviduous Chat Bot! Do you need any help? 🤖\n\nType 'tutorial' for a list of tutorials; 'shortcut-admin', 'shortcut-user', or 'shortcut-visitor' for a list of shortcuts; or ask me a question."
    );
  }

  void _addMessage(
      {String name, String initials, bool bot = false, bool showImage = false, bool isShortcut = false, String text}) {
    var animationController = AnimationController(
      duration: new Duration(milliseconds: 700),
      vsync: this,
    );

    var message = ChatMessage(
        name: name,
        text: text,
        initials: initials,
        bot: bot,
        animationController: animationController,
        showImage: showImage,
        isShortcut: isShortcut
    );

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
  final bool showImage;
  final bool isShortcut;

  AnimationController animationController;

  ChatMessage(
      {
        this.name,
        this.initials,
        this.text,
        this.bot = false,
        this.showImage = false,
        this.isShortcut = false,
        this.animationController
      });
}

class ChatMessageListItem extends StatelessWidget {
  final ChatMessage chatMessage;

  ChatMessageListItem(this.chatMessage);

  Widget _showMessage(BuildContext context) {
    if (chatMessage.showImage && !chatMessage.text.contains('Type any of these tutorials you would like to see.')) { //If showing an image
      return ElevatedButton(
        child: Text(
            'View tutorial'
        ),
        onPressed: () {
          var rng = new Random();
          globalWidgets.showMemoryImage(context, base64Decode(chatMessage.text), 'Coviduous saved tutorial ' + rng.nextInt(100).toString(), 'png');
        },
      );
    } else {
      if (chatMessage.isShortcut && chatMessage.text.substring(0, 1) == '/') { //If a shortcut is sent back
        return ElevatedButton(
          child: Text(
            'Access your shortcut here'
          ),
          onPressed: () {
            chatbotController.navigateShortcut(context, chatMessage.text);
          },
        );
      } else { //Else, just text
        return Text(
            chatMessage.text,
            style: TextStyle(
              color: Colors.black,
            )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
          parent: chatMessage.animationController, curve: Curves.easeOut),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        //======================================
        //          If bot message
        //======================================
        child: (chatMessage.bot == true) ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: CircleAvatar(
                    child: Text(
                      chatMessage.initials ?? "CB",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: globals.focusColor,
                  ),
                ),
              ],
            ),
            Flexible(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(chatMessage.name ?? "Chat Bot",
                          style: TextStyle(color: globals.lineColor)
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(10),
                          child: _showMessage(context),
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ],
          //======================================
          //          If user message
          //======================================
        ) : Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(chatMessage.name ?? "Visitor",
                        style: TextStyle(color: globals.lineColor)
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Color(0xffB2FDFF),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          chatMessage.text,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    child: Text(
                      chatMessage.initials ?? "V",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: globals.firstColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}