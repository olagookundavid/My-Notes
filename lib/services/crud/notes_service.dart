import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

import 'crud_exceptions.dart';

class DataBaseUser {
  final int id;
  final String email;

  DataBaseUser({
    required this.id,
    required this.email,
  });
  DataBaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  bool operator ==(covariant DataBaseUser other) => id == other.id;
  @override
  int get hashCode => id.hashCode;
}

class DataBaseNotes {
  final int id;
  final int userId;
  final String text;

  DataBaseNotes({
    required this.id,
    required this.userId,
    required this.text,
  });
  DataBaseNotes.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String;
  @override
  bool operator ==(covariant DataBaseUser other) => id == other.id;
  @override
  int get hashCode => id.hashCode;
}

class NoteService {
  Database? _db;
  //get current db
  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DataBaseIsNotOpen();
    } else {
      return db;
    }
  }

  //opening the DB
  Future<void> open() async {
    //checking db is not null
    if (_db != null) {
      throw DataBaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      //create the user table
      await db.execute(createUserTable);
      //create the note table
      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {}
  }

  //closing the Db
  Future<void> close() async {
    final db = _db;
    // checking if Db is null
    if (db == null) {
      throw DataBaseIsNotOpen();
    } else {
      await db.close();
    }
  }

  Future<DataBaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTable,
      where: 'email =?',
      limit: 1,
      whereArgs: [email.toLowerCase()],
    );
    if (result.isNotEmpty) throw UserAlreadyExist();
    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });
    return DataBaseUser(id: userId, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email =?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Future<DataBaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTable,
      where: 'email =?',
      limit: 1,
      whereArgs: [email.toLowerCase()],
    );
    if (result.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DataBaseUser.fromRow(result.first);
    }
  }

  Future<DataBaseNotes> createNote({required DataBaseUser owner}) async {
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    const text = "";
    //create notes
    final noteId = await db.insert(
      noteTable,
      {userIdColumn: owner.id, textColumn: text},
    );
    final note = DataBaseNotes(id: noteId, userId: owner.id, text: text);
    return note;
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'email =?',
      whereArgs: [id],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteNote();
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  Future<DataBaseNotes> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id =?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFineNote();
    } else {
      return DataBaseNotes.fromRow(notes.first);
    }
  }

  Future<DataBaseNotes> getAllNote() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
    );
    if (notes.isEmpty) {
      throw CouldNotFineNote();
    } else {
      return DataBaseNotes.fromRow(notes.first);
    }
  }

  Future<DataBaseNotes> updateNote({
    required DataBaseNotes note,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);
    final updatesCount = await db.update(
      noteTable,
      {textColumn: text},
    );
    if (updatesCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      return await getNote(id: note.id);
    }
  }
}

const dbName = 'notes.db';
const noteTable = 'notes';
const userTable = 'user';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const createNoteTable = '''
CREATE TABLE IF NOT EXISTS "Notes" (
	"id"	INTEGER NOT NULL UNIQUE,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "User"("id")
);''';
const createUserTable = '''
CREATE TABLE IF NOT EXISTS "User" (
	"id"	INTEGER NOT NULL UNIQUE,
	"email"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("email")
);
''';
