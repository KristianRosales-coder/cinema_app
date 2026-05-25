import 'package:flutter/material.dart'; // ADD THIS IMPORT

enum TicketStatus {
  pending, // Booked but not yet used
  verified, // Scanned and used
  expired, // Show time passed
  cancelled, // User cancelled
}

class Ticket {
  int? id;
  String movieTitle;
  String cinemaHall;
  String seatNumber;
  DateTime showTime;
  double price;
  String qrCode;
  TicketStatus status;

  Ticket({
    this.id,
    required this.movieTitle,
    required this.cinemaHall,
    required this.seatNumber,
    required this.showTime,
    required this.price,
    required this.qrCode,
    this.status = TicketStatus.pending,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'movieTitle': movieTitle,
      'cinemaHall': cinemaHall,
      'seatNumber': seatNumber,
      'showTime': showTime.toIso8601String(),
      'price': price,
      'qrCode': qrCode,
      'status': status.index,
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'],
      movieTitle: map['movieTitle'],
      cinemaHall: map['cinemaHall'],
      seatNumber: map['seatNumber'],
      showTime: DateTime.parse(map['showTime']),
      price: map['price'],
      qrCode: map['qrCode'],
      status: TicketStatus.values[map['status'] ?? 0],
    );
  }

  bool get isExpired => DateTime.now().isAfter(showTime);

  String get statusText {
    switch (status) {
      case TicketStatus.pending:
        return 'PENDING';
      case TicketStatus.verified:
        return 'VERIFIED';
      case TicketStatus.expired:
        return 'EXPIRED';
      case TicketStatus.cancelled:
        return 'CANCELLED';
    }
  }

  Color get statusColor {
    switch (status) {
      case TicketStatus.pending:
        return Colors.orange;
      case TicketStatus.verified:
        return Colors.green;
      case TicketStatus.expired:
        return Colors.red;
      case TicketStatus.cancelled:
        return Colors.grey;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case TicketStatus.pending:
        return Icons.pending;
      case TicketStatus.verified:
        return Icons.verified;
      case TicketStatus.expired:
        return Icons.warning;
      case TicketStatus.cancelled:
        return Icons.cancel;
    }
  }
}
