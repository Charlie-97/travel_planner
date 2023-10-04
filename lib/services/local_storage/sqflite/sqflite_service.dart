import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:travel_planner/component/constants.dart';
import 'package:travel_planner/data/sqflite/conversation_model.dart';
import 'package:travel_planner/data/sqflite/message.dart';

class SqfLiteService {
  SqfLiteService._();
  static final SqfLiteService instance = SqfLiteService._();

  static const String dbName = "travel_planner.db";
  Database? _db;

  StreamController<List<ConversationModel>> conversationStream = StreamController<List<ConversationModel>>.broadcast();
  Stream<List<ConversationModel>> get allConversation => conversationStream.stream;

  StreamController<LocalMessage> messageStream = StreamController<LocalMessage>.broadcast();
  Stream<LocalMessage> get chatMesages => messageStream.stream;

  initMessageStream() {
    messageStream = StreamController<LocalMessage>.broadcast();
  }

  initConversationStream() {
    final stream = StreamController<List<ConversationModel>>.broadcast();
    conversationStream = stream;
  }

  closeMessageStream() async {
    messageStream.close();
  }

  Future<void> closeDb() async {
    if (_db == null) {
      throw DbNotOpen();
    }
    await _db?.close();
    _db = null;
  }

  Future<void> openDb() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException;
    }
    const createConversationTable = """
      CREATE TABLE IF NOT EXISTS conversation (
        id	TEXT NOT NULL,
        gpt_id	TEXT NOT NULL,
        title	TEXT NOT NULL,
        updated_at TEXT,
        PRIMARY KEY("id")
      );""";

    const createChatsTable = """
      CREATE TABLE IF NOT EXISTS chats (
        id	TEXT NOT NULL,
        conversation_id	TEXT NOT NULL,
        message	TEXT NOT NULL,
        sent_by	TEXT NOT NULL,
        created_at	TEXT NOT NULL,
        image_url TEXT,
        PRIMARY KEY("id"),
        FOREIGN KEY("conversation_id") REFERENCES "conversation"("gpt_id")
      );""";

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(
        dbPath,
        version: 1,
        onConfigure: (db) async {
          await db.execute(createConversationTable);
          await db.execute(createChatsTable);
        },
        onCreate: (db, version) async {
          await db.execute(createConversationTable);
          await db.execute(createChatsTable);
        },
        onOpen: (db) async {
          await db.execute(createConversationTable);
          await db.execute(createChatsTable);
        },
      );
      _db = db;
    } catch (_) {}
  }

  Database getDatabase() {
    final db = _db;
    if (db != null) {
      return db;
    } else {
      throw DbNotOpen();
    }
  }

  ///Delete local DB
  deleteDb() async {
    try {
      final db = getDatabase();

      final batch = db.batch();
      batch.delete("conversation");
      batch.delete("chats");
      batch.commit(noResult: true);
    } catch (_) {}
  }

  /// Get all conversations on the DB
  Future<List<ConversationModel>> getAllConversation() async {
    try {
      final db = getDatabase();

      return await db.transaction((txn) async {
        final dbConversation = await txn.query(
          "conversation",
          orderBy: 'updated_at DESC',
        );
        if (dbConversation.isEmpty) return [];
        final s = await Future.wait(dbConversation.map((e) async {
          final mostRecentMessage = await txn.query(
            "chats",
            where: "conversation_id = ?",
            whereArgs: [e["gpt_id"]],
            orderBy: "created_at DESC",
            limit: 1,
          );

          final conversation = ConversationModel.fromJson(e);
          if (mostRecentMessage.isNotEmpty) {
            final localMessage = LocalMessage.fromJson(mostRecentMessage.first);
            if (localMessage.message == prompt) {
              localMessage.message = "Hello Traveller! 👋 \n\nHow can I assist you today with your travel plans?";
            }
            conversation.mostRecent = localMessage;
          }

          return conversation;
        }).toList());
        conversationStream.sink.add(s);
        return s;
      });
    } catch (e) {
      return [];
    }
  }

  /// Get a particular conversation on the DB by the ID
  getConversationExit(String chatId) async {
    try {
      final db = getDatabase();

      return await db.transaction((txn) async {
        final conv = await txn.query(
          "conversation",
          where: "gpt_id = ?",
          whereArgs: [chatId],
        );

        if (conv.isEmpty) return null;

        final mostRecentMessage = await txn.query(
          'chats',
          where: "conversation_id = ?",
          whereArgs: [chatId],
          orderBy: "created_at DESC",
          limit: 1,
        );

        final allMessage = await txn.query(
          'chats',
          where: "conversation_id = ?",
          whereArgs: [chatId],
          orderBy: "created_at DESC",
        );

        final conversation = ConversationModel.fromJson(conv.first);
        if (mostRecentMessage.isNotEmpty) {
          final localMessage = LocalMessage.fromJson(mostRecentMessage.first);
          if (localMessage.message == prompt) {
            localMessage.message = "Hello Traveller! 👋 \n\nHow can I assist you today with your travel plans?";
          }
          conversation.mostRecent = localMessage;
        }

        if (allMessage.isNotEmpty) {
          final s = allMessage.map<LocalMessage>((e) {
            final local = LocalMessage.fromJson(e);
            return local;
          }).toList();
          conversation.messages = s;
        }
        conversationStream.sink.add([conversation]);
      });
    } catch (e) {
      return null;
    }
  }

  /// Get a particular conversation on the DB by the ID
  Future<ConversationModel?> getConversation(String chatId) async {
    try {
      final db = getDatabase();

      return await db.transaction((txn) async {
        final conv = await txn.query(
          "conversation",
          where: "gpt_id = ?",
          whereArgs: [chatId],
        );

        if (conv.isEmpty) return null;

        final mostRecentMessage = await txn.query(
          'chats',
          where: "conversation_id = ?",
          whereArgs: [chatId],
          orderBy: "created_at DESC",
          limit: 1,
        );

        final allMessage = await txn.query(
          'chats',
          where: "conversation_id = ?",
          whereArgs: [chatId],
          orderBy: "created_at DESC",
        );

        final conversation = ConversationModel.fromJson(conv.first);
        if (mostRecentMessage.isNotEmpty) {
          final localMessage = LocalMessage.fromJson(mostRecentMessage.first);
          if (localMessage.message == prompt) {
            localMessage.message = "Hello Traveller! 👋 \n\nHow can I assist you today with your travel plans?";
          }
          conversation.mostRecent = localMessage;
        }

        if (allMessage.isNotEmpty) {
          final s = allMessage.map<LocalMessage>((e) {
            final local = LocalMessage.fromJson(e);
            return local;
          }).toList();
          conversation.messages = s;
        }
        return conversation;
      });
    } catch (e) {
      return null;
    }
  }

  ///Delete conversation on the DB
  Future<void> deleteConversation(String id) async {
    try {
      final db = getDatabase();
      final batch = db.batch();
      batch.delete("conversation", where: "gpt_id = ?", whereArgs: [id]);
      batch.delete("chats", where: "conversation_id = ?", whereArgs: [id]);
      batch.commit(noResult: true);
    } catch (_) {}
  }

  ///Delete the message from a conversation on the DB
  Future<void> deleteMessage(String id) async {
    try {
      final db = getDatabase();
      final batch = db.batch();
      batch.delete("chats", where: "id = ?", whereArgs: [id]);
      batch.commit(noResult: true);
    } catch (_) {}
  }

  /// Add a conversation
  Future<ConversationModel?> addConversation(ConversationModel conversation) async {
    try {
      final db = getDatabase();

      await db.transaction((txn) async {
        final s = await txn.query(
          "conversation",
          where: "gpt_id = ?",
          whereArgs: [conversation.gptId],
        );

        if (s.isEmpty) {
          await txn.insert(
            "conversation",
            conversation.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        } else {
          await txn.update(
            "conversation",
            conversation.toJson(),
            where: "gpt_id = ?",
            whereArgs: [conversation.gptId],
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });

      return conversation;
    } catch (e) {
      return null;
    }
  }

  ///Find messages from a given Id
  Future<List<LocalMessage>> findMessages(String chatId) async {
    final db = getDatabase();

    final l = await db.query(
      'chats',
      where: "conversation_id = ?",
      whereArgs: [chatId],
    );

    return l.map<LocalMessage>((e) {
      final local = LocalMessage.fromJson(e);
      return local;
    }).toList();
  }

  ///Get all messages from teh DB
  Future<List<LocalMessage>> getMessages() async {
    final db = getDatabase();

    final l = await db.query('chats');

    if (l.isEmpty) return [];

    return l.map<LocalMessage>((e) {
      final local = LocalMessage.fromJson(e);
      return local;
    }).toList();
  }

  /// Add a message to the message table as well as the conversation table
  Future<void> addMessage(LocalMessage message) async {
    try {
      final db = getDatabase();

      await db.transaction((txn) async {
        final s = await txn.query(
          "chats",
          where: "id = ?",
          whereArgs: [message.id],
        );

        if (s.isEmpty) {
          await txn.insert(
            "chats",
            message.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          await txn.update(
            "conversation",
            {"updated_at": DateTime.now().toIso8601String()},
            where: "gpt_id = ?",
            whereArgs: [message.conversationId],
          );
        } else {
          final r = s.map((e) => LocalMessage.fromJson(e));
          if (r.isEmpty && r.first.conversationId != null && r.first.id != null) {
            await txn.insert(
              "chats",
              message.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
            await txn.update(
              "conversation",
              {"updated_at": DateTime.now().toIso8601String()},
              where: "gpt_id = ?",
              whereArgs: [message.conversationId],
            );
          }
        }
      });
      messageStream.add(message);
    } catch (_) {}
  }
}

class DatabaseAlreadyOpenException implements Exception {}

class DbNotOpen implements Exception {}
