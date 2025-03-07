import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterView extends StatelessWidget {
  const HelpCenterView({super.key});

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'tidy1tech@gmail.com',
      query: 'subject=Help Needed&body=Describe your issue here',
    );
    try {
      await launchUrl(emailUri);
    } catch (e) {
      Fluttertoast.showToast(msg: "Could not launch email");
    }
  }

  void _launchWhatsApp() async {
    const String whatsappNumber = "+16823953303";
    const String message = "Hello, I need help with . . .";
    final Uri whatsappUri =
        Uri.parse("https://wa.me/$whatsappNumber?text=$message");
    try {
      await launchUrl(whatsappUri);
    } catch (e) {
      Fluttertoast.showToast(msg: "Could not launch WhatsApp");
    }
  }

  void _launchPhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+16823237358');
    try {
      await launchUrl(phoneUri);
    } catch (e) {
      Fluttertoast.showToast(msg: "Could not launch phone call");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryThemeColor,
        title: Text(
          'Help Center',
          style: AppStyles.normalStringStyle(20, AppColors.fullBlack),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Have questions or need any help? Contact us via any of the following channels.',
              style: AppStyles.regularStringStyle(16, AppColors.fullBlack),
              textAlign: TextAlign.center,
            ),
            verticalSpacer(40),
            ElevatedButton.icon(
              onPressed: _launchEmail,
              icon: const Icon(
                Icons.email,
                color: Colors.blue,
              ),
              label: Text(
                'Email',
                style: AppStyles.normalStringStyle(
                  17,
                  Colors.blue,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15)),
            ),
            verticalSpacer(16),
            ElevatedButton.icon(
              onPressed: _launchWhatsApp,
              icon: Icon(
                FontAwesomeIcons.whatsapp,
                color: AppColors.normalGreen,
              ),
              label: Text(
                'WhatsApp',
                style: AppStyles.normalStringStyle(
                  17,
                  AppColors.normalGreen,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15)),
            ),
            verticalSpacer(16),
            ElevatedButton.icon(
              onPressed: _launchPhoneCall,
              icon: Icon(
                Icons.phone,
                color: AppColors.deepBlue,
              ),
              label: Text(
                'Call',
                style: AppStyles.normalStringStyle(
                  17,
                  AppColors.deepBlue,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15)),
            ),
          ],
        ),
      ),
    );
  }
}
