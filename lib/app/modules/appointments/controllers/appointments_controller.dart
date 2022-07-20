import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../data/models/firestore_model.dart';
import '../../../data/models/timeslot_model.dart';
import '../../../data/providers/appointment_provider.dart';
import '../../../data/providers/business_provider.dart';
import '../../../data/providers/timeslot_provider.dart';
import '../../../services/auth_service.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 3, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year + 3, kToday.month, kToday.day);

class AppointmentsController extends GetxController {
  final auth = Get.find<AuthService>();

  final calenderFormat = Rx<CalendarFormat>(CalendarFormat.week);
  final focusedDay = Rx<DateTime>(kToday);
  final selectedDay = Rxn<DateTime>(null);

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<List<Map<String, FirestoreModel>>> getAppointments(
      {bool? isVisited}) async {
    final appointments = await AppointmentProvider(null).fetchAll(
        query: ((ref, docId) => ref
            .where("date",
                isEqualTo: selectedDay.value!
                    .toIso8601String()
                    .replaceFirst(RegExp(r'Z'), ''))
            .where("pid", isEqualTo: auth.uid)
            .where("isVisited", isEqualTo: isVisited)));

    final result = appointments.map((appointment) async => {
          "appointment": appointment,
          "business": await BusinessProvider(appointment.bid).fetch(),
          "timeslot": appointment.timeslotId == null
              ? TimeslotModel()
              : await TimeslotProvider(appointment.timeslotId).fetch(),
        });
    final list = (await Future.wait(result)).toList();

    list.sort((a, b) {
      final tsa = a['timeslot'] as TimeslotModel;
      final tsb = b['timeslot'] as TimeslotModel;
      return tsb.compareWith(tsa);
    });

    return list;
  }
}
