import 'package:hello_truck_driver/models/enums/transaction_enums.dart';
import 'package:hello_truck_driver/models/wallet_log.dart';
import 'package:hello_truck_driver/models/transaction_log.dart';
import 'package:hello_truck_driver/models/ride_summary.dart';
import 'package:hello_truck_driver/models/booking_assignment.dart';
import 'package:hello_truck_driver/models/booking.dart';
import 'package:hello_truck_driver/models/package.dart';
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
      WalletLog(
        id: '4',
        beforeBalance: 2100.0,
        afterBalance: 2400.0,
        amount: 300.0,
        reason: 'Ride earnings - Booking #1236',
        bookingId: 'booking_1236',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      WalletLog(
        id: '5',
        beforeBalance: 2400.0,
        afterBalance: 1900.0,
        amount: -500.0,
        reason: 'Payout to bank account',
        bookingId: null,
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
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
      TransactionLog(
        id: '3',
        customerId: 'cust_124',
        driverId: 'driver_456',
        amount: 450.0,
        type: TransactionType.credit,
        category: TransactionCategory.bookingPayment,
        description: 'Payment received for delivery to Koramangala',
        bookingId: 'booking_1235',
        booking: null,
        payoutId: null,
        payout: null,
        paymentMethod: PaymentMethod.cash,
        createdAt: now.subtract(const Duration(hours: 8)),
      ),
      TransactionLog(
        id: '4',
        customerId: 'cust_125',
        driverId: 'driver_456',
        amount: 300.0,
        type: TransactionType.credit,
        category: TransactionCategory.bookingPayment,
        description: 'Payment received for delivery to Whitefield',
        bookingId: 'booking_1236',
        booking: null,
        payoutId: null,
        payout: null,
        paymentMethod: PaymentMethod.online,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      TransactionLog(
        id: '5',
        customerId: null,
        driverId: 'driver_456',
        amount: 500.0,
        type: TransactionType.debit,
        category: TransactionCategory.driverPayout,
        description: 'Payout to HDFC Bank ****1234',
        bookingId: null,
        booking: null,
        payoutId: 'payout_790',
        payout: null,
        paymentMethod: PaymentMethod.online,
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
      ),
      TransactionLog(
        id: '6',
        customerId: 'cust_126',
        driverId: 'driver_456',
        amount: 275.0,
        type: TransactionType.credit,
        category: TransactionCategory.bookingPayment,
        description: 'Payment received for delivery to Indiranagar',
        bookingId: 'booking_1237',
        booking: null,
        payoutId: null,
        payout: null,
        paymentMethod: PaymentMethod.wallet,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      TransactionLog(
        id: '7',
        customerId: 'cust_127',
        driverId: 'driver_456',
        amount: 400.0,
        type: TransactionType.credit,
        category: TransactionCategory.bookingPayment,
        description: 'Payment received for delivery to HSR Layout',
        bookingId: 'booking_1238',
        booking: null,
        payoutId: null,
        payout: null,
        paymentMethod: PaymentMethod.online,
        createdAt: now.subtract(const Duration(days: 2, hours: 5)),
      ),
    ];
  }

  /// Mock ride summary
  static RideSummary getMockRideSummary() {
    final now = DateTime.now();
    final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    return RideSummary(
      totalRides: 5,
      totalEarnings: 1775.0,
      date: dateStr,
    );
  }

  /// Mock current assignment (active ride)
  static BookingAssignment? getMockCurrentAssignment() {
    final now = DateTime.now();

    // Return null to test empty state, or return an active assignment
    // Comment/uncomment based on what you want to test
    return BookingAssignment(
      id: 'assignment_active_1',
      driverId: 'driver_456',
      bookingId: 'booking_active_1',
      status: AssignmentStatus.accepted,
      offeredAt: now.subtract(const Duration(minutes: 30)),
      respondedAt: now.subtract(const Duration(minutes: 28)),
      booking: Booking(
        id: 'booking_active_1',
        bookingNumber: 10045,
        package: Package.agricultural(
          packageType: PackageType.personal,
          productName: 'Rice Bags',
          approximateWeight: 500,
          weightUnit: WeightUnit.kg,
        ),
        pickupAddress: BookingAddress(
          addressName: 'Fresh Farm Market',
          contactName: 'Ramesh Kumar',
          contactPhone: '+919876543210',
          noteToDriver: 'Call before arriving',
          formattedAddress: '123, MG Road, Koramangala, Bangalore 560034',
          latitude: 12.9352,
          longitude: 77.6245,
        ),
        dropAddress: BookingAddress(
          addressName: 'Green Grocers',
          contactName: 'Suresh Sharma',
          contactPhone: '+919876543211',
          formattedAddress: '456, HSR Layout, Sector 2, Bangalore 560102',
          latitude: 12.9141,
          longitude: 77.6411,
        ),
        estimatedCost: 850.0,
        finalCost: null,
        distanceKm: 12.5,
        baseFare: 100.0,
        distanceCharge: 15.0,
        weightMultiplier: 1.2,
        vehicleMultiplier: 1.0,
        suggestedVehicleType: VehicleType.fourWheeler,
        status: BookingStatus.dropVerified,
        createdAt: now.subtract(const Duration(minutes: 35)),
        updatedAt: now.subtract(const Duration(minutes: 28)),
      ),
    );
  }

  /// Mock assignment history
  static List<BookingAssignment> getMockAssignmentHistory() {
    final now = DateTime.now();

    return [
      BookingAssignment(
        id: 'assignment_1',
        driverId: 'driver_456',
        bookingId: 'booking_1001',
        status: AssignmentStatus.accepted,
        offeredAt: now.subtract(const Duration(days: 1, hours: 2)),
        respondedAt: now.subtract(const Duration(days: 1, hours: 2)),
        booking: Booking(
          id: 'booking_1001',
          bookingNumber: 10040,
          package: Package.agricultural(
            packageType: PackageType.personal,
            productName: 'Vegetables',
            approximateWeight: 200,
            weightUnit: WeightUnit.kg,
          ),
          pickupAddress: BookingAddress(
            addressName: 'City Market',
            contactName: 'Anjali Patel',
            contactPhone: '+919876543212',
            formattedAddress: '78, Indiranagar, 100 Feet Road, Bangalore',
            latitude: 12.9716,
            longitude: 77.6411,
          ),
          dropAddress: BookingAddress(
            addressName: 'Home',
            contactName: 'Vikram Singh',
            contactPhone: '+919876543213',
            formattedAddress: '234, Whitefield Main Road, Bangalore',
            latitude: 12.9698,
            longitude: 77.7499,
          ),
          estimatedCost: 650.0,
          finalCost: 680.0,
          distanceKm: 18.2,
          baseFare: 100.0,
          distanceCharge: 15.0,
          weightMultiplier: 1.0,
          vehicleMultiplier: 1.0,
          suggestedVehicleType: VehicleType.fourWheeler,
          status: BookingStatus.completed,
          completedAt: now.subtract(const Duration(days: 1, hours: 1)),
          createdAt: now.subtract(const Duration(days: 1, hours: 3)),
          updatedAt: now.subtract(const Duration(days: 1, hours: 1)),
        ),
      ),
      BookingAssignment(
        id: 'assignment_2',
        driverId: 'driver_456',
        bookingId: 'booking_1002',
        status: AssignmentStatus.accepted,
        offeredAt: now.subtract(const Duration(days: 2, hours: 5)),
        respondedAt: now.subtract(const Duration(days: 2, hours: 5)),
        booking: Booking(
          id: 'booking_1002',
          bookingNumber: 10035,
          package: Package.nonAgricultural(
            packageType: PackageType.commercial,
            averageWeight: 50,
            numberOfProducts: 10,
            description: 'Electronics - TV and Home Theater',
          ),
          pickupAddress: BookingAddress(
            addressName: 'Electronics Warehouse',
            contactName: 'Deepak Electronics',
            contactPhone: '+919876543214',
            formattedAddress: '56, Electronic City Phase 1, Bangalore',
            latitude: 12.8458,
            longitude: 77.6712,
          ),
          dropAddress: BookingAddress(
            addressName: 'Customer Home',
            contactName: 'Priya Menon',
            contactPhone: '+919876543215',
            formattedAddress: '89, JP Nagar 6th Phase, Bangalore',
            latitude: 12.9063,
            longitude: 77.5857,
          ),
          estimatedCost: 450.0,
          finalCost: 450.0,
          distanceKm: 8.5,
          baseFare: 100.0,
          distanceCharge: 15.0,
          weightMultiplier: 1.1,
          vehicleMultiplier: 1.0,
          suggestedVehicleType: VehicleType.fourWheeler,
          status: BookingStatus.completed,
          completedAt: now.subtract(const Duration(days: 2, hours: 4)),
          createdAt: now.subtract(const Duration(days: 2, hours: 6)),
          updatedAt: now.subtract(const Duration(days: 2, hours: 4)),
        ),
      ),
      BookingAssignment(
        id: 'assignment_3',
        driverId: 'driver_456',
        bookingId: 'booking_1003',
        status: AssignmentStatus.accepted,
        offeredAt: now.subtract(const Duration(days: 3)),
        respondedAt: now.subtract(const Duration(days: 3)),
        booking: Booking(
          id: 'booking_1003',
          bookingNumber: 10028,
          package: Package.agricultural(
            packageType: PackageType.personal,
            productName: 'Fruits - Mangoes',
            approximateWeight: 100,
            weightUnit: WeightUnit.kg,
          ),
          pickupAddress: BookingAddress(
            addressName: 'Fruit Market',
            contactName: 'Mango Traders',
            contactPhone: '+919876543216',
            formattedAddress: 'KR Market, Chickpet, Bangalore',
            latitude: 12.9634,
            longitude: 77.5779,
          ),
          dropAddress: BookingAddress(
            addressName: 'Restaurant',
            contactName: 'Hotel Paradise',
            contactPhone: '+919876543217',
            formattedAddress: 'MG Road, Brigade Road, Bangalore',
            latitude: 12.9756,
            longitude: 77.6045,
          ),
          estimatedCost: 320.0,
          finalCost: 350.0,
          distanceKm: 5.2,
          baseFare: 100.0,
          distanceCharge: 15.0,
          weightMultiplier: 1.0,
          vehicleMultiplier: 1.0,
          suggestedVehicleType: VehicleType.threeWheeler,
          status: BookingStatus.completed,
          completedAt: now.subtract(const Duration(days: 2, hours: 22)),
          createdAt: now.subtract(const Duration(days: 3, hours: 1)),
          updatedAt: now.subtract(const Duration(days: 2, hours: 22)),
        ),
      ),
      BookingAssignment(
        id: 'assignment_4',
        driverId: 'driver_456',
        bookingId: 'booking_1004',
        status: AssignmentStatus.rejected,
        offeredAt: now.subtract(const Duration(days: 4)),
        respondedAt: now.subtract(const Duration(days: 4)),
        booking: Booking(
          id: 'booking_1004',
          bookingNumber: 10020,
          package: Package.agricultural(
            packageType: PackageType.commercial,
            productName: 'Sugarcane',
            approximateWeight: 1000,
            weightUnit: WeightUnit.kg,
            gstBillUrl: 'https://example.com/gst.pdf',
          ),
          pickupAddress: BookingAddress(
            addressName: 'Sugarcane Farm',
            contactName: 'Farm Owner',
            contactPhone: '+919876543218',
            formattedAddress: 'Devanahalli, Bangalore Rural',
            latitude: 13.2357,
            longitude: 77.7086,
          ),
          dropAddress: BookingAddress(
            addressName: 'Sugar Factory',
            contactName: 'Factory Manager',
            contactPhone: '+919876543219',
            formattedAddress: 'Tumkur Road, Nelamangala',
            latitude: 13.0977,
            longitude: 77.3914,
          ),
          estimatedCost: 1500.0,
          distanceKm: 45.0,
          baseFare: 100.0,
          distanceCharge: 15.0,
          weightMultiplier: 1.5,
          vehicleMultiplier: 1.2,
          suggestedVehicleType: VehicleType.fourWheeler,
          status: BookingStatus.cancelled,
          createdAt: now.subtract(const Duration(days: 4, hours: 2)),
          updatedAt: now.subtract(const Duration(days: 4)),
        ),
      ),
    ];
  }
}

