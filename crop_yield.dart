import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CropYieldPage extends StatefulWidget {
  const CropYieldPage({super.key});

  @override
  State<CropYieldPage> createState() => _CropYieldPageState();
}

class _CropYieldPageState extends State<CropYieldPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('http://127.0.0.1:5000/index.html')); // Flask API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🌾 Crop Yield Prediction")),
      body: WebViewWidget(controller: _controller),
    );
  }
}

