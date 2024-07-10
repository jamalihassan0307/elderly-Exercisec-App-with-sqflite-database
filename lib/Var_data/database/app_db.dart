import 'package:ex_app/data/model/event.dart';
import 'package:ex_app/data/model/report.dart';
import 'package:ex_app/data/model/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/alarm.dart';

class ExerciseDatabase {
  static final ExerciseDatabase instance = ExerciseDatabase._();
  late Database database;
  ExerciseDatabase._() {
    init();
  }
  init() async {
    database = await _initDB('exercise.db');
    return database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute(
        'CREATE TABLE arlam (_id $idType, isOn $boolType, remindTime $textType, weekID $textType)');
    await db.execute(
        'CREATE TABLE week (_id $idType, week $textType, weekID $textType, setOrder $intType)');
    await db.execute(
        'CREATE TABLE user (_id INTEGER PRIMARY KEY, name $textType, gender $textType, weight $textType, height $textType, bmi $textType, birth $textType)');

    await db.execute(
        'CREATE TABLE report (_id $idType, eventKey $textType, workouts $textType, kcal $textType, duration $textType, time $textType)');
    await db.execute(
        'CREATE TABLE events (_id $idType, eventKey $textType, kcal $textType, duration $textType, title $textType,  time $textType)');
  }

  Future<void> insertArlam(Alarm remind) async {
    final db = database;
    await db.insert('arlam', remind.toMap());
  }

  Future<void> insertRepeat(RepateAlarm alarm) async {
    final db = database;
    await db.insert('week', alarm.toMap());
  }

  Future<void> insertReport(Reports reports) async {
    final db = database;
    await db.insert('report', reports.toMap());
  }

  Future<void> insertEvents(Event event) async {
    final db = database;
    await db.insert('events', event.toMap());
  }

  Future<List<RepateAlarm>> readArlam(String id) async {
    final db = database;

    final result = await db.query(
      'week',
      columns: ['_id', 'week', 'weekID', 'setOrder'],
      where: 'weekID = ?',
      whereArgs: [id],
    );
    return result.map((json) => RepateAlarm.fromJson(json)).toList();
  }

  Future<List<Event>> showEvents(String key) async {
    final db = database;

    final result = await db.query(
      'events',
      columns: ['_id', 'eventKey', 'kcal', 'duration', 'title', 'time'],
      where: 'eventKey = ?',
      whereArgs: [key],
    );
    return result.map((json) => Event.fromJson(json)).toList();
  }

  Future<List<Event>> showBetweenEvents(String strat, String end) async {
    final db = database;

    final result = await db.query(
      'events',
      columns: ['_id', 'eventKey', 'kcal', 'duration', 'title', 'time'],
      where: 'eventKey BETWEEN  ? and ?',
      whereArgs: [strat, end],
    );
    return result.map((json) => Event.fromJson(json)).toList();
  }

//WHERE column_4 BETWEEN 10 AND 20;
  Future<List<Reports>> showHistory(String id) async {
    final db = database;

    final result = await db.query(
      'report',
      columns: ['_id', 'workouts', 'eventKey', 'kcal', 'duration', 'time'],
      where: 'eventKey = ?',
      whereArgs: [id],
    );
    return result.map((json) => Reports.fromJson(json)).toList();
  }

  Future<void> updateWeekAlarm(RepateAlarm value) async {
    final db = database;
    await db.update(
      'week',

      {'week': value},
      // user.toMap(),
      where: 'weekID = ?',
      whereArgs: [value.weekID],
    );
  }

  Future<User> user() async {
    final db = database;

    final maps = await db.query(
      'user',
      columns: ['_id', 'name', 'gender', 'weight', 'height', 'bmi', 'birth'],
      where: '_id = 1',
    );
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      const user = User(
          id: 1,
          name: '',
          height: '',
          weight: '',
          gender: '',
          bmi: '0.0',
          birth: '');
      await db.insert('user', user.toMap());
      return user;
      // throw Exception('ID 0 not found');
    }
  }

  Future<void> updateUser(String column, String value) async {
    final db = database;
    await db.update(
      'user',
      {column: value},
      // user.toMap(),
      where: '_id = 1',
    );
  }

  Future<void> resetUser() async {
    final db = database;
    await db.update(
      'user',
      {
        '_id': 1,
        'name': '',
        'height': '',
        'weight': '',
        'gender': '',
        'bmi': '0.0',
        'birth': ''
      },
      // user.toMap(),
      where: '_id = 1',
    );
  }

  Future<List<Alarm>> showAll() async {
    final db = database;
    const orderBy = 'remindTime ASC';
    final result = await db.query('arlam', orderBy: orderBy);
    return result.map((json) => Alarm.fromJson(json)).toList();
  }

  Future<List<Reports>> showReports() async {
    final db = database;
    final result = await db.query('report');
    return result.map((json) => Reports.fromJson(json)).toList();
  }

  Future<void> update(Alarm alarm) async {
    final db = database;
    await db.update(
      'arlam',
      alarm.toMap(),
      where: '_id = ?',
      whereArgs: [alarm.id],
    );
  }

  Future<int> delete(int id) async {
    final db = database;
    return await db.delete(
      'arlam',
      where: '_id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteUserData() async {
    final db = database;
    return await db.delete('user');
  }

  Future<void> restAllData() async {
    final db = database;
    await db.delete('week');
    await db.delete('events');
    await db.delete('report');
    await db.delete('arlam');
    // await db.delete('user');
  }

  Future close() async {
    final db = database;
    db.close();
  }

  Future<int> deleteRepeat(String id) async {
    final db = database;
    return await db.delete(
      'week',
      where: 'weekID = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteEvents(int id) async {
    final db = database;
    return await db.delete(
      'events',
      where: '_id = ?',
      whereArgs: [id],
    );
  }
}
