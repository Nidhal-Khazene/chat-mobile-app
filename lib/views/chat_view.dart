import 'package:chat_app/constants.dart';
import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});
  static String id = "ChatView";

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ScrollController _scrollController = ScrollController();

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;

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
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                var messagesList =
                    BlocProvider.of<ChatCubit>(context).messagesList;
                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                    return messagesList[index].senderId == email
                        ? ChatBubble(message: messagesList[index])
                        : ChatBubbleForFriend(message: messagesList[index]);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(18),
            child: TextField(
              controller: controller,
              onSubmitted: (data) {
                BlocProvider.of<ChatCubit>(
                  context,
                ).sendMessage(message: data, email: email);
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
  }
}
