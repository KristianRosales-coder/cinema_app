import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/ticket_provider.dart';
import '../models/ticket.dart';
import '../utils/constants.dart';

class BookingScreen extends StatefulWidget {
  final dynamic movie;

  const BookingScreen({super.key, required this.movie});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String selectedCinema = 'SM Cinema - Mall of Asia';
  String selectedTime = '7:00 PM';
  String selectedDate = '';
  double ticketPrice = 320.00;

  late List<List<SeatStatus>> seats;
  bool _isLoading = true;

  final List<String> cinemas = const [
    'SM Cinema - Mall of Asia',
    'SM Cinema - Megamall',
    'Ayala Malls Cinemas',
    'Robinsons Movieworld',
  ];

  final List<String> times = const ['3:00 PM', '5:00 PM', '7:00 PM', '9:00 PM'];

  late List<String> dates;

  @override
  void initState() {
    super.initState();
    _generateDates();
    selectedDate = dates[0];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSeats();
    });
  }

  void _generateDates() {
    dates = [];
    for (int i = 0; i < 7; i++) {
      final date = DateTime.now().add(Duration(days: i));
      dates.add(DateFormat('yyyy-MM-dd').format(date));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeSeats();
  }

  Future<void> _initializeSeats() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final ticketProvider =
          Provider.of<TicketProvider>(context, listen: false);

      // IMPORTANT: Filter tickets for this movie AND specific date AND specific time
      final movieTickets = ticketProvider.tickets
          .where((t) =>
              t.movieTitle == widget.movie.title &&
              t.status != TicketStatus.cancelled &&
              DateFormat('yyyy-MM-dd').format(t.showTime) == selectedDate &&
              _convertTo12HourFormat(t.showTime) == selectedTime &&
              t.cinemaHall == selectedCinema)
          .toList();

      final newSeats = List.generate(10, (rowIndex) {
        return List.generate(10, (seatIndex) {
          final seatNumber =
              '${String.fromCharCode(65 + rowIndex)}${seatIndex + 1}';

          Ticket? ticket;
          try {
            ticket = movieTickets.firstWhere(
              (t) => t.seatNumber == seatNumber,
            );
          } catch (e) {
            ticket = null;
          }

          if (ticket != null) {
            if (ticket.status == TicketStatus.verified) {
              return SeatStatus(
                isAvailable: false,
                isSelected: false,
                seatNumber: seatNumber,
                status: 'verified',
              );
            } else if (ticket.status == TicketStatus.pending) {
              return SeatStatus(
                isAvailable: false,
                isSelected: false,
                seatNumber: seatNumber,
                status: 'pending',
              );
            } else {
              return SeatStatus(
                isAvailable: true,
                isSelected: false,
                seatNumber: seatNumber,
                status: 'available',
              );
            }
          } else {
            return SeatStatus(
              isAvailable: true,
              isSelected: false,
              seatNumber: seatNumber,
              status: 'available',
            );
          }
        });
      });

      setState(() {
        seats = newSeats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _convertTo12HourFormat(DateTime time) {
    int hour = time.hour;
    String minute = time.minute.toString().padLeft(2, '0');
    String period = hour >= 12 ? 'PM' : 'AM';
    int hour12 = hour % 12;
    if (hour12 == 0) hour12 = 12;
    return '$hour12:$minute $period';
  }

  void _toggleSeatSelection(int row, int seat) {
    setState(() {
      if (seats[row][seat].isAvailable && !seats[row][seat].isSelected) {
        seats[row][seat].isSelected = true;
      } else if (seats[row][seat].isSelected) {
        seats[row][seat].isSelected = false;
      }
    });
  }

  int _getSelectedSeatsCount() {
    if (_isLoading) return 0;
    int count = 0;
    for (var row in seats) {
      for (var seat in row) {
        if (seat.isSelected) {
          count++;
        }
      }
    }
    return count;
  }

  List<String> _getSelectedSeats() {
    if (_isLoading) return [];
    List<String> selected = [];
    for (var row in seats) {
      for (var seat in row) {
        if (seat.isSelected) {
          selected.add(seat.seatNumber);
        }
      }
    }
    return selected;
  }

  double _getTotalPrice() {
    return _getSelectedSeatsCount() * ticketPrice;
  }

  String _convertTo24HourFormat(String time12hr) {
    final isPM = time12hr.contains('PM');
    String hourStr = time12hr.split(':')[0];
    int hour = int.parse(hourStr);

    if (isPM && hour != 12) {
      hour += 12;
    } else if (!isPM && hour == 12) {
      hour = 0;
    }

    final minute = time12hr.split(':')[1].split(' ')[0];
    return '${hour.toString().padLeft(2, '0')}:$minute:00';
  }

  void _confirmBooking() async {
    final selectedSeats = _getSelectedSeats();

    if (selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one seat')),
      );
      return;
    }

    try {
      final ticketProvider =
          Provider.of<TicketProvider>(context, listen: false);

      String time24hr = _convertTo24HourFormat(selectedTime);
      String dateTimeString = '$selectedDate $time24hr';
      DateTime showTime = DateTime.parse(dateTimeString);

      for (String seat in selectedSeats) {
        final ticket = Ticket(
          movieTitle: widget.movie.title,
          cinemaHall: selectedCinema,
          seatNumber: seat,
          showTime: showTime,
          price: ticketPrice,
          qrCode: 'TIX${DateTime.now().millisecondsSinceEpoch}$seat',
          status: TicketStatus.pending,
        );
        await ticketProvider.addTicket(ticket);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${selectedSeats.length} ticket(s) booked successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        _initializeSeats();

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed: $e')),
        );
      }
    }
  }

  Color _getSeatColor(SeatStatus seat) {
    if (seat.isSelected) {
      return Colors.blue;
    } else if (!seat.isAvailable) {
      if (seat.status == 'verified') {
        return Colors.green;
      } else if (seat.status == 'pending') {
        return Colors.amber;
      }
    }
    return Colors.red;
  }

  String _getSeatTooltip(SeatStatus seat) {
    if (!seat.isAvailable) {
      if (seat.status == 'verified') {
        return 'Already Used';
      } else if (seat.status == 'pending') {
        return 'Already Booked (Pending)';
      }
    }
    return 'Available';
  }

  String _formatDisplayDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return DateFormat('MMM dd, yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = _getSelectedSeatsCount();
    final totalPrice = _getTotalPrice();

    final screenWidth = MediaQuery.of(context).size.width;
    final double seatSize =
        screenWidth > 450 ? 30 : (screenWidth > 380 ? 26 : 24);
    final double seatMargin = screenWidth > 450 ? 2.0 : 1.5;
    final double fontSize = screenWidth > 450 ? 10 : 9;

    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(
        title: Text('Book Tickets - ${widget.movie.title}'),
        backgroundColor: AppColors.primaryRed,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBlack,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            widget.movie.imageAsset,
                            width: 60,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 80,
                                color: Colors.grey[800],
                                child: const Icon(Icons.movie,
                                    color: AppColors.primaryRed),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.movie.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.movie.genre,
                                style: const TextStyle(
                                    color: AppColors.textGrey, fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.movie.duration,
                                style: const TextStyle(
                                    color: AppColors.textGrey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Select Cinema
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.local_movies,
                                color: AppColors.primaryRed, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Select Cinema',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.cardBlack,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCinema,
                              dropdownColor: AppColors.cardBlack,
                              style: const TextStyle(color: Colors.white),
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: AppColors.primaryRed),
                              items: cinemas.map((cinema) {
                                return DropdownMenuItem(
                                    value: cinema, child: Text(cinema));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCinema = value!;
                                  _initializeSeats();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Select Date
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.calendar_today,
                                color: AppColors.primaryRed, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Select Date',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: dates.length,
                            itemBuilder: (context, index) {
                              final date = dates[index];
                              final displayDate = _formatDisplayDate(date);
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: FilterChip(
                                  label: Text(displayDate),
                                  selected: selectedDate == date,
                                  selectedColor: AppColors.primaryRed,
                                  backgroundColor: AppColors.cardBlack,
                                  labelStyle: TextStyle(
                                    color: selectedDate == date
                                        ? Colors.white
                                        : AppColors.textGrey,
                                  ),
                                  onSelected: (selected) {
                                    setState(() {
                                      selectedDate = date;
                                      _initializeSeats();
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Select Time
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.access_time,
                                color: AppColors.primaryRed, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Select Time',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          children: times.map((time) {
                            return FilterChip(
                              label: Text(time),
                              selected: selectedTime == time,
                              selectedColor: AppColors.primaryRed,
                              backgroundColor: AppColors.cardBlack,
                              labelStyle: TextStyle(
                                color: selectedTime == time
                                    ? Colors.white
                                    : AppColors.textGrey,
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  selectedTime = time;
                                  _initializeSeats();
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // SELECT SEAT Header
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.event_seat,
                            color: AppColors.primaryRed, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'SELECT SEAT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Seat Legend
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text('Available',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text('Selected',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text('Pending',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text('Verified',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Screen
                  Center(
                    child: Container(
                      width: 250,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text('SCREEN',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 10)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Seat Grid
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 35),
                              ...List.generate(
                                  10,
                                  (index) => SizedBox(
                                        width: seatSize + (seatMargin * 2),
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                              color: AppColors.textGrey,
                                              fontSize: fontSize - 1),
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                            ],
                          ),
                          ...List.generate(10, (rowIndex) {
                            final rowLetter =
                                String.fromCharCode(65 + rowIndex);
                            return Row(
                              children: [
                                SizedBox(
                                  width: 35,
                                  child: Text(
                                    rowLetter,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ...List.generate(10, (seatIndex) {
                                  final seat = seats[rowIndex][seatIndex];
                                  final seatColor = _getSeatColor(seat);
                                  final tooltip = _getSeatTooltip(seat);

                                  return Tooltip(
                                    message: tooltip,
                                    child: GestureDetector(
                                      onTap: seat.isAvailable
                                          ? () => _toggleSeatSelection(
                                              rowIndex, seatIndex)
                                          : null,
                                      child: Container(
                                        width: seatSize,
                                        height: seatSize,
                                        margin: EdgeInsets.all(seatMargin),
                                        decoration: BoxDecoration(
                                          color: seatColor,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color: seat.isSelected
                                                ? Colors.lightBlueAccent
                                                : (seat.isAvailable
                                                    ? Colors.red.shade700
                                                    : seatColor),
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            seat.seatNumber.substring(1),
                                            style: TextStyle(
                                              color: seat.isSelected ||
                                                      seat.isAvailable
                                                  ? Colors.white
                                                  : Colors.white70,
                                              fontSize: fontSize,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Summary and Booking Button
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBlack,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Selected Seats:',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                            Text(_getSelectedSeats().join(', '),
                                style: const TextStyle(
                                    color: AppColors.primaryRed, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Quantity:',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                            Text('$selectedCount',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Price per ticket:',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                            Text('₱${ticketPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ],
                        ),
                        const Divider(color: AppColors.textGrey, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total:',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            Text('₱${totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    color: AppColors.primaryRed,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                selectedCount > 0 ? _confirmBooking : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('CONFIRM BOOKING',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class SeatStatus {
  bool isAvailable;
  bool isSelected;
  String seatNumber;
  String status;

  SeatStatus({
    required this.isAvailable,
    required this.isSelected,
    required this.seatNumber,
    this.status = 'available',
  });
}
