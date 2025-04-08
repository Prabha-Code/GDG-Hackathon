import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MoisturePage extends StatefulWidget {
  const MoisturePage({super.key});

  @override
  State<MoisturePage> createState() => _MoisturePageState();
}

class _MoisturePageState extends State<MoisturePage> {
  int soilMoisture = 42;
  int soilTemp = 29;
  int lightIntensity = 1100;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize WebView Controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://heatmap-dashboard-url.com'));

    // Update sensor values every 3 seconds
    Timer.periodic(const Duration(seconds: 3), (timer) {
      final random = Random();
      setState(() {
        soilMoisture = 30 + random.nextInt(41); // 30% to 70%
        soilTemp = 25 + random.nextInt(10); // 25°C to 34°C
        lightIntensity = 1000 + random.nextInt(500); // 1000 lx to 1500 lx
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Moisture & Sensor Data"),
        backgroundColor: Colors.orange[700],
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("🌱 Soil Moisture: $soilMoisture%"),
            subtitle: const Text("Auto-updating every 3 seconds"),
          ),
          ListTile(
            title: Text("🌡️ Soil Temperature: $soilTemp°C"),
            subtitle: Text("☀️ Light Intensity: $lightIntensity lx"),
          ),
          const SizedBox(height: 16),
          const Text("📍 Heatmap View", style: TextStyle(fontSize: 18)),
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
}

