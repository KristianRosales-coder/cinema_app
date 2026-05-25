import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/ticket.dart';

class TicketProvider extends ChangeNotifier {
  List<Ticket> _tickets = [];
  Database? _database;

  List<Ticket> get tickets => _tickets;

  TicketProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'tickets_database.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE tickets('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'movieTitle TEXT, '
            'cinemaHall TEXT, '
            'seatNumber TEXT, '
            'showTime TEXT, '
            'price REAL, '
            'qrCode TEXT, '
            'status INTEGER DEFAULT 0)');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          try {
            await db.execute(
                'ALTER TABLE tickets ADD COLUMN status INTEGER DEFAULT 0');
          } catch (e) {
            // Column might already exist, silently ignore
          }
        }
      },
      version: 3,
    );
    await _loadTickets();
  }

  Future<void> _loadTickets() async {
    final List<Map<String, dynamic>> maps = await _database!.query('tickets');
    _tickets = maps.map((map) => Ticket.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addTicket(Ticket ticket) async {
    await _database!.insert('tickets', ticket.toMap());
    await _loadTickets();
  }

  Future<void> deleteTicket(int id) async {
    await _database!.delete('tickets', where: 'id = ?', whereArgs: [id]);
    await _loadTickets();
  }

  Future<void> updateTicketStatus(int id, TicketStatus newStatus) async {
    await _database!.update(
      'tickets',
      {'status': newStatus.index},
      where: 'id = ?',
      whereArgs: [id],
    );
    await _loadTickets();
  }

  Future<void> markAsVerified(int id) async {
    await updateTicketStatus(id, TicketStatus.verified);
  }

  List<String> getTakenSeatsForMovie(String movieTitle) {
    final now = DateTime.now();
    return _tickets
        .where((t) =>
            t.movieTitle == movieTitle &&
            t.status != TicketStatus.cancelled &&
            t.showTime.isAfter(now))
        .map((t) => t.seatNumber)
        .toList();
  }
}
