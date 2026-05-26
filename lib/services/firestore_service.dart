import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ticket.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Save ticket to user's collection
  Future<String> saveTicket(String userId, Ticket ticket) async {
    try {
      final ticketData = ticket.toMap();
      ticketData['bookingDate'] = FieldValue.serverTimestamp();

      final docRef = await _db
          .collection('users')
          .doc(userId)
          .collection('tickets')
          .add(ticketData);

      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  /// Update ticket status
  Future<void> updateTicketStatus(String userId, String ticketId, TicketStatus status) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('tickets')
        .doc(ticketId)
        .update({'status': status.index});
  }

  /// Stream of user tickets (real-time updates)
  Stream<List<Ticket>> userTicketsStream(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('tickets')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Ticket.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Delete ticket
  Future<void> deleteTicket(String userId, String ticketId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('tickets')
        .doc(ticketId)
        .delete();
  }
}
