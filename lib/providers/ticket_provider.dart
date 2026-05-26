import 'dart:async';
import 'package:flutter/material.dart';
import '../models/ticket.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TicketProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Ticket> _tickets = [];
  bool _isLoading = false;
  
  StreamSubscription? _authSubscription;
  StreamSubscription? _ticketSubscription;

  List<Ticket> get tickets => _tickets;
  bool get isLoading => _isLoading;

  TicketProvider() {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSubscription?.cancel();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _ticketSubscription?.cancel();
      if (user != null) {
        _ticketSubscription = _firestoreService.userTicketsStream(user.uid).listen(
          (tickets) {
            _tickets = tickets;
            notifyListeners();
          },
        );
      } else {
        _tickets = [];
        notifyListeners();
      }
    });
  }

  Future<void> addTicket(Ticket ticket) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestoreService.saveTicket(user.uid, ticket);
    }
  }

  // FIXED: Reverted to 2 arguments to match your Ticket Screen
  Future<void> updateTicketStatus(String ticketId, TicketStatus newStatus) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestoreService.updateTicketStatus(user.uid, ticketId, newStatus);
    }
  }

  // FIXED: Reverted to 1 argument to match your QR Scanner Screen
  Future<void> markAsVerified(String ticketId) async {
    await updateTicketStatus(ticketId, TicketStatus.verified);
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

  @override
  void dispose() {
    _authSubscription?.cancel();
    _ticketSubscription?.cancel();
    super.dispose();
  }
}
