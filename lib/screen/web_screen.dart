import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gm/common/app_theme.dart';
import 'package:gm/widgets/gm_scaffold.dart';

class WebScreen extends StatefulWidget {
  final String url;
  final String title;

  WebScreen({
    required this.url,
    required this.title,
  });

  @override
  _WebScreenState createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return GmScaffold(
      title: widget.title,
      body: Stack(
        children: [
          Positioned.fill(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse(widget.url),
              ),
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  debugPrint("progress: $progress");
                  this.progress = progress / 100;
                });
              },
            ),
          ),
          progress >= 1.0
              ? PreferredSize(
                  child: Container(),
                  preferredSize: Size.zero,
                )
              : PreferredSize(
                  child: SizedBox(
                    child: LinearProgressIndicator(
                      value: progress,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryColor,
                      ),
                    ),
                    height: 2,
                  ),
                  preferredSize: Size.fromHeight(2),
                ),
        ],
      ),
    );
  }
}
