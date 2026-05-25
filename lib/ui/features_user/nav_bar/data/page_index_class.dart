import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CurrentPage with ChangeNotifier {
  int currentPageIndex = 0;

  void setCurrentPageIndex(int pageIndex) {
    currentPageIndex = pageIndex;
    notifyListeners();
  }

  Future<bool> checkCurrentPageIndex(BuildContext context) async {
    if (Provider.of<CurrentPage>(context, listen: false).currentPageIndex ==
        0) {
      logger.w("Do nothing");
    } else {
      Provider.of<CurrentPage>(context, listen: false).setCurrentPageIndex(0);
      context.pop();
    }
    return false;
  }
}
