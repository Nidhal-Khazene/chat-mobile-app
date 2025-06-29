import 'package:chat_app/constants.dart';

class MessageModel {
  final String message;
  final String senderId;
  const MessageModel({required this.senderId, required this.message});
  factory MessageModel.fromJson(jsonData) => MessageModel(
    message: jsonData[kMessageDocument],
    senderId: jsonData[kSenderID],
  );
}
