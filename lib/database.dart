
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'personal_info_manager.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE appointments (
            id INTEGER PRIMARY KEY,
            title TEXT,
            description TEXT,
            date TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE contacts (
            id INTEGER PRIMARY KEY,
            name TEXT,
            phone TEXT,
            email TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY,
            title TEXT,
            content TEXT,
            date TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            isCompleted INTEGER
          );
        ''');
      },
    );
  }

  // CRUD operations for Appointments
  Future<int> insertAppointment(Appointment appointment) async {
    final dbClient = await db;
    return await dbClient.insert('appointments', appointment.toMap());
  }

  Future<List<Appointment>> getAppointments() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('appointments');
    return List.generate(maps.length, (i) => Appointment.fromMap(maps[i]));
  }

  Future<int> updateAppointment(Appointment appointment) async {
    final dbClient = await db;
    return await dbClient.update(
      'appointments',
      appointment.toMap(),
      where: 'id = ?',
      whereArgs: [appointment.id],
    );
  }

  Future<int> deleteAppointment(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      'appointments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Similar CRUD operations for Contacts
  Future<int> insertContact(Contact contact) async {
    final dbClient = await db;
    return await dbClient.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('contacts');
    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }

  Future<int> updateContact(Contact contact) async {
    final dbClient = await db;
    return await dbClient.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Similar CRUD operations for Notes
  Future<int> insertNote(Note note) async {
    final dbClient = await db;
    return await dbClient.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('notes');
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  Future<int> updateNote(Note note) async {
    final dbClient = await db;
    return await dbClient.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Similar CRUD operations for Tasks
  Future<int> insertTask(Task task) async {
    final dbClient = await db;
    return await dbClient.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('tasks');
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<int> updateTask(Task task) async {
    final dbClient = await db;
    return await dbClient.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
