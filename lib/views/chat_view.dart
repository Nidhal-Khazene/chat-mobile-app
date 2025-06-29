import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ChatView extends StatelessWidget {
  ChatView({super.key});
  static String id = "ChatView";

  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollection,
  );
  final ScrollController _scrollController = ScrollController();
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;
    return StreamBuilder<QuerySnapshot>(
      stream:
          messages.orderBy(kCreatedAtDocument, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessageModel> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(MessageModel.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(kLogoImage, height: 55),
                  Text(
                    "Chat",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      fontFamily: "dubai",
                    ),
                  ),
                ],
              ),
              backgroundColor: kPrimaryColor,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].senderId == email
                          ? ChatBubble(message: messagesList[index])
                          : ChatBubbleForFriend(message: messagesList[index]);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(18),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (data) {
                      messages.add({
                        kMessageDocument: data,
                        kCreatedAtDocument: DateTime.now(),
                        kSenderID: email,
                      });
                      controller.clear();
                      _scrollController.animateTo(
                        0,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.send, color: kPrimaryColor),
                      hintText: "Send Message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: LoadingIndicator(
              indicatorType: Indicator.ballPulse,

              /// Required, The loading type of the widget
              colors: const [kSecondaryColor],

              /// Optional, The color collections
              strokeWidth: 2,

              /// Optional, The stroke of the line, only applicable to widget which contains line
              backgroundColor: kPrimaryColor,

              /// Optional, Background of the widget
              pathBackgroundColor: kPrimaryColor,

              /// Optional, the stroke backgroundColor
            ),
          );
        }
      },
    );
  }
}
