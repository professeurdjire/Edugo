// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assistant_message.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AssistantMessage> _$assistantMessageSerializer =
    _$AssistantMessageSerializer();
Serializer<Message> _$messageSerializer = _$MessageSerializer();

class _$AssistantMessageSerializer
    implements StructuredSerializer<AssistantMessage> {
  @override
  final Iterable<Type> types = const [AssistantMessage, _$AssistantMessage];
  @override
  final String wireName = 'AssistantMessage';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    AssistantMessage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[];
    Object? value;
    value = object.sessionId;
    if (value != null) {
      result
        ..add('sessionId')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.messages;
    if (value != null) {
      result
        ..add('messages')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(Message),
            ]),
          ),
        );
    }
    return result;
  }

  @override
  AssistantMessage deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssistantMessageBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'sessionId':
          result.sessionId =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int?;
          break;
        case 'messages':
          result.messages.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(Message),
                  ]),
                )!
                as BuiltList<Object?>,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$MessageSerializer implements StructuredSerializer<Message> {
  @override
  final Iterable<Type> types = const [Message, _$Message];
  @override
  final String wireName = 'Message';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    Message object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[];
    Object? value;
    value = object.role;
    if (value != null) {
      result
        ..add('role')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.content;
    if (value != null) {
      result
        ..add('content')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.createdAt;
    if (value != null) {
      result
        ..add('createdAt')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  Message deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MessageBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'role':
          result.role =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'content':
          result.content =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'createdAt':
          result.createdAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$AssistantMessage extends AssistantMessage {
  @override
  final int? sessionId;
  @override
  final BuiltList<Message>? messages;

  factory _$AssistantMessage([
    void Function(AssistantMessageBuilder)? updates,
  ]) => (AssistantMessageBuilder()..update(updates))._build();

  _$AssistantMessage._({this.sessionId, this.messages}) : super._();
  @override
  AssistantMessage rebuild(void Function(AssistantMessageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssistantMessageBuilder toBuilder() =>
      AssistantMessageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssistantMessage &&
        sessionId == other.sessionId &&
        messages == other.messages;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, messages.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssistantMessage')
          ..add('sessionId', sessionId)
          ..add('messages', messages))
        .toString();
  }
}

class AssistantMessageBuilder
    implements Builder<AssistantMessage, AssistantMessageBuilder> {
  _$AssistantMessage? _$v;

  int? _sessionId;
  int? get sessionId => _$this._sessionId;
  set sessionId(int? sessionId) => _$this._sessionId = sessionId;

  ListBuilder<Message>? _messages;
  ListBuilder<Message> get messages =>
      _$this._messages ??= ListBuilder<Message>();
  set messages(ListBuilder<Message>? messages) => _$this._messages = messages;

  AssistantMessageBuilder();

  AssistantMessageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sessionId = $v.sessionId;
      _messages = $v.messages?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssistantMessage other) {
    _$v = other as _$AssistantMessage;
  }

  @override
  void update(void Function(AssistantMessageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssistantMessage build() => _build();

  _$AssistantMessage _build() {
    _$AssistantMessage _$result;
    try {
      _$result =
          _$v ??
          _$AssistantMessage._(
            sessionId: sessionId,
            messages: _messages?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'messages';
        _messages?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AssistantMessage',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Message extends Message {
  @override
  final String? role;
  @override
  final String? content;
  @override
  final String? createdAt;

  factory _$Message([void Function(MessageBuilder)? updates]) =>
      (MessageBuilder()..update(updates))._build();

  _$Message._({this.role, this.content, this.createdAt}) : super._();
  @override
  Message rebuild(void Function(MessageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MessageBuilder toBuilder() => MessageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Message &&
        role == other.role &&
        content == other.content &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Message')
          ..add('role', role)
          ..add('content', content)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class MessageBuilder implements Builder<Message, MessageBuilder> {
  _$Message? _$v;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  MessageBuilder();

  MessageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _role = $v.role;
      _content = $v.content;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Message other) {
    _$v = other as _$Message;
  }

  @override
  void update(void Function(MessageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Message build() => _build();

  _$Message _build() {
    final _$result =
        _$v ?? _$Message._(role: role, content: content, createdAt: createdAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
