import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tidytech/tidytech_app.dart';

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
