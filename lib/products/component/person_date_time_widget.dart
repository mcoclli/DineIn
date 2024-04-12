import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/constants/app_string.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/profile_page/model/restaurant_model.dart';
import 'package:reservation/feature/reservation_page/model/reservation_model.dart';
import 'package:reservation/feature/reservation_page/viewModel/reservation_view_model.dart';

class PersonDateTimeWidget extends StatefulWidget {
  const PersonDateTimeWidget({super.key, required this.currentRestaurant});

  final RestaurantModel currentRestaurant;

  @override
  State<PersonDateTimeWidget> createState() => _PersonDateTimeWidgetState();
}

class _PersonDateTimeWidgetState extends State<PersonDateTimeWidget> {
  void _showBottomSheet(
      BuildContext context, ReservationViewModel reservationViewModel) {
    int pax = reservationViewModel.pax;
    DateTime reservationStart = reservationViewModel.reservationStart;
    int slots = 1;

    void showModal() {
      showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: context.dynamicHeight(0.40),
            child: Column(
              children: <Widget>[
                //Person Container
                Expanded(
                  child: Consumer(
                    builder: ((context, value, child) {
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 14,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: context.cardPadding,
                            child: GestureDetector(
                              child: Container(
                                height: context.dynamicHeight(0.1),
                                width: context.dynamicWidth(0.1),
                                padding: context.personPadding,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: index + 1 == pax
                                        ? AppColors.poppypower
                                        : AppColors.black,
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                      color: index + 1 == pax
                                          ? AppColors.poppypower
                                          : AppColors.black,
                                      fontSize: 16),
                                )),
                              ),
                              onTap: () {
                                setState(() {
                                  pax = index + 1;
                                });
                                CommonUtils.log("Change pax to $pax");
                              },
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
                //DateTime
                Center(
                  child: SizedBox(
                      height: context.dynamicHeight(0.15),
                      child: Consumer(
                        builder: ((context, value, child) {
                          return CupertinoDatePicker(
                            initialDateTime: reservationStart.subtract(
                              Duration(
                                minutes: reservationStart.minute % 15,
                                seconds: reservationStart.second,
                                milliseconds: reservationStart.millisecond,
                                microseconds: reservationStart.microsecond,
                              ),
                            ),
                            minimumDate: reservationStart
                                .subtract(const Duration(minutes: 15)),
                            minuteInterval: 15,
                            mode: CupertinoDatePickerMode.dateAndTime,
                            onDateTimeChanged: (DateTime dateTime) {
                              bool isValid = true;
                              int slotTime =
                                  widget.currentRestaurant.slotDurationMin;
                              // check availability
                              isValid = widget.currentRestaurant
                                  .isRestaurantAvailable(dateTime);
                              if (isValid) {
                                // check reservation times
                                for (ReservationModel reservation
                                    in reservationViewModel
                                            .currentReservations ??
                                        []) {
                                  int totalDuration =
                                      reservation.slots * slotTime;
                                  DateTime end = reservation.start
                                      .add(Duration(minutes: totalDuration));
                                  if (dateTime.isAfter(reservation.start) &&
                                      dateTime.isBefore(end)) {
                                    isValid = false;
                                    break;
                                  }
                                }
                              }
                              CommonUtils.log("checking date time is $isValid");
                              if (isValid) {
                                setState(() {
                                  reservationStart = dateTime;
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Time Slot Unavailable'),
                                      content: const Text(
                                          'The selected time slot is already reserved. Please choose another time.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          );
                        }),
                      )),
                ),
                SizedBox(height: context.dynamicHeight(0.04)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Select time slots (in minutes ${widget.currentRestaurant.slotDurationMin}) :"),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              bool isValid = true;
                              if (slots > 1) {
                                // setState(() {
                                //   slots--;
                                // });
                                var uptSlot = (slots - 1);
                                CommonUtils.log("Changing counter (-) $slots");
                                isValid = validateReservationEnd(reservationStart, uptSlot, isValid, reservationViewModel);
                                if (isValid) {
                                  setState(() {
                                    slots = uptSlot;
                                  });
                                } else {
                                  _showSlotOverlapMessage(context);
                                }
                              }
                            },
                            child: const Icon(Icons.remove, color: Colors.red),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('$slots'),
                          ),
                          InkWell(
                            onTap: () {
                              bool isValid = true;
                              // setState(() {
                              //   setState(() {
                              //     slots++;
                              //   });
                              // });
                              var uptSlot = (slots + 1);
                              CommonUtils.log("Changing counter (+) $slots");
                              isValid = validateReservationEnd(reservationStart, uptSlot, isValid, reservationViewModel);
                              if (isValid) {
                                setState(() {
                                  slots = uptSlot;
                                });
                              } else {
                                _showSlotOverlapMessage(context);
                              }
                            },
                            child: const Icon(Icons.add, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: SizedBox(
                    width: context.dynamicWidth(0.70),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(StringConstant.select),
                      onPressed: () {
                        CommonUtils.log(
                            "Setting the reservation date to $reservationStart and pax to $pax");
                        reservationViewModel
                            .setReservationStart(reservationStart);
                        reservationViewModel.setPax(pax);
                        reservationViewModel.setSlots(slots);
                        reservationViewModel.notifyAll();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                SizedBox(height: context.dynamicHeight(0.04)),
              ],
            ),
          );
        }),
      );
    }

    showModal();
  }

  void _showSlotOverlapMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
          const Text('Time Slot Unavailable'),
          content: const Text(
              'The selected time slot is overlapping with a reserved one. Please change the slot count.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  bool validateReservationEnd(DateTime reservationStart, int uptSlot, bool isValid, ReservationViewModel reservationViewModel) {
    int slotTime =
        widget.currentRestaurant.slotDurationMin;
    // check availability
    var reservationEnd = reservationStart.add(Duration(minutes: (uptSlot * slotTime)));
    isValid = widget.currentRestaurant.isRestaurantAvailable(reservationEnd);
    if (isValid) {
      // check reservation times
      for (ReservationModel reservation
      in reservationViewModel
          .currentReservations ??
          []) {
        DateTime end = reservation.start
            .add(Duration(minutes: (reservation.slots * slotTime)));

        if (reservationEnd.isAfter(reservation.start) &&
            reservationEnd.isBefore(end)) {
          isValid = false;
          break;
        }
      }
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    var reservationViewModel = Provider.of<ReservationViewModel>(context);
    var pax = reservationViewModel.pax;
    return Padding(
      padding: context.pagePadding,
      child: Container(
        height: context.dynamicHeight(0.05),
        width: context.dynamicWidth(0.65),
        decoration: context.colormiddelDecoraiton,
        child: Center(
          child: Row(children: [
            Padding(
              padding: context.cardPadding,
              child: const Icon(Icons.person_outline, color: AppColors.black),
            ),
            TextButton(
                onPressed: () =>
                    _showBottomSheet(context, reservationViewModel),
                child: Consumer(
                  builder: ((context, value, child) {
                    return Text(
                      "$pax ${DateFormat(' h:mm a, d MMM, EEEE').format(context.read<ReservationViewModel>().reservationStart)}",
                      style: const TextStyle(
                        color: AppColors.black,
                      ),
                    );
                  }),
                )),
          ]),
        ),
      ),
    );
  }
}
