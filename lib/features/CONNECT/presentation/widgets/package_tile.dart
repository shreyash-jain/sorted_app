import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/CONNECT/data/models/package_model.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/week_frequency_widget.dart';

class PackageTileWidget extends StatelessWidget {
  final ConsultationPackageModel package;
  final int state;
  final bool isLoading;
  final Function(ConsultationPackageModel package) onEnrollClick;
  const PackageTileWidget(
      {Key key, this.package, this.state, this.onEnrollClick, this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
      onTap: () {
        // context.router.push(PackageRoute(
        //     consultationMainBloc:
        //         consultationMainBloc,
        //     package: e.value));
      },
      child: Container(
        width: 260,
        margin: EdgeInsets.only(right: 18),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1.5,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
                    child: Gtheme.stext(package.name,
                        size: GFontSize.M, weight: GFontWeight.N),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
                    child: Gtheme.stext(
                        getStringFromPackageType(package.type) + " Plan",
                        size: GFontSize.XS,
                        color: GColors.B,
                        weight: GFontWeight.B),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
                    child: Gtheme.stext(
                        package.days.length.toString() + " days a week",
                        size: GFontSize.XXS,
                        color: GColors.B2,
                        weight: GFontWeight.N),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            PackageWeekFrequecy(
              selectedDays: package.days,
              toggleDay: (i) {},
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
                    child: Gtheme.stext("Package Fee",
                        size: GFontSize.XS,
                        color: GColors.B,
                        weight: GFontWeight.B),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
                    child: Gtheme.stext(
                        getTotalPackagePrice(
                                    package.type,
                                    package.perSessionPrice,
                                    package.days.length)
                                .toString() +
                            "  ₹",
                        size: GFontSize.L,
                        color: GColors.B,
                        weight: GFontWeight.L),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: Gparam.widthPadding,
                ),
                MaterialButton(
                  height: 50,
                  elevation: .5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: (state == 0)
                      ? () {
                          print("something");
                          if (isLoading != null &&
                              !isLoading &&
                              onEnrollClick != null) {
                            onEnrollClick(package);
                          }
                        }
                      : () {
                          print("check");
                        },
                  color: Colors.grey.shade200,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.live_tv,
                        size: 25,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Gtheme.stext(
                          (state == 0)
                              ? "Enroll"
                              : (state == 1)
                                  ? "Requested"
                                  : "Already Enrolled",
                          weight: GFontWeight.B1),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    ));
  }

  int getTotalPackagePrice(int type, int perSessionPrice, int length) {
    switch (type) {
      case 0:
        return perSessionPrice;
      case 1:
        return length * perSessionPrice;
      case 2:
        return length * perSessionPrice * 4;
      case 3:
        return length * perSessionPrice * 12;

        break;
      default:
        return length * perSessionPrice * 12;
    }
  }

  String getStringFromPackageType(int type) {
    switch (type) {
      case 0:
        return "1 time";
      case 1:
        return "1 Week";
      case 2:
        return "1 Month";
      case 3:
        return "3 Months";

        break;
      default:
        return "3 Months";
    }
  }
}
