import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uiam_personal/app/data/enums/variant_button_size.dart';
import 'package:uiam_personal/app/data/models/appointment_model.dart';
import 'package:uiam_personal/app/data/models/business_model.dart';
import 'package:uiam_personal/app/data/models/timeslot_model.dart';
import 'package:uiam_personal/app/global/widgets/variant_button.dart';

import '../../../../core/theme/variant_theme.dart';
import '../../../../core/values/consts.dart';
import '../../../data/models/firestore_model.dart';
import '../../../global/widgets/avatar.dart';
import '../../../global/widgets/drop_shadow.dart';
import '../../../global/widgets/variant_progress_button.dart';
import '../controllers/appointments_controller.dart';

class AppointmentsView extends GetResponsiveView<AppointmentsController> {
  AppointmentsView({Key? key}) : super(key: key);
  @override
  Widget builder() {
    return Scaffold(
        body: SafeArea(
      bottom: false,
      child: NestedScrollView(
        headerSliverBuilder: (context, i) => [
          SliverToBoxAdapter(
            child: Container(
                // padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                child: SafeArea(
                  child: Text(
                    "Appointments",
                    style: Get.theme.textTheme.titleMedium,
                  ),
                )),
          )
        ],
        body: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Obx(() => TableCalendar(
                      focusedDay: controller.focusedDay.value,
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      calendarFormat: controller.calenderFormat.value,
                      selectedDayPredicate: (day) =>
                          isSameDay(controller.selectedDay.value, day),
                      onFormatChanged: (format) {
                        controller.calenderFormat.value = format;
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        controller.focusedDay.value = focusedDay;
                        controller.selectedDay.value = selectedDay;
                      },
                      onPageChanged: (focusedDay) {
                        controller.focusedDay.value = focusedDay;
                      },
                    )),
                if (controller.selectedDay.value != null)
                  Flexible(
                    child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(
                              labelColor: Get.theme.colorScheme.onBackground,
                              indicatorColor: Get.theme.colorScheme.primary,
                              tabs: [
                                Tab(
                                  child: Text("UnVisited"),
                                ),
                                Tab(
                                  child: Text("Visited"),
                                ),
                              ],
                            ),
                            Flexible(
                                child: TabBarView(
                              children: [
                                _appointmentsPanel(),
                                _appointmentsPanel(isVisited: true)
                              ],
                            ))
                          ],
                        )),
                  )
              ],
            )),
      ),
    ));
  }

  _appointmentsPanel({bool? isVisited}) => FutureBuilder<
          List<Map<String, FirestoreModel>>>(
      future: controller.getAppointments(isVisited: isVisited),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Something went wrong"));
        }

        if (snapshot.hasData &&
            (snapshot.data == null || snapshot.data!.isEmpty)) {
          return Center(child: Text("No Appointments"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return GridView.builder(
            padding: const EdgeInsets.symmetric(
                horizontal: dSpace / 2, vertical: dSpace),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screen.isDesktop
                  ? 3
                  : screen.isTablet
                      ? 2
                      : 1,
              crossAxisSpacing: dSpace,
              mainAxisSpacing: dSpace,
              mainAxisExtent: 125,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final business =
                  snapshot.data![index]["business"] as BusinessModel;
              final appointment =
                  snapshot.data![index]["appointment"] as AppointmentModel;
              final timeslot =
                  snapshot.data![index]["timeslot"] as TimeslotModel;

              return DropShadow(
                child: Padding(
                  padding: EdgeInsets.all(dSpace * 0 / 2),
                  child: DropShadow(
                    blurRadius: dSpace / 2,
                    shadowOpacity: 0.1,
                    child: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(dSpace / 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          color: Get.theme.colorScheme.background,
                        ),
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Avatar(
                                business.image!,
                                size: 70,
                              ),
                              SizedBox(
                                width: dSpace / 2,
                              ),
                              Expanded(
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            business.name!,
                                            style:
                                                Get.theme.textTheme.titleMedium,
                                          )
                                        ],
                                      ),
                                      Text(
                                        business.email!,
                                        style: Get.theme.textTheme.caption,
                                        overflow: TextOverflow.fade,
                                      ),
                                      Text(
                                        business.phone!,
                                        style: Get.theme.textTheme.caption,
                                      ),
                                      if (timeslot.id != null)
                                        VariantButton(
                                          content:
                                              "${timeslot.startTime12} - ${timeslot.endTime12}",
                                          size: VariantButtonSize.xsmall,
                                        ),
                                      if (appointment.isVisited)
                                        Text(
                                          "Visited at " +
                                              DateFormat.yMd().add_jm().format(
                                                  appointment.visited_at!),
                                          style: Get.theme.textTheme.caption,
                                        )
                                    ]),
                              )
                            ]),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      });
}
