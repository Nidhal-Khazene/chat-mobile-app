import 'package:bloc/bloc.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../constants.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollection,
  );
  List<MessageModel> messagesList = [];

  void sendMessage({required String message, required String email}) {
    messages.add({
      kMessageDocument: message,
      kCreatedAtDocument: DateTime.now(),
      kSenderID: email,
    });
  }

  void getMessages() {
    messages.orderBy(kCreatedAtDocument, descending: true).snapshots().listen((
      event,
    ) {
      messagesList.clear();
      for (var doc in event.docs) {
        messagesList.add(MessageModel.fromJson(doc));
      }
      emit(ChatSuccess(messagesList: messagesList));
    });
  }
}
