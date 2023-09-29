import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:travel_planner/models/sqflite/conversation.dart';

class SqfLiteService {
  SqfLiteService._();
  static final SqfLiteService instance = SqfLiteService._();

  final String db_name = "travel_planner.db";
  Database? _db;
  List<Conversation> _conversations = [];

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
      CREATE TABLE IF NOT EXISTS "conversation" (
        "id"	INTEGER NOT NULL,
        "title"	TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
      );""";

    const createChatsTable = """
      CREATE TABLE IF NOT EXISTS "chats" (
        "id"	INTEGER NOT NULL,
        "conversation_id"	INTEGER NOT NULL,
        "message"	TEXT NOT NULL,
        "sent_by"	TEXT NOT NULL,
        "created_at"	TEXT NOT NULL,
        PRIMARY KEY("id","conversation_id"),
        FOREIGN KEY("conversation_id") REFERENCES "conversation"("id")
      );""";

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, db_name);
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

  deleteDb() async {
    final db = getDatabase();

    final batch = db.batch();
    batch.commit(noResult: true);
  }
}

class DatabaseAlreadyOpenException implements Exception {}

class DbNotOpen implements Exception {}
