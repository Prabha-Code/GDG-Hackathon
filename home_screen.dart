import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Timer _timer;
  final Random _random = Random();
  double _temperature = 26.0;
  double _humidity = 55.0;
  double _moisture = 42.0;

  @override
  void initState() {
    super.initState();
    _updateSensorValues();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _updateSensorValues());
  }

  void _updateSensorValues() {
    setState(() {
      _temperature = 20 + _random.nextDouble() * 10;
      _humidity = 40 + _random.nextDouble() * 30;
      _moisture = 20 + _random.nextDouble() * 60;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _sensorCard(String label, IconData icon, double value, String unit, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('${value.toStringAsFixed(1)} $unit',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: color.withOpacity(0.1),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(width: 16),
              Expanded(
                child: Text(title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18)
            ],
          ),
        ),
      ),
    );
  }

  Widget _heatmapPlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          "🌾 Heatmap Placeholder\n(Land moisture distribution)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Farming Dashboard'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text("🌡️ Live Sensor Stats", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                _sensorCard("Temperature", Icons.thermostat, _temperature, "°C", Colors.red),
                const SizedBox(width: 12),
                _sensorCard("Humidity", Icons.water_drop, _humidity, "%", Colors.blue),
                const SizedBox(width: 12),
                _sensorCard("Soil Moisture", Icons.grass, _moisture, "%", Colors.brown),
              ],
            ),
            const SizedBox(height: 24),

            const Text("📊 Smart Features", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            _featureCard("Crop Yield Prediction", Icons.trending_up, Colors.orange, () {}),
            _featureCard("Weather Forecast", Icons.cloud, Colors.cyan, () {}),
            _featureCard("Moisture Data", Icons.opacity, Colors.indigo, () {}),
            const SizedBox(height: 24),

            const Text("🗺️ Land Heatmap", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _heatmapPlaceholder(),
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Go to chatbot page
        },
        backgroundColor: Colors.purple,
        label: const Text("Ask Chatbot"),
        icon: const Icon(Icons.chat),
      ),
    );
  }
}
Widget get _heatmapWithDetails {
  return Container(
    decoration: BoxDecoration(
      color: Colors.green[50],
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Image.asset('assets/heatmap.png', height: 200, width: double.infinity, fit: BoxFit.cover),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Land Heatmap Analysis",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("🔴 Red Areas - High Moisture\n🟡 Yellow Areas - Medium Moisture\n🟢 Green Areas - Optimal Moisture",
                  style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    ),
  );
}
void _showChatbot(BuildContext context) {
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _messages = [];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("👨‍🌾 Smart Farming Chatbot",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return Align(
                        alignment: msg['type'] == 'user'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: msg['type'] == 'user'
                                ? Colors.green[100]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(msg['text']!),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        decoration: const InputDecoration(
                          hintText: "Ask something...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        final question = _chatController.text.trim();
                        if (question.isNotEmpty) {
                          setModalState(() {
                            _messages.add({"type": "user", "text": question});
                            _messages.add({
                              "type": "bot",
                              "text": "This is a sample response to: \"$question\""
                            });
                          });
                          _chatController.clear();
                        }
                      },
                    )
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      );
    },
  );
}

