import 'package:flutter/material.dart';

enum TicketStatus {
  pending, // Booked but not yet used
  verified, // Scanned and used
  expired, // Show time passed
  cancelled, // User cancelled
}

class Ticket {
  String? id;
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
      'movieTitle': movieTitle,
      'cinemaHall': cinemaHall,
      'seatNumber': seatNumber,
      'showTime': showTime.toIso8601String(),
      'price': price,
      'qrCode': qrCode,
      'status': status.index,
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map, [String? docId]) {
    int statusIndex = 0;
    if (map['status'] != null) {
      statusIndex = map['status'] is int ? map['status'] : int.tryParse(map['status'].toString()) ?? 0;
    }

    double parsedPrice = 0.0;
    if (map['price'] != null) {
      parsedPrice = (map['price'] is num) ? (map['price'] as num).toDouble() : double.tryParse(map['price'].toString()) ?? 0.0;
    }

    return Ticket(
      id: docId ?? map['id']?.toString(),
      movieTitle: map['movieTitle']?.toString() ?? 'Unknown Movie',
      cinemaHall: map['cinemaHall']?.toString() ?? 'Unknown Cinema',
      seatNumber: map['seatNumber']?.toString() ?? '',
      showTime: DateTime.parse(map['showTime']?.toString() ?? DateTime.now().toIso8601String()),
      price: parsedPrice,
      qrCode: map['qrCode']?.toString() ?? '',
      status: statusIndex < TicketStatus.values.length ? TicketStatus.values[statusIndex] : TicketStatus.pending,
    );
  }

  bool get isExpired => DateTime.now().isAfter(showTime);

  String get statusText {
    switch (status) {
      case TicketStatus.pending: return 'PENDING';
      case TicketStatus.verified: return 'VERIFIED';
      case TicketStatus.expired: return 'EXPIRED';
      case TicketStatus.cancelled: return 'CANCELLED';
    }
  }

  Color get statusColor {
    switch (status) {
      case TicketStatus.pending: return Colors.orange;
      case TicketStatus.verified: return Colors.green;
      case TicketStatus.expired: return Colors.red;
      case TicketStatus.cancelled: return Colors.grey;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case TicketStatus.pending: return Icons.pending;
      case TicketStatus.verified: return Icons.verified;
      case TicketStatus.expired: return Icons.warning;
      case TicketStatus.cancelled: return Icons.cancel;
    }
  }
}
