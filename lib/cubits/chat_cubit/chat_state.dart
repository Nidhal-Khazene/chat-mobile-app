part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatSuccess extends ChatState {
  List<MessageModel> messagesList;
  ChatSuccess({required this.messagesList});
}
