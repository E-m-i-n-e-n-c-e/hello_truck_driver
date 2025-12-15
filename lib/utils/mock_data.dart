import 'package:hello_truck_driver/models/enums/transaction_enums.dart';
import 'package:hello_truck_driver/models/wallet_log.dart';
import 'package:hello_truck_driver/models/transaction_log.dart';
import 'package:hello_truck_driver/models/ride_summary.dart';
import 'package:hello_truck_driver/models/booking_assignment.dart';
import 'package:hello_truck_driver/models/booking.dart';
import 'package:hello_truck_driver/models/enums/booking_enums.dart';
import 'package:hello_truck_driver/models/enums/package_enums.dart';

/// Mock data for testing dashboard UI
class MockData {
  /// Mock wallet logs
  static List<WalletLog> getMockWalletLogs() {
    final now = DateTime.now();

    return [
      WalletLog(
        id: '1',
        beforeBalance: 1500.0,
        afterBalance: 1850.0,
        amount: 350.0,
        reason: 'Ride earnings - Booking #1234',
        bookingId: 'booking_1234',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      WalletLog(
        id: '2',
        beforeBalance: 1850.0,
        afterBalance: 1650.0,
        amount: -200.0,
        reason: 'Payout to bank account',
        bookingId: null,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      WalletLog(
        id: '3',
        beforeBalance: 1650.0,
        afterBalance: 2100.0,
        amount: 450.0,
        reason: 'Ride earnings - Booking #1235',
        bookingId: 'booking_1235',
        createdAt: now.subtract(const Duration(hours: 8)),
      ),
    ];
  }

  /// Mock transaction logs
  static List<TransactionLog> getMockTransactionLogs() {
    final now = DateTime.now();

    return [
      TransactionLog(
        id: '1',
        customerId: 'cust_123',
        driverId: 'driver_456',
        amount: 350.0,
        type: TransactionType.credit,
        category: TransactionCategory.bookingPayment,
        description: 'Payment received for delivery to MG Road',
        bookingId: 'booking_1234',
        booking: null,
        payoutId: null,
        payout: null,
        paymentMethod: PaymentMethod.online,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      TransactionLog(
        id: '2',
        customerId: null,
        driverId: 'driver_456',
        amount: 200.0,
        type: TransactionType.debit,
        category: TransactionCategory.driverPayout,
        description: 'Payout to HDFC Bank ****1234',
        bookingId: null,
        booking: null,
        payoutId: 'payout_789',
        payout: null,
        paymentMethod: PaymentMethod.online,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
    ];
  }

  /// Create a mock invoice
  static Invoice _createMockInvoice({
    required String id,
    required String bookingId,
    required String type,
    required double totalPrice,
    required double finalAmount,
    required double distanceKm,
  }) {
    return Invoice(
      id: id,
      bookingId: bookingId,
      type: type,
      vehicleModelName: 'Tata Ace',
      basePrice: 100.0,
      perKmPrice: 15.0,
      baseKm: 5.0,
      distanceKm: distanceKm,
      weightInTons: 0.5,
      effectiveBasePrice: 100.0,
      totalPrice: totalPrice,
      walletApplied: 0.0,
      finalAmount: finalAmount,
      paymentLinkUrl: '',
      rzpOrderId: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Create a mock booking
  static Booking _createMockBooking({
    required String id,
    required int bookingNumber,
    required String productName,
    required ProductType productType,
    required BookingStatus status,
    required double totalPrice,
    required double finalAmount,
    required double distanceKm,
    required DateTime createdAt,
    DateTime? completedAt,
  }) {
    return Booking(
      id: id,
      bookingNumber: bookingNumber,
      package: Package(
        id: 'pkg_$id',
        productType: productType,
        approximateWeight: 500,
        weightUnit: WeightUnit.kg,
        productName: productName,
      ),
      pickupAddress: BookingAddress(
        addressName: 'Pickup Location',
        contactName: 'Sender Name',
        contactPhone: '+919876543210',
        formattedAddress: '123, MG Road, Koramangala, Bangalore 560034',
        latitude: 12.9352,
        longitude: 77.6245,
      ),
      dropAddress: BookingAddress(
        addressName: 'Drop Location',
        contactName: 'Receiver Name',
        contactPhone: '+919876543211',
        formattedAddress: '456, HSR Layout, Sector 2, Bangalore 560102',
        latitude: 12.9141,
        longitude: 77.6411,
      ),
      invoices: [
        _createMockInvoice(
          id: 'inv_$id',
          bookingId: id,
          type: 'FINAL',
          totalPrice: totalPrice,
          finalAmount: finalAmount,
          distanceKm: distanceKm,
        ),
      ],
      status: status,
      createdAt: createdAt,
      updatedAt: createdAt,
      completedAt: completedAt,
    );
  }

  /// Mock ride summary with today's completed rides
  static RideSummary getMockRideSummary() {
    final now = DateTime.now();
    final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // Create mock completed assignments for today
    final todayAssignments = [
      BookingAssignment(
        id: 'assignment_1',
        driverId: 'driver_456',
        bookingId: 'booking_1001',
        status: AssignmentStatus.accepted,
        offeredAt: now.subtract(const Duration(hours: 4)),
        respondedAt: now.subtract(const Duration(hours: 4)),
        booking: _createMockBooking(
          id: 'booking_1001',
          bookingNumber: 10040,
          productName: 'Vegetables',
          productType: ProductType.agricultural,
          status: BookingStatus.completed,
          totalPrice: 650.0,
          finalAmount: 650.0,
          distanceKm: 18.2,
          createdAt: now.subtract(const Duration(hours: 5)),
          completedAt: now.subtract(const Duration(hours: 3)),
        ),
      ),
      BookingAssignment(
        id: 'assignment_2',
        driverId: 'driver_456',
        bookingId: 'booking_1002',
        status: AssignmentStatus.accepted,
        offeredAt: now.subtract(const Duration(hours: 2)),
        respondedAt: now.subtract(const Duration(hours: 2)),
        booking: _createMockBooking(
          id: 'booking_1002',
          bookingNumber: 10041,
          productName: 'Electronics',
          productType: ProductType.nonAgricultural,
          status: BookingStatus.completed,
          totalPrice: 450.0,
          finalAmount: 450.0,
          distanceKm: 8.5,
          createdAt: now.subtract(const Duration(hours: 3)),
          completedAt: now.subtract(const Duration(hours: 1)),
        ),
      ),
    ];

    // Calculate net earnings after 7% commission
    double totalGross = 0;
    for (var assignment in todayAssignments) {
      totalGross += assignment.booking.finalCost ?? 0;
    }
    final netEarnings = totalGross * (1 - 0.07);

    return RideSummary(
      totalRides: todayAssignments.length,
      netEarnings: netEarnings,
      commissionRate: 0.07,
      date: dateStr,
      assignments: todayAssignments,
    );
  }

  /// Mock current assignment (active ride)
  static BookingAssignment? getMockCurrentAssignment() {
    final now = DateTime.now();

    return BookingAssignment(
      id: 'assignment_active_1',
      driverId: 'driver_456',
      bookingId: 'booking_active_1',
      status: AssignmentStatus.accepted,
      offeredAt: now.subtract(const Duration(minutes: 30)),
      respondedAt: now.subtract(const Duration(minutes: 28)),
      booking: _createMockBooking(
        id: 'booking_active_1',
        bookingNumber: 10045,
        productName: 'Rice Bags',
        productType: ProductType.agricultural,
        status: BookingStatus.dropVerified,
        totalPrice: 850.0,
        finalAmount: 850.0,
        distanceKm: 12.5,
        createdAt: now.subtract(const Duration(minutes: 35)),
      ),
    );
  }

  /// Mock assignment history
  static List<BookingAssignment> getMockAssignmentHistory() {
    final now = DateTime.now();

    return [
      BookingAssignment(
        id: 'assignment_hist_1',
        driverId: 'driver_456',
        bookingId: 'booking_1001',
        status: AssignmentStatus.accepted,
        offeredAt: now.subtract(const Duration(days: 1, hours: 2)),
        respondedAt: now.subtract(const Duration(days: 1, hours: 2)),
        booking: _createMockBooking(
          id: 'booking_1001',
          bookingNumber: 10040,
          productName: 'Vegetables',
          productType: ProductType.agricultural,
          status: BookingStatus.completed,
          totalPrice: 680.0,
          finalAmount: 680.0,
          distanceKm: 18.2,
          createdAt: now.subtract(const Duration(days: 1, hours: 3)),
          completedAt: now.subtract(const Duration(days: 1, hours: 1)),
        ),
      ),
      BookingAssignment(
        id: 'assignment_hist_2',
        driverId: 'driver_456',
        bookingId: 'booking_1002',
        status: AssignmentStatus.accepted,
        offeredAt: now.subtract(const Duration(days: 2, hours: 5)),
        respondedAt: now.subtract(const Duration(days: 2, hours: 5)),
        booking: _createMockBooking(
          id: 'booking_1002',
          bookingNumber: 10035,
          productName: 'Electronics - TV',
          productType: ProductType.nonAgricultural,
          status: BookingStatus.completed,
          totalPrice: 450.0,
          finalAmount: 450.0,
          distanceKm: 8.5,
          createdAt: now.subtract(const Duration(days: 2, hours: 6)),
          completedAt: now.subtract(const Duration(days: 2, hours: 4)),
        ),
      ),
    ];
  }
}
