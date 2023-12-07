import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogBuilder {
  Future<void> dialogBuilder(BuildContext context, mapUrl, reviewUrl) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('예약/리뷰'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('예약'),
              onPressed: () async {
                if (!await launchUrl(
                  mapUrl,
                  mode: LaunchMode.externalApplication,
                )) {
                  throw Exception('Could not launch $mapUrl');
                }
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('리뷰'),
              onPressed: () async {
                if (!await launchUrl(
                  reviewUrl,
                  mode: LaunchMode.externalApplication,
                )) {
                  throw Exception('Could not launch $reviewUrl');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
