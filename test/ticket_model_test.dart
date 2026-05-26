import 'package:flutter_test/flutter_test.dart';
import 'package:cinema_ticketing/models/ticket.dart';

void main() {
  group('Ticket Model Tests', () {
    test('Ticket can be converted to map and back', () {
      final now = DateTime.now();
      final ticket = Ticket(
        id: 1,
        movieTitle: 'Fight Club',
        cinemaHall: 'Hall A',
        seatNumber: 'A5',
        showTime: now,
        price: 320.0,
        qrCode: 'QR123456789',
        status: TicketStatus.pending,
      );

      final ticketMap = ticket.toMap();
      final restoredTicket = Ticket.fromMap(ticketMap);

      expect(restoredTicket.id, ticket.id);
      expect(restoredTicket.movieTitle, ticket.movieTitle);
      expect(restoredTicket.cinemaHall, ticket.cinemaHall);
      expect(restoredTicket.seatNumber, ticket.seatNumber);
      expect(restoredTicket.price, ticket.price);
      expect(restoredTicket.qrCode, ticket.qrCode);
      expect(restoredTicket.status, TicketStatus.pending);
    });

    test('Ticket.isExpired returns true for past showTime', () {
      final pastTime = DateTime.now().subtract(const Duration(hours: 1));
      final ticket = Ticket(
        movieTitle: 'Test',
        cinemaHall: 'Hall A',
        seatNumber: 'A1',
        showTime: pastTime,
        price: 320.0,
        qrCode: 'QR123',
      );

      expect(ticket.isExpired, true);
    });

    test('Ticket.isExpired returns false for future showTime', () {
      final futureTime = DateTime.now().add(const Duration(hours: 2));
      final ticket = Ticket(
        movieTitle: 'Test',
        cinemaHall: 'Hall A',
        seatNumber: 'A1',
        showTime: futureTime,
        price: 320.0,
        qrCode: 'QR123',
      );

      expect(ticket.isExpired, false);
    });

    test('Ticket.statusText returns correct text', () {
      final ticket = Ticket(
        movieTitle: 'Test',
        cinemaHall: 'Hall A',
        seatNumber: 'A1',
        showTime: DateTime.now().add(const Duration(hours: 1)),
        price: 320.0,
        qrCode: 'QR123',
        status: TicketStatus.verified,
      );

      expect(ticket.statusText, 'VERIFIED');
    });

    test('Ticket constructor sets default status to pending', () {
      final ticket = Ticket(
        movieTitle: 'Test',
        cinemaHall: 'Hall A',
        seatNumber: 'A1',
        showTime: DateTime.now(),
        price: 320.0,
        qrCode: 'QR123',
      );

      expect(ticket.status, TicketStatus.pending);
    });
  });
}
