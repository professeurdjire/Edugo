import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'assistant_message.g.dart';

abstract class AssistantMessage implements Built<AssistantMessage, AssistantMessageBuilder> {
  static Serializer<AssistantMessage> get serializer => _$assistantMessageSerializer;

  int? get sessionId;
  BuiltList<Message>? get messages;

  AssistantMessage._();
  factory AssistantMessage([void Function(AssistantMessageBuilder) updates]) = _$AssistantMessage;
}

abstract class Message implements Built<Message, MessageBuilder> {
  static Serializer<Message> get serializer => _$messageSerializer;

  String? get role; // 'USER' or 'ASSISTANT' or 'SYSTEM'
  String? get content;
  String? get createdAt;

  Message._();
  factory Message([void Function(MessageBuilder) updates]) = _$Message;
}
