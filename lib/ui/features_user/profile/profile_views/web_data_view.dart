import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebDataView extends StatefulWidget {
  final String title;
  final String url;
  const WebDataView({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<WebDataView> createState() => _WebDataViewState();
}

class _WebDataViewState extends State<WebDataView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('Navigation request to: ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryThemeColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left_rounded,
            color: AppColors.fullBlack,
            size: 32,
          ),
        ),
        title: Text(
          widget.title,
          style: AppStyles.normalStringStyle(20, AppColors.fullBlack),
        ),
      ),
      body: _isLoading == true
          ? Center(child: loadingWidget())
          : WebViewWidget(controller: _controller),
    );
  }
}

void goToWebViewPage(
  BuildContext context, {
  required String title,
  required String url,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return WebDataView(title: title, url: url);
      },
    ),
  );
}
