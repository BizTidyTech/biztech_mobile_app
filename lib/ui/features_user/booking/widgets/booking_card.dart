import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/bookings_list_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_list_view/bookings_details_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/booking_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_view/job_rating_screen.dart';
import 'package:biztidy_mobile_app/ui/shared/curved_container.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Widget bookingCard(BuildContext context, BookingModel? booking) {
  if (booking == null) return const SizedBox.shrink();

  final ctrl = Get.find<BookingsListController>();
  final needsRating =
      !booking.isRated && ctrl.isJobCompleted(booking.bookingId);

  return InkWell(
    onTap: () {
      logger.i('Tapped ${booking.service?.name}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookingDetailsScreen(booking: booking),
        ),
      );
    },
    child: Card(
      child: CustomCurvedContainer(
        height: (needsRating || booking.isRated) ? 82 : 65,
        leftPadding: 12,
        rightPadding: 12,
        fillColor: AppColors.plainWhite,
        borderColor: booking.isRated
            ? AppColors.normalGreen
            : needsRating
                ? const Color(0xFFF59E0B)
                : AppColors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Row 1: service name + date ──────────────────────────────
            SizedBox(
              width: screenWidth(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      booking.service?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.regularStringStyle(
                          16, AppColors.fullBlack),
                    ),
                  ),
                  Text(
                    DateFormat('MMM d, y').format(booking.dateTime!),
                    style:
                        AppStyles.subStringStyle(15, AppColors.fullBlack),
                  ),
                ],
              ),
            ),
            verticalSpacer(3),
            // ── Row 2: customer name + time ─────────────────────────────
            SizedBox(
              width: screenWidth(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      booking.customer?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.regularStringStyle(
                        14,
                        AppColors.fullBlack.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('h:mm a').format(booking.dateTime!),
                    style:
                        AppStyles.subStringStyle(15, AppColors.fullBlack),
                  ),
                ],
              ),
            ),
            // ── Row 3: rating badge ─────────────────────────────────────
            if (booking.isRated) ...[
              verticalSpacer(6),
              Row(
                children: [
                  ...List.generate(
                    5,
                    (i) => Icon(
                      i < (booking.clientRating ?? 0).floor()
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: const Color(0xFFF59E0B),
                      size: 16,
                    ),
                  ),
                  horizontalSpacer(6),
                  Text(
                    'You rated ${booking.clientRating?.toStringAsFixed(1)}/5',
                    style: AppStyles.subStringStyle(12, AppColors.darkGray),
                  ),
                ],
              ),
            ] else if (needsRating) ...[
              verticalSpacer(6),
              GestureDetector(
                onTap: () => JobRatingSheet.show(context, booking),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color(0xFFF59E0B)
                            .withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_outline_rounded,
                          color: Color(0xFFF59E0B), size: 14),
                      horizontalSpacer(4),
                      Text(
                        'Rate your clean',
                        style: AppStyles.subStringStyle(
                            12, const Color(0xFFB45309)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
