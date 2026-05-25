import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../providers/ticket_provider.dart';
import '../models/ticket.dart';
import '../utils/constants.dart';
import 'package:intl/intl.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(
        title: const Text('My Tickets'),
        backgroundColor: AppColors.primaryRed,
      ),
      body: Consumer<TicketProvider>(
        builder: (context, ticketProvider, child) {
          if (ticketProvider.tickets.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.confirmation_num_outlined,
                    size: 80,
                    color: AppColors.textGrey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No tickets yet',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ticketProvider.tickets.length,
            itemBuilder: (context, index) {
              final ticket = ticketProvider.tickets[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.cardBlack,
                  borderRadius: BorderRadius.circular(16),
                  border: ticket.status == TicketStatus.verified
                      ? Border.all(color: Colors.green, width: 2)
                      : ticket.status == TicketStatus.cancelled
                          ? Border.all(color: Colors.grey, width: 2)
                          : null,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ticket.status == TicketStatus.verified
                            ? Colors.green
                            : ticket.status == TicketStatus.cancelled
                                ? Colors.grey
                                : AppColors.primaryRed,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'MR.R CINEMA',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  ticket.statusIcon,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  ticket.statusText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ticket.movieTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: AppColors.primaryRed),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  ticket.cinemaHall,
                                  style: const TextStyle(
                                      color: AppColors.textGrey),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.event_seat,
                                  size: 16, color: AppColors.primaryRed),
                              const SizedBox(width: 8),
                              Text(
                                'Seat: ${ticket.seatNumber}',
                                style:
                                    const TextStyle(color: AppColors.textGrey),
                              ),
                              const SizedBox(width: 20),
                              const Icon(Icons.access_time,
                                  size: 16, color: AppColors.primaryRed),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('MMM dd, h:mm a')
                                    .format(ticket.showTime),
                                style:
                                    const TextStyle(color: AppColors.textGrey),
                              ),
                            ],
                          ),
                          const Divider(color: AppColors.textGrey, height: 32),
                          if (ticket.status == TicketStatus.pending)
                            Center(
                              child: QrImageView(
                                data: ticket.qrCode,
                                version: QrVersions.auto,
                                size: 120.0,
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.all(8),
                              ),
                            )
                          else if (ticket.status == TicketStatus.verified)
                            const Center(
                              child: Column(
                                children: [
                                  Icon(Icons.check_circle,
                                      size: 60, color: Colors.green),
                                  SizedBox(height: 8),
                                  Text(
                                    'Ticket Used',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            )
                          else if (ticket.status == TicketStatus.cancelled)
                            const Center(
                              child: Column(
                                children: [
                                  Icon(Icons.cancel,
                                      size: 60, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text(
                                    'Ticket Cancelled',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 16),
                          if (ticket.status == TicketStatus.pending)
                            Center(
                              child: Text(
                                ticket.qrCode,
                                style: const TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Price',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                '₱${ticket.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppColors.primaryRed,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Container(
                              width: 200,
                              height: 2,
                              color: AppColors.textGrey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (ticket.status == TicketStatus.pending)
                            Center(
                              child: IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: AppColors.primaryRed),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (dialogContext) => AlertDialog(
                                      backgroundColor: AppColors.cardBlack,
                                      title: const Text('Cancel Ticket',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      content: const Text(
                                          'Are you sure you want to cancel this ticket?',
                                          style: TextStyle(
                                              color: AppColors.textGrey)),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(dialogContext),
                                          child: const Text('No',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(dialogContext);
                                            await ticketProvider
                                                .updateTicketStatus(ticket.id!,
                                                    TicketStatus.cancelled);
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Ticket cancelled successfully')),
                                              );
                                            }
                                          },
                                          child: const Text('Yes',
                                              style: TextStyle(
                                                  color: AppColors.primaryRed)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          if (ticket.status == TicketStatus.verified)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  '✓ Ticket already used',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          if (ticket.status == TicketStatus.cancelled)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  '✗ Ticket cancelled',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
