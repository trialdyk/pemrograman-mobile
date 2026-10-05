// Test tambahan: menjalankan SQL asli pada SQLite in-memory (sqflite_common_ffi),
// sehingga skema dan query NoteRepository/PostRepository terbukti benar
// tanpa emulator.
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:week5_offline_notes/data/local/note.dart';
import 'package:week5_offline_notes/data/remote/post.dart';
import 'package:week5_offline_notes/data/repositories/note_repository.dart';
import 'package:week5_offline_notes/data/repositories/post_repository.dart';
import 'package:week5_offline_notes/data/sync.dart';

Future<Database> _openMemoryDb() {
  return databaseFactoryFfi.openDatabase(
    inMemoryDatabasePath,
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            body TEXT NOT NULL DEFAULT '',
            updated_at TEXT NOT NULL,
            dirty INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE cached_posts(
            id INTEGER PRIMARY KEY,
            payload TEXT NOT NULL,
            cached_at TEXT NOT NULL
          )
        ''');
      },
    ),
  );
}

void main() {
  sqfliteFfiInit();

  late Database db;
  late NoteRepository repo;

  setUp(() async {
    db = await _openMemoryDb();
    repo = NoteRepository(openDb: () async => db);
  });

  tearDown(() => db.close());

  group('NoteRepository (SQLite in-memory)', () {
    test('addNote menyimpan catatan dengan dirty = true', () async {
      final note = await repo.addNote(title: 'A', body: 'isi');
      expect(note.id, isNotNull);
      expect(await repo.countDirty(), 1);
      final loaded = await repo.getNoteById(note.id!);
      expect(loaded?.title, 'A');
      expect(loaded?.dirty, isTrue);
    });

    test('fetchNotes mengurutkan updated_at terbaru di atas', () async {
      await repo.addNote(title: 'lama');
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await repo.addNote(title: 'baru');
      final notes = await repo.fetchNotes();
      expect(notes.map((n) => n.title), ['baru', 'lama']);
    });

    test('updateNote mengubah isi, memperbarui updated_at, dan dirty', () async {
      final added = await repo.addNote(title: 'A');
      await repo.markAllSynced();
      expect(await repo.countDirty(), 0);

      await Future<void>.delayed(const Duration(milliseconds: 5));
      await repo.updateNote(added.copyWith(title: 'A2'));

      final loaded = await repo.getNoteById(added.id!);
      expect(loaded?.title, 'A2');
      expect(loaded?.dirty, isTrue);
      expect(loaded!.updatedAt.isAfter(added.updatedAt), isTrue);
    });

    test('updateNote tanpa id melempar ArgumentError', () async {
      final noId = Note(title: 'A', updatedAt: DateTime(2026));
      await expectLater(repo.updateNote(noId), throwsArgumentError);
    });

    test('deleteNote menghapus baris', () async {
      final note = await repo.addNote(title: 'A');
      await repo.deleteNote(note.id!);
      expect(await repo.fetchNotes(), isEmpty);
      expect(await repo.getNoteById(note.id!), isNull);
    });

    test('syncNotes pada SQLite asli mengosongkan antrean dirty', () async {
      await repo.addNote(title: 'a');
      await repo.addNote(title: 'b');
      final synced = await syncNotes(repo, latency: Duration.zero);
      expect(synced, 2);
      expect(await repo.countDirty(), 0);
    });
  });

  group('PostRepository cache (SQLite in-memory)', () {
    test('cache kosong awalnya, lalu terbaca setelah disimpan', () async {
      final posts = PostRepository(openDb: () async => db);
      expect(await posts.readCachedPosts(), isEmpty);

      await db.insert('cached_posts', {
        'id': 1,
        'payload': '{"id":1,"title":"t","body":"b"}',
        'cached_at': DateTime(2026).toIso8601String(),
      });
      final cached = await posts.readCachedPosts();
      expect(cached, hasLength(1));
      expect(cached.first, isA<Post>());
      expect(cached.first.title, 't');
    });
  });
}
