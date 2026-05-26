import 'package:flutter_test/flutter_test.dart';
import 'package:cinema_ticketing/providers/ticket_provider.dart';
import 'package:cinema_ticketing/models/ticket.dart';

void main() {
  group('TicketProvider Tests', () {
    test('TicketProvider initializes with empty tickets list', () async {
      final provider = TicketProvider();
      await Future.delayed(const Duration(milliseconds: 200));
      expect(provider.tickets, isEmpty);
    });

    test('addTicket adds ticket to list', () async {
      final provider = TicketProvider();
      await Future.delayed(const Duration(milliseconds: 200));

      final ticket = Ticket(
        movieTitle: 'Fight Club',
        cinemaHall: 'Hall A',
        seatNumber: 'A5',
        showTime: DateTime.now().add(const Duration(hours: 2)),
        price: 320.0,
        qrCode: 'QR123456789',
      );

      await provider.addTicket(ticket);
      await Future.delayed(const Duration(milliseconds: 200));

      expect(provider.tickets.length, 1);
      expect(provider.tickets.first.movieTitle, 'Fight Club');
    });

    test('deleteTicket removes ticket from list', () async {
      final provider = TicketProvider();
      await Future.delayed(const Duration(milliseconds: 200));

      final ticket = Ticket(
        movieTitle: 'Fight Club',
        cinemaHall: 'Hall A',
        seatNumber: 'A5',
        showTime: DateTime.now().add(const Duration(hours: 2)),
        price: 320.0,
        qrCode: 'QR123456789',
      );

      await provider.addTicket(ticket);
      await Future.delayed(const Duration(milliseconds: 200));

      final ticketId = provider.tickets.first.id;
      await provider.deleteTicket(ticketId!);
      await Future.delayed(const Duration(milliseconds: 200));

      expect(provider.tickets, isEmpty);
    });

    test('updateTicketStatus updates ticket status', () async {
      final provider = TicketProvider();
      await Future.delayed(const Duration(milliseconds: 200));

      final ticket = Ticket(
        movieTitle: 'Fight Club',
        cinemaHall: 'Hall A',
        seatNumber: 'A5',
        showTime: DateTime.now().add(const Duration(hours: 2)),
        price: 320.0,
        qrCode: 'QR123456789',
        status: TicketStatus.pending,
      );

      await provider.addTicket(ticket);
      await Future.delayed(const Duration(milliseconds: 200));

      final ticketId = provider.tickets.first.id;
      await provider.updateTicketStatus(ticketId!, TicketStatus.verified);
      await Future.delayed(const Duration(milliseconds: 200));

      expect(provider.tickets.first.status, TicketStatus.verified);
    });

    test('getTakenSeatsForMovie returns occupied seats', () async {
      final provider = TicketProvider();
      await Future.delayed(const Duration(milliseconds: 200));

      final showTime = DateTime.now().add(const Duration(hours: 2));

      final ticket1 = Ticket(
        movieTitle: 'Fight Club',
        cinemaHall: 'Hall A',
        seatNumber: 'A5',
        showTime: showTime,
        price: 320.0,
        qrCode: 'QR1',
        status: TicketStatus.pending,
      );

      final ticket2 = Ticket(
        movieTitle: 'Fight Club',
        cinemaHall: 'Hall A',
        seatNumber: 'A6',
        showTime: showTime,
        price: 320.0,
        qrCode: 'QR2',
        status: TicketStatus.verified,
      );

      await provider.addTicket(ticket1);
      await provider.addTicket(ticket2);
      await Future.delayed(const Duration(milliseconds: 200));

      final takenSeats = provider.getTakenSeatsForMovie('Fight Club');

      expect(takenSeats.contains('A5'), true);
      expect(takenSeats.contains('A6'), true);
      expect(takenSeats.length, 2);
    });

    test('markAsVerified marks ticket as verified', () async {
      final provider = TicketProvider();
      await Future.delayed(const Duration(milliseconds: 200));

      final ticket = Ticket(
        movieTitle: 'Fight Club',
        cinemaHall: 'Hall A',
        seatNumber: 'A5',
        showTime: DateTime.now().add(const Duration(hours: 2)),
        price: 320.0,
        qrCode: 'QR123456789',
      );

      await provider.addTicket(ticket);
      await Future.delayed(const Duration(milliseconds: 200));

      final ticketId = provider.tickets.first.id;
      await provider.markAsVerified(ticketId!);
      await Future.delayed(const Duration(milliseconds: 200));

      expect(provider.tickets.first.status, TicketStatus.verified);
    });
  });
}
