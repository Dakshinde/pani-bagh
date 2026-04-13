import 'package:flutter/material.dart';
import 'services/mock_service.dart';
import 'widgets/water_tank.dart';
import 'widgets/history_chart.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final MockService _mockService = MockService();
  final List<double> history = [70, 68, 65, 66, 60, 58, 55];
  bool _pumpOn = true;
  final int _bleStrength = 83;

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute:$second $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade900),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.blueAccent,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'User: Daksh',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'IoT Dashboard',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _drawerItem(icon: Icons.home, title: 'Home'),
            _drawerItem(icon: Icons.show_chart, title: 'Analytics'),
            _drawerItem(icon: Icons.history, title: 'History'),
            _drawerItem(icon: Icons.settings, title: 'Settings'),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: Colors.blue.shade900,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                'Pani Bagh Pro',
                style: TextStyle(fontSize: 18),
              ),
              background: LayoutBuilder(
                builder: (context, constraints) {
                  final bool showExpandedInfo = constraints.maxHeight > 130;
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade900, Colors.blue.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: showExpandedInfo
                        ? Stack(
                            children: [
                              Positioned(
                                left: 20,
                                bottom: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Live Water Tank Monitoring',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Industrial IoT',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<double>(
              stream: _mockService.waterLevelStream,
              builder: (context, snapshot) {
                final double level = snapshot.data ?? 0.0;
                if (snapshot.hasData && history.last != level) {
                  history.add(level);
                  if (history.length > 10) history.removeAt(0);
                }
                final String updatedText = snapshot.hasData
                    ? _formatTime(DateTime.now())
                    : 'Waiting for data';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Water Tank Level',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    SizedBox(
                                      height: 260,
                                      child: WaterTank(percent: level),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _dashboardMetric(
                                      'Current Level',
                                      '${level.toStringAsFixed(1)}%',
                                      Icons.opacity,
                                      Colors.lightBlue.shade700,
                                    ),
                                    const SizedBox(height: 12),
                                    _dashboardMetric(
                                      'Alert Status',
                                      level > 20 ? 'Safe' : 'Low',
                                      Icons.warning_amber_rounded,
                                      level > 20 ? Colors.green : Colors.orange,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.95,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _pumpStatusCard(),
                          _connectivityCard(),
                          _lastUpdatedCard(updatedText),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Usage Statistics (Live)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: HistoryChart(recentLevels: history),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({required IconData icon, required String title}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade900),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: () => Navigator.of(context).pop(),
    );
  }

  Widget _dashboardMetric(
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withValues(alpha: 0.14),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pumpStatusCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.power_settings_new, color: Colors.blueAccent),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Pump Status',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _pumpOn ? 'Running' : 'Stopped',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _pumpOn ? Colors.green : Colors.red,
                  ),
                ),
                Switch(
                  value: _pumpOn,
                  onChanged: (value) => setState(() => _pumpOn = value),
                  activeThumbColor: Colors.blue.shade900,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _connectivityCard() {
    final String signalLabel = _bleStrength > 75
        ? 'Strong'
        : _bleStrength > 45
        ? 'Stable'
        : 'Weak';
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bluetooth, color: Colors.blueAccent),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Connectivity',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              signalLabel,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'BLE Strength: $_bleStrength%',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lastUpdatedCard(String updatedText) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.update, color: Colors.blueAccent),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Last Updated',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              updatedText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Live sensor refresh',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
