import 'package:get/get.dart';
import 'package:uiam_personal/app/data/providers/appointment_provider.dart';
import 'package:uiam_personal/app/services/auth_service.dart';

import 'firestore_provider.dart';
import '../models/timeslot_model.dart';

class TimeslotProvider extends FirestoreProvider<TimeslotModel> {
  TimeslotProvider(String? docId) : super(docId);

  @override
  collectionRef() => FirestoreProvider.db.collection('timeslots');

  @override
  modelRef(documentSnapshot) =>
      TimeslotModel.fromDocumentSnapshot(documentSnapshot);

  Future<List<TimeslotModel>> getAvailable(String bid, DateTime date) async {
    try {
      final timeslots =
          (await collectionRef().where("bid", isEqualTo: bid).get())
              .docs
              .map((documentSnapshot) => modelRef(documentSnapshot));

      final appointments = await AppointmentProvider(null).fetchAll(
          query: ((ref, docId) => ref.where("bid", isEqualTo: bid).where("date",
              isEqualTo:
                  date.toIso8601String().replaceFirst(RegExp(r'Z'), ''))));

      if (appointments
              .where((appointment) =>
                  appointment.pid == Get.find<AuthService>().uid)
              .length >
          0) {
        return [];
      }

      return timeslots.where((timeslot) {
        final appointments_for_timeslot = appointments
            .where((appointment) => appointment.timeslotId == timeslot.id);
        final kToday = DateTime.now();

        return (kToday.day == date.day &&
                kToday.month == date.month &&
                kToday.year == date.year)
            ? timeslot.compareWith(TimeslotModel(
                        startTime: "${kToday.hour}:${kToday.minute}")) >
                    -1 &&
                timeslot.capacity! > appointments_for_timeslot.length
            : timeslot.capacity! > appointments_for_timeslot.length;
      }).toList();
    } catch (e) {}
    return [];
  }
}
