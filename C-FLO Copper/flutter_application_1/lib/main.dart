import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const CFloPremiumApp());
}

class CFloPremiumApp extends StatelessWidget {
  const CFloPremiumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'C-Flo Copper',
      theme: ThemeData(
        primaryColor: const Color(0xFF0B192C),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0B192C),
          primary: const Color(0xFF0B192C),
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F5F9),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// ==========================================
// 1. MAIN NAVIGATION
// ==========================================
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0; // Fixed: Now starts on the Home page!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(onNavigate: (index) => setState(() => _currentIndex = index)),
          const CatalogScreen(),
          const CalculatorGridScreen(),
          const TechDataScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFC37145),
        unselectedItemColor: Colors.grey.shade500,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'Pipes'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate_outlined), activeIcon: Icon(Icons.calculate), label: 'Calculator'),
          BottomNavigationBarItem(icon: Icon(Icons.layers_outlined), activeIcon: Icon(Icons.layers), label: 'Tech Data'),
        ],
      ),
    );
  }
}

// ==========================================
// TAB 1: HOME SCREEN
// ==========================================
class HomeScreen extends StatelessWidget {
  final Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B192C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B192C),
        elevation: 0,
        title: Row(
          children: [
            Container(
              height: 38,
              width: 38,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Image.asset(
                'assets/logo.jpg',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.hexagon, color: Colors.blueAccent),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('C-Flo Copper', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                Text('Demo User • demo', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 16),
        decoration: const BoxDecoration(
          color: Color(0xFFF3F5F9),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('LME Copper Trend (USD/ton)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0B192C))),
                            Row(
                              children: [
                                const Icon(Icons.circle, size: 8, color: Color(0xFFC37145)),
                                const SizedBox(width: 4),
                                const Text('Live', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 220,
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                          child: CustomPaint(
                            painter: CopperChartPainter(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    _buildQuickActionCard(
                      icon: Icons.calculate_outlined,
                      title: 'Weight calculator',
                      subtitle: '8 shapes',
                      onTap: () => onNavigate(2),
                    ),
                    _buildQuickActionCard(
                      icon: Icons.shopping_cart_outlined,
                      title: 'Pipe catalog',
                      subtitle: 'Live Rates',
                      onTap: () => onNavigate(1),
                    ),
                    _buildQuickActionCard(
                      icon: Icons.layers_outlined,
                      title: 'Technical data',
                      subtitle: 'ASTM, EN standards',
                      onTap: () => onNavigate(3),
                    ),
                    _buildQuickActionCard(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'Inbox',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No new notifications')),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFFC37145), size: 24),
              const Spacer(),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0B192C))),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// CHART PAINTER
// ==========================================
class CopperChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double paddingLeft = 40.0;
    final double paddingBottom = 25.0;
    final double graphWidth = size.width - paddingLeft;
    final double graphHeight = size.height - paddingBottom;

    final paintGrid = Paint()..color = Colors.grey.shade200..strokeWidth = 1;
    final textStyle = TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.w600);

    List<String> yLabels = ['8,200', '8,400', '8,600', '8,800'];
    for (int i = 0; i < 4; i++) {
      double y = graphHeight - (graphHeight * (i / 3));
      if (i == 3) y = 10;
      canvas.drawLine(Offset(paddingLeft, y), Offset(size.width, y), paintGrid);
      final textSpan = TextSpan(text: yLabels[i], style: textStyle);
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - 6));
    }

    List<String> xLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    for (int i = 0; i < 6; i++) {
      double x = paddingLeft + (graphWidth * (i / 5));
      canvas.drawLine(Offset(x, 10), Offset(x, graphHeight), paintGrid);
      final textSpan = TextSpan(text: xLabels[i], style: textStyle);
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - (textPainter.width / 2), graphHeight + 8));
    }

    List<Offset> points = [
      Offset(paddingLeft, graphHeight * 0.8),
      Offset(paddingLeft + (graphWidth * 0.2), graphHeight * 0.55),
      Offset(paddingLeft + (graphWidth * 0.4), graphHeight * 0.35),
      Offset(paddingLeft + (graphWidth * 0.6), graphHeight * 0.45),
      Offset(paddingLeft + (graphWidth * 0.8), graphHeight * 0.15),
      Offset(paddingLeft + graphWidth, graphHeight * 0.20),
    ];

    final pathBme = Path();
    pathBme.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      var p1 = points[i];
      var p2 = points[i + 1];
      var midX = (p1.dx + p2.dx) / 2;
      pathBme.cubicTo(midX, p1.dy, midX, p2.dy, p2.dx, p2.dy);
    }

    final fillBme = Paint()
      ..shader = ui.Gradient.linear(const Offset(0, 0), Offset(0, graphHeight), [const Color(0xFFC37145).withOpacity(0.35), Colors.transparent]);
    final pathBmeFill = Path.from(pathBme)
      ..lineTo(paddingLeft + graphWidth, graphHeight)
      ..lineTo(paddingLeft, graphHeight)
      ..close();
    canvas.drawPath(pathBmeFill, fillBme);

    final strokeBme = Paint()..color = const Color(0xFFC37145)..strokeWidth = 3.0..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawPath(pathBme, strokeBme);

    final dotFillPaint = Paint()..color = Colors.white;
    final dotStrokePaint = Paint()..color = const Color(0xFFC37145)..strokeWidth = 2.5..style = PaintingStyle.stroke;

    List<String> exactPrices = ['8,320', '8,470', '8,590', '8,530', '8,710', '8,680'];
    const priceTextStyle = TextStyle(color: Color(0xFF0B192C), fontSize: 9, fontWeight: FontWeight.bold);

    for (int i = 0; i < points.length; i++) {
      var point = points[i];
      canvas.drawCircle(point, 4.5, dotFillPaint);
      canvas.drawCircle(point, 4.5, dotStrokePaint);

      final textSpan = TextSpan(text: exactPrices[i], style: priceTextStyle);
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(canvas, Offset(point.dx - (textPainter.width / 2), point.dy - 16));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// TAB 2: CATALOG
// ==========================================
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final String sheetCsvUrl =
      'https://docs.google.com/spreadsheets/d/e/2PACX-1vTDfHce5JUMXP5imBipYfojkb1kS9MSEDfQ4A-lzFAlJFp8SFaurPBxamHPSqOQxMVEdbYBVnaMDvtR/pub?output=csv';

  List<Map<String, String>> rawMetals = [];
  List<Map<String, String>> pipeRates = [];
  bool isLoading = true;
  String? errorMessage;
  int _selectedPillIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchSheetData();
  }

  Future<void> fetchSheetData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final response = await http.get(Uri.parse(sheetCsvUrl));
      if (response.statusCode == 200) {
        final lines = const LineSplitter().convert(response.body);
        List<Map<String, String>> tempRaw = [];
        List<Map<String, String>> tempPipes = [];

        for (int i = 1; i < lines.length; i++) {
          final line = lines[i].trim();
          if (line.isEmpty || line.replaceAll(',', '').trim().isEmpty) continue;

          final parts = line.split(RegExp(r',(?=(?:[^"]*"[^"]*")*[^"]*$)')).map((e) => e.replaceAll('"', '').trim()).toList();

          if (parts.length >= 5 && parts[0].isNotEmpty) {
            String formattedChange = parts[3];
            double? parsedVal = double.tryParse(parts[3]);
            if (parsedVal != null) {
              double pct = parsedVal * 100;
              formattedChange = (pct >= 0 ? '+${pct.toStringAsFixed(1)}%' : '${pct.toStringAsFixed(1)}%');
            } else if (!formattedChange.contains('%')) {
              formattedChange = '$formattedChange%';
            }

            final item = {'metal': parts[0], 'price': parts[1], 'unit': parts[2], 'change': formattedChange};

            if (parts[4].toLowerCase().contains('raw')) {
              tempRaw.add(item);
            } else {
              tempPipes.add(item);
            }
          }
        }
        setState(() {
          rawMetals = tempRaw;
          pipeRates = tempPipes;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load rates';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categories = ['All Rates', 'Raw Metals', 'Hard Pipes', 'Soft Pipes', 'K, L, M Types'];

    List<Map<String, String>> displayList = [];
    if (_selectedPillIndex == 0) {
      displayList = [...rawMetals, ...pipeRates];
    } else if (_selectedPillIndex == 1) {
      displayList = rawMetals;
    } else if (_selectedPillIndex == 2) {
      displayList = pipeRates.where((p) => p['metal']!.toLowerCase().contains('hard')).toList();
    } else if (_selectedPillIndex == 3) {
      displayList = pipeRates.where((p) => p['metal']!.toLowerCase().contains('soft') || p['metal']!.toLowerCase().contains('medical')).toList();
    } else if (_selectedPillIndex == 4) {
      displayList = pipeRates.where((p) => p['metal']!.toLowerCase().contains(' type')).toList();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B192C),
        title: const Text('Market Catalog', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: fetchSheetData)],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(categories.length, (index) {
                      bool isSelected = _selectedPillIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(categories[index], style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.bold)),
                          selected: isSelected,
                          selectedColor: const Color(0xFFC37145),
                          backgroundColor: const Color(0xFFF1F3F5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          showCheckmark: false,
                          onSelected: (val) => setState(() => _selectedPillIndex = index),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: const Color(0xFFF1F3F5), borderRadius: BorderRadius.circular(12)),
                  child: const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search by size or name...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFC37145)))
                : RefreshIndicator(
                    onRefresh: fetchSheetData,
                    child: displayList.isEmpty
                        ? const Center(child: Text("No items found in this category.", style: TextStyle(color: Colors.grey)))
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: displayList.length,
                            separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200),
                            itemBuilder: (context, index) {
                              final item = displayList[index];
                              bool isDown = (item['change'] ?? '').startsWith('-');
                              Color changeCol = (item['change'] == '0.0%' || item['change'] == '+0.0%') ? Colors.grey : (isDown ? Colors.red : Colors.green);

                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(item['metal'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0B192C))),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text('${item['price']}${item['unit']}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14), textAlign: TextAlign.right),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(color: changeCol.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                          child: Text(item['change'] ?? '', style: TextStyle(color: changeCol, fontWeight: FontWeight.bold, fontSize: 11)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TAB 3: CALCULATOR (WITH VECTOR ICONS)
// ==========================================
class ShapeIconWidget extends StatelessWidget {
  final String shapeName;
  const ShapeIconWidget({super.key, required this.shapeName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: CustomPaint(
        painter: ShapeIconPainter(shapeName),
      ),
    );
  }
}

class ShapeIconPainter extends CustomPainter {
  final String shapeName;
  ShapeIconPainter(this.shapeName);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC37145)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;

    switch (shapeName) {
      case 'Hexagonal Bar':
        final path = Path();
        path.moveTo(cx, 0);
        path.lineTo(w, h * 0.25);
        path.lineTo(w, h * 0.75);
        path.lineTo(cx, h);
        path.lineTo(0, h * 0.75);
        path.lineTo(0, h * 0.25);
        path.close();
        canvas.drawPath(path, paint);
        break;
      case 'Round Bar':
        canvas.drawCircle(Offset(cx, cy), w / 2 - 2, paint);
        break;
      case 'Round Tube':
        canvas.drawCircle(Offset(cx, cy), w / 2 - 2, paint);
        canvas.drawCircle(Offset(cx, cy), (w / 2) * 0.5, paint);
        break;
      case 'Square Bar':
        canvas.drawRect(Rect.fromLTWH(2, 2, w - 4, h - 4), paint);
        break;
      case 'Rectangular Bar':
        canvas.drawRect(Rect.fromLTWH(2, h * 0.25, w - 4, h * 0.5), paint);
        break;
      case 'Rectangular Tube':
        canvas.drawRect(Rect.fromLTWH(2, h * 0.2, w - 4, h * 0.6), paint);
        canvas.drawRect(Rect.fromLTWH(w * 0.2, h * 0.35, w * 0.6, h * 0.3), paint);
        break;
      case 'T-Beam':
        final tf = h * 0.25;
        final tw = w * 0.25;
        final path = Path();
        path.moveTo(0, 0);
        path.lineTo(w, 0);
        path.lineTo(w, tf);
        path.lineTo(cx + tw / 2, tf);
        path.lineTo(cx + tw / 2, h);
        path.lineTo(cx - tw / 2, h);
        path.lineTo(cx - tw / 2, tf);
        path.lineTo(0, tf);
        path.close();
        canvas.drawPath(path, paint);
        break;
      case 'I-Beam / H-Beam':
        final itf = h * 0.2;
        final itw = w * 0.2;
        final path = Path();
        path.moveTo(0, 0);
        path.lineTo(w, 0);
        path.lineTo(w, itf);
        path.lineTo(cx + itw / 2, itf);
        path.lineTo(cx + itw / 2, h - itf);
        path.lineTo(w, h - itf);
        path.lineTo(w, h);
        path.lineTo(0, h);
        path.lineTo(0, h - itf);
        path.lineTo(cx - itw / 2, h - itf);
        path.lineTo(cx - itw / 2, itf);
        path.lineTo(0, itf);
        path.close();
        canvas.drawPath(path, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CalculatorGridScreen extends StatelessWidget {
  const CalculatorGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B192C),
        title: const Text('Metal weight calculator', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('Pick a shape, enter dimensions, get the weight.', style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  _buildShapeCard(context, 'Hexagonal Bar', '0.866025 • W² • L • ρ / 1e6', '2 inputs'),
                  _buildShapeCard(context, 'Round Bar', 'π • (D/2)² • L • ρ / 1e6', '2 inputs'),
                  _buildShapeCard(context, 'Round Tube', 'π • T • (D - T) • L • ρ / 1e6', '3 inputs'),
                  _buildShapeCard(context, 'Square Bar', 'W² • L • ρ / 1e6', '2 inputs'),
                  _buildShapeCard(context, 'Rectangular Bar', 'W • H • L • ρ / 1e6', '3 inputs'),
                  _buildShapeCard(context, 'Rectangular Tube', '2 • T • (W + H - 2T) • L • ρ / 1e6', '4 inputs'),
                  _buildShapeCard(context, 'T-Beam', '((W•Tf) + (H-Tf)•Tw) • L • ρ / 1e6', '5 inputs'),
                  _buildShapeCard(context, 'I-Beam / H-Beam', '((2•W•Tf) + (H-2•Tf)•Tw) • L • ρ / 1e6', '5 inputs'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShapeCard(BuildContext context, String shapeName, String formula, String inputs) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CalculatorDetailScreen(initialShape: shapeName)));
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShapeIconWidget(shapeName: shapeName),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFC37145).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Text(inputs, style: const TextStyle(color: Color(0xFFC37145), fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const Spacer(),
              Text(shapeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0B192C))),
              const SizedBox(height: 4),
              Text(formula, style: TextStyle(fontSize: 8.5, color: Colors.grey.shade500, fontFamily: 'monospace'), overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

class CalculatorDetailScreen extends StatefulWidget {
  final String initialShape;
  const CalculatorDetailScreen({super.key, required this.initialShape});

  @override
  State<CalculatorDetailScreen> createState() => _CalculatorDetailScreenState();
}

class _CalculatorDetailScreenState extends State<CalculatorDetailScreen> {
  late String selectedShape;
  String selectedMetal = 'Copper';
  String lengthUnit = 'mm';

  final dim1Ctrl = TextEditingController(text: '10');
  final dim2Ctrl = TextEditingController(text: '2');
  final dim3Ctrl = TextEditingController(text: '2');
  final dim4Ctrl = TextEditingController(text: '2');
  final lenCtrl = TextEditingController(text: '1000');

  String resultWeight = "0.0000";
  String resultPerMeter = "0.000";

  final List<String> metals = ['Copper', 'Brass', 'Bronze', 'Steel'];
  final List<String> shapes = [
    'Round Tube', 'Round Bar', 'Hexagonal Bar', 'Square Bar',
    'Rectangular Bar', 'Rectangular Tube', 'T-Beam', 'I-Beam / H-Beam'
  ];

  @override
  void initState() {
    super.initState();
    selectedShape = widget.initialShape;
    calculate();
  }

  void calculate() {
    double density = 8.96;
    if (selectedMetal == 'Brass') density = 8.53;
    if (selectedMetal == 'Bronze') density = 8.80;
    if (selectedMetal == 'Steel') density = 7.85;

    double d1 = double.tryParse(dim1Ctrl.text) ?? 0.0;
    double d2 = double.tryParse(dim2Ctrl.text) ?? 0.0;
    double d3 = double.tryParse(dim3Ctrl.text) ?? 0.0;
    double d4 = double.tryParse(dim4Ctrl.text) ?? 0.0;
    double lInput = double.tryParse(lenCtrl.text) ?? 0.0;

    double lMm = 0.0;
    if (lengthUnit == 'mm') lMm = lInput;
    else if (lengthUnit == 'm') lMm = lInput * 1000.0;
    else if (lengthUnit == 'ft') lMm = lInput * 304.8;
    else if (lengthUnit == 'in') lMm = lInput * 25.4;

    double areaMm2 = 0.0;

    switch (selectedShape) {
      case 'Round Bar':
        areaMm2 = 3.14159265 * (d1 / 2) * (d1 / 2);
        break;
      case 'Hexagonal Bar':
        areaMm2 = 0.866025 * d1 * d1;
        break;
      case 'Square Bar':
        areaMm2 = d1 * d1;
        break;
      case 'Rectangular Bar':
        areaMm2 = d1 * d2;
        break;
      case 'Round Tube':
        double innerD = d1 - (2 * d2);
        if (innerD < 0) innerD = 0;
        areaMm2 = 3.14159265 * ((d1 / 2) * (d1 / 2) - (innerD / 2) * (innerD / 2));
        break;
      case 'Rectangular Tube':
        double innerW = d1 - (2 * d3);
        double innerH = d2 - (2 * d3);
        if (innerW < 0) innerW = 0;
        if (innerH < 0) innerH = 0;
        areaMm2 = (d1 * d2) - (innerW * innerH);
        break;
      case 'T-Beam':
        double webH = d2 - d3;
        if (webH < 0) webH = 0;
        areaMm2 = (d1 * d3) + (webH * d4);
        break;
      case 'I-Beam / H-Beam':
        double webH = d2 - (2 * d3);
        if (webH < 0) webH = 0;
        areaMm2 = (2 * d1 * d3) + (webH * d4);
        break;
    }

    double volumeMm3 = areaMm2 * lMm;
    double volumeCm3 = volumeMm3 / 1000.0;
    double weightKg = (volumeCm3 * density) / 1000.0;
    double weightPerMKg = (areaMm2 * density) / 1000.0;

    setState(() {
      resultWeight = weightKg.toStringAsFixed(4);
      resultPerMeter = weightPerMKg.toStringAsFixed(3);
    });
  }

  @override
  Widget build(BuildContext context) {
    String lbl1 = ''; String lbl2 = ''; String lbl3 = ''; String lbl4 = '';
    bool show2 = false; bool show3 = false; bool show4 = false;

    if (selectedShape == 'Round Bar') {
      lbl1 = 'Diameter D (mm)';
    } else if (selectedShape == 'Square Bar') {
      lbl1 = 'Side Width (mm)';
    } else if (selectedShape == 'Hexagonal Bar') {
      lbl1 = 'Across Flats (mm)';
    } else if (selectedShape == 'Rectangular Bar') {
      lbl1 = 'Width W (mm)'; lbl2 = 'Height H (mm)'; show2 = true;
    } else if (selectedShape == 'Round Tube') {
      lbl1 = 'Outer Diameter D (mm)'; lbl2 = 'Wall Thickness T (mm)'; show2 = true;
    } else if (selectedShape == 'Rectangular Tube') {
      lbl1 = 'Width W (mm)'; lbl2 = 'Height H (mm)'; lbl3 = 'Wall Thickness T (mm)'; show2 = true; show3 = true;
    } else if (selectedShape == 'T-Beam' || selectedShape == 'I-Beam / H-Beam') {
      lbl1 = 'Width W (mm)'; lbl2 = 'Height H (mm)'; lbl3 = 'Flange Thickness Tf (mm)'; lbl4 = 'Web Thickness Tw (mm)'; show2 = true; show3 = true; show4 = true;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B192C),
        title: const Text('Back to shapes', style: TextStyle(color: Colors.white, fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('1. SELECT MATERIAL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: metals.map((metal) {
                    bool isSelected = selectedMetal == metal;
                    return ChoiceChip(
                      label: Text(metal, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.bold)),
                      selected: isSelected,
                      selectedColor: const Color(0xFFC37145),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: isSelected ? const Color(0xFFC37145) : Colors.grey.shade300)),
                      showCheckmark: false,
                      onSelected: (val) {
                        setState(() {
                          selectedMetal = metal;
                          calculate();
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                const Text('2. SELECT SHAPE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: shapes.map((shape) {
                    bool isSelected = selectedShape == shape;
                    return ChoiceChip(
                      label: Text(shape, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.bold)),
                      selected: isSelected,
                      selectedColor: const Color(0xFF0B192C),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: isSelected ? const Color(0xFF0B192C) : Colors.grey.shade300)),
                      showCheckmark: false,
                      onSelected: (val) {
                        setState(() {
                          selectedShape = shape;
                          calculate();
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                const Text('3. ENTER DIMENSIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0)),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(lbl1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0B192C))),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: dim1Ctrl,
                                    onChanged: (v) => calculate(),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: const EdgeInsets.symmetric(horizontal: 12)),
                                  ),
                                ],
                              ),
                            ),
                            if (show2) ...[
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(lbl2, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0B192C))),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: dim2Ctrl,
                                      onChanged: (v) => calculate(),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: const EdgeInsets.symmetric(horizontal: 12)),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          ],
                        ),
                        if (show3) ...[
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(lbl3, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0B192C))),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: dim3Ctrl,
                                      onChanged: (v) => calculate(),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: const EdgeInsets.symmetric(horizontal: 12)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: show4
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(lbl4, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0B192C))),
                                          const SizedBox(height: 8),
                                          TextField(
                                            controller: dim4Ctrl,
                                            onChanged: (v) => calculate(),
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: const EdgeInsets.symmetric(horizontal: 12)),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          )
                        ],
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Total Length L', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0B192C))),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: lenCtrl,
                                    onChanged: (v) => calculate(),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: const EdgeInsets.symmetric(horizontal: 12)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Unit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0B192C))),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: ['mm', 'm', 'ft', 'in'].map((unit) {
                                      bool isSelected = lengthUnit == unit;
                                      return ChoiceChip(
                                        label: Text(unit, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.bold)),
                                        selected: isSelected,
                                        selectedColor: const Color(0xFF0B192C),
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: isSelected ? const Color(0xFF0B192C) : Colors.grey.shade300)),
                                        showCheckmark: false,
                                        onSelected: (val) {
                                          setState(() {
                                            lengthUnit = unit;
                                            calculate();
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: const Color(0xFFC37145).withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFC37145).withOpacity(0.3))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Total Weight', style: TextStyle(color: Color(0xFFC37145), fontWeight: FontWeight.bold)),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(resultWeight, style: const TextStyle(fontSize: 32, color: Color(0xFF8B4513), fontWeight: FontWeight.w400)),
                                      const Text(' kg', style: TextStyle(fontSize: 24, color: Color(0xFF8B4513))),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('Per meter', style: TextStyle(color: Color(0xFFC37145), fontSize: 12, fontWeight: FontWeight.bold)),
                                  Text('$resultPerMeter kg/m', style: const TextStyle(color: Color(0xFF8B4513), fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// TAB 4: TECH DATA MENU
// ==========================================
class TechDataScreen extends StatelessWidget {
  const TechDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B192C),
        title: const Text('Technical data', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Standards, dimensions, working pressures', style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 16),
          _buildSpecCard(
            context,
            title: 'ASTM B280 Copper Tube for Air Conditioning and Refrigeration (ACR) - Dimensions',
            subtitle: 'Inches • updated 05 Jul 2026',
            headers: ['SIZE', 'PRICE/FT', 'PRICE/MTR', 'PRICE/EA', 'WALL THK'],
            rows: [
              _TechRow(size: '1/4"', sub: '20G', col1: '₹62', col2: '₹203', col3: '₹610', col4: '0.030"'),
              _TechRow(size: '3/8"', sub: '20G', col1: '₹95', col2: '₹311', col3: '₹935', col4: '0.032"'),
              _TechRow(size: '1/2"', sub: '19G', col1: '₹138', col2: '₹452', col3: '₹1,356', col4: '0.032"'),
              _TechRow(size: '5/8"', sub: '19G', col1: '₹178', col2: '₹584', col3: '₹1,752', col4: '0.035"'),
              _TechRow(size: '3/4"', sub: '18G', col1: '₹242', col2: '₹793', col3: '₹2,380', col4: '0.035"'),
              _TechRow(size: '7/8"', sub: '18G', col1: '₹298', col2: '₹977', col3: '₹2,932', col4: '0.045"'),
              _TechRow(size: '1"', sub: '19G', col1: '₹313', col2: '₹995', col3: '₹3,038', col4: '0.050"'),
              _TechRow(size: '1 1/8"', sub: '19G', col1: '₹340', col2: '₹1,114', col3: '₹3,396', col4: '0.050"'),
              _TechRow(size: '1 1/4"', sub: '18.5G', col1: '₹420', col2: '₹1,342', col3: '₹4,114', col4: '0.055"'),
              _TechRow(size: '1 3/8"', sub: '18G', col1: '₹495', col2: '₹1,634', col3: '₹4,953', col4: '0.055"'),
              _TechRow(size: '1 1/2"', sub: '17.5G', col1: '₹590', col2: '₹1,920', col3: '₹5,812', col4: '0.060"'),
              _TechRow(size: '1 5/8"', sub: '17G', col1: '₹686', col2: '₹2,256', col3: '₹6,863', col4: '0.060"'),
              _TechRow(size: '1 3/4"', sub: '16G', col1: '₹852', col2: '₹2,769', col3: '₹8,429', col4: '0.065"'),
            ],
          ),
          _buildSpecCard(
            context,
            title: 'ASTM B280 Copper Tube for Air Conditioning and Refrigeration (ACR) - Dimensions (MM)',
            subtitle: 'mm • updated 05 Jul 2026',
            headers: ['SIZE (OD)', 'PRICE/FT', 'PRICE/MTR', 'PRICE/EA', 'WALL (MM)'],
            rows: [
              _TechRow(size: '6.35 mm', sub: '1/4"', col1: '₹62', col2: '₹203', col3: '₹610', col4: '0.76 mm'),
              _TechRow(size: '9.52 mm', sub: '3/8"', col1: '₹95', col2: '₹311', col3: '₹935', col4: '0.81 mm'),
              _TechRow(size: '12.70 mm', sub: '1/2"', col1: '₹138', col2: '₹452', col3: '₹1,356', col4: '0.81 mm'),
              _TechRow(size: '15.87 mm', sub: '5/8"', col1: '₹178', col2: '₹584', col3: '₹1,752', col4: '0.89 mm'),
              _TechRow(size: '19.05 mm', sub: '3/4"', col1: '₹242', col2: '₹793', col3: '₹2,380', col4: '0.89 mm'),
              _TechRow(size: '22.22 mm', sub: '7/8"', col1: '₹298', col2: '₹977', col3: '₹2,932', col4: '1.14 mm'),
              _TechRow(size: '28.57 mm', sub: '1 1/8"', col1: '₹340', col2: '₹1,114', col3: '₹3,396', col4: '1.27 mm'),
              _TechRow(size: '34.92 mm', sub: '1 3/8"', col1: '₹495', col2: '₹1,634', col3: '₹4,953', col4: '1.40 mm'),
              _TechRow(size: '41.27 mm', sub: '1 5/8"', col1: '₹686', col2: '₹2,256', col3: '₹6,863', col4: '1.52 mm'),
            ],
          ),
          _buildSpecCard(
            context,
            title: 'ASTM B280 Copper Tube for Air Conditioning (ACR) - Working Pressures',
            subtitle: 'psi • updated 05 Jul 2026',
            headers: ['SIZE', 'R410A PSI', 'MAX PSI', 'PRICE/MTR', 'BURST PSI'],
            rows: [
              _TechRow(size: '1/4"', sub: '0.030"', col1: '700 psi', col2: '890 psi', col3: '₹203', col4: '4,450 psi'),
              _TechRow(size: '3/8"', sub: '0.032"', col1: '700 psi', col2: '740 psi', col3: '₹311', col4: '3,700 psi'),
              _TechRow(size: '1/2"', sub: '0.032"', col1: '700 psi', col2: '710 psi', col3: '₹452', col4: '3,550 psi'),
              _TechRow(size: '5/8"', sub: '0.035"', col1: '650 psi', col2: '700 psi', col3: '₹584', col4: '3,500 psi'),
              _TechRow(size: '3/4"', sub: '0.035"', col1: '600 psi', col2: '650 psi', col3: '₹793', col4: '3,250 psi'),
              _TechRow(size: '7/8"', sub: '0.045"', col1: '600 psi', col2: '620 psi', col3: '₹977', col4: '3,100 psi'),
              _TechRow(size: '1 1/8"', sub: '0.050"', col1: '550 psi', col2: '580 psi', col3: '₹1,114', col4: '2,900 psi'),
              _TechRow(size: '1 3/8"', sub: '0.055"', col1: '500 psi', col2: '530 psi', col3: '₹1,634', col4: '2,650 psi'),
            ],
          ),
          _buildSpecCard(
            context,
            title: 'ASTM B88 - Seamless Copper Water Tubes - Dimensions - Type K => In Inches',
            subtitle: 'inches • updated 05 Jul 2026',
            headers: ['NOMINAL', 'PRICE/FT', 'PRICE/MTR', 'PRICE/EA', 'ACTUAL O.D.'],
            rows: [
              _TechRow(size: '3/8"', sub: 'Heavy Wall', col1: '₹115', col2: '₹377', col3: '₹1,131', col4: '0.500"'),
              _TechRow(size: '1/2"', sub: 'Heavy Wall', col1: '₹165', col2: '₹541', col3: '₹1,623', col4: '0.625"'),
              _TechRow(size: '3/4"', sub: 'Heavy Wall', col1: '₹280', col2: '₹918', col3: '₹2,754', col4: '0.875"'),
              _TechRow(size: '1"', sub: 'Heavy Wall', col1: '₹395', col2: '₹1,295', col3: '₹3,885', col4: '1.125"'),
              _TechRow(size: '1 1/4"', sub: 'Heavy Wall', col1: '₹520', col2: '₹1,705', col3: '₹5,115', col4: '1.375"'),
              _TechRow(size: '1 1/2"', sub: 'Heavy Wall', col1: '₹710', col2: '₹2,328', col3: '₹6,984', col4: '1.625"'),
              _TechRow(size: '2"', sub: 'Heavy Wall', col1: '₹1,180', col2: '₹3,870', col3: '₹11,610', col4: '2.125"'),
            ],
          ),
          _buildSpecCard(
            context,
            title: 'ASTM B88 - Seamless Copper Water Tubes - Dimensions - Type K => MM',
            subtitle: 'mm • updated 05 Jul 2026',
            headers: ['SIZE (OD)', 'PRICE/FT', 'PRICE/MTR', 'PRICE/EA', 'WALL (MM)'],
            rows: [
              _TechRow(size: '15.0 mm', sub: 'Type K', col1: '₹152', col2: '₹498', col3: '₹1,494', col4: '1.20 mm'),
              _TechRow(size: '22.0 mm', sub: 'Type K', col1: '₹265', col2: '₹869', col3: '₹2,607', col4: '1.20 mm'),
              _TechRow(size: '28.0 mm', sub: 'Type K', col1: '₹375', col2: '₹1,230', col3: '₹3,690', col4: '1.20 mm'),
              _TechRow(size: '35.0 mm', sub: 'Type K', col1: '₹540', col2: '₹1,771', col3: '₹5,313', col4: '1.50 mm'),
              _TechRow(size: '42.0 mm', sub: 'Type K', col1: '₹760', col2: '₹2,493', col3: '₹7,479', col4: '1.50 mm'),
              _TechRow(size: '54.0 mm', sub: 'Type K', col1: '₹1,120', col2: '₹3,674', col3: '₹11,022', col4: '2.00 mm'),
            ],
          ),
          _buildSpecCard(
            context,
            title: 'ASTM B88 - Seamless Copper Water Tubes - Dimensions - Type L (inches)',
            subtitle: 'inches • updated 05 Jul 2026',
            headers: ['NOMINAL', 'PRICE/FT', 'PRICE/MTR', 'PRICE/EA', 'WALL THK'],
            rows: [
              _TechRow(size: '3/8"', sub: 'Med Wall', col1: '₹98', col2: '₹321', col3: '₹963', col4: '0.035"'),
              _TechRow(size: '1/2"', sub: 'Med Wall', col1: '₹142', col2: '₹465', col3: '₹1,395', col4: '0.040"'),
              _TechRow(size: '3/4"', sub: 'Med Wall', col1: '₹235', col2: '₹770', col3: '₹2,310', col4: '0.045"'),
              _TechRow(size: '1"', sub: 'Med Wall', col1: '₹345', col2: '₹1,131', col3: '₹3,393', col4: '0.050"'),
              _TechRow(size: '1 1/4"', sub: 'Med Wall', col1: '₹440', col2: '₹1,443', col3: '₹4,329', col4: '0.055"'),
              _TechRow(size: '1 1/2"', sub: 'Med Wall', col1: '₹590', col2: '₹1,935', col3: '₹5,805', col4: '0.060"'),
              _TechRow(size: '2"', sub: 'Med Wall', col1: '₹960', col2: '₹3,149', col3: '₹9,447', col4: '0.070"'),
            ],
          ),
          _buildSpecCard(
            context,
            title: 'ASTM B88 - Seamless Copper Water Tubes - Dimensions - Type M (inches)',
            subtitle: 'inches • updated 05 Jul 2026',
            headers: ['NOMINAL', 'PRICE/FT', 'PRICE/MTR', 'PRICE/EA', 'WALL THK'],
            rows: [
              _TechRow(size: '3/8"', sub: 'Light Wall', col1: '₹78', col2: '₹255', col3: '₹765', col4: '0.025"'),
              _TechRow(size: '1/2"', sub: 'Light Wall', col1: '₹110', col2: '₹360', col3: '₹1,080', col4: '0.028"'),
              _TechRow(size: '3/4"', sub: 'Light Wall', col1: '₹175', col2: '₹574', col3: '₹1,722', col4: '0.032"'),
              _TechRow(size: '1"', sub: 'Light Wall', col1: '₹260', col2: '₹852', col3: '₹2,556', col4: '0.035"'),
              _TechRow(size: '1 1/4"', sub: 'Light Wall', col1: '₹350', col2: '₹1,148', col3: '₹3,444', col4: '0.042"'),
              _TechRow(size: '1 1/2"', sub: 'Light Wall', col1: '₹480', col2: '₹1,574', col3: '₹4,722', col4: '0.049"'),
              _TechRow(size: '2"', sub: 'Light Wall', col1: '₹760', col2: '₹2,493', col3: '₹7,479', col4: '0.058"'),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSpecCard(BuildContext context, {
    required String title,
    required String subtitle,
    required List<String> headers,
    required List<_TechRow> rows,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Push to the new dedicated detail screen!
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TechDataDetailScreen(
                title: title,
                subtitle: subtitle,
                headers: headers,
                rows: rows,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFC37145).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.layers, color: Color(0xFFC37145)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0B192C), fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// NEW: DEDICATED TECH DATA POP-OUT SCREEN
// ==========================================
class TechDataDetailScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> headers;
  final List<_TechRow> rows;

  const TechDataDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.headers,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B192C),
        title: const Text('Back to standards', style: TextStyle(color: Colors.white, fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0B192C), fontSize: 16)),
                const SizedBox(height: 6),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12, top: 4),
                        child: Row(
                          children: [
                            SizedBox(width: 110, child: Text(headers[0], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 11, letterSpacing: 0.5))),
                            SizedBox(width: 95, child: Text(headers[1], textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 11, letterSpacing: 0.5))),
                            SizedBox(width: 105, child: Text(headers[2], textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 11, letterSpacing: 0.5))),
                            SizedBox(width: 105, child: Text(headers[3], textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 11, letterSpacing: 0.5))),
                            SizedBox(width: 95, child: Text(headers[4], textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 11, letterSpacing: 0.5))),
                          ],
                        ),
                      ),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFEBEFF4)),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: rows.map((r) => Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 110,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(r.size, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0B192C))),
                                                const SizedBox(height: 4),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.08), borderRadius: BorderRadius.circular(4)),
                                                  child: Text(r.sub, style: TextStyle(fontSize: 10, color: Colors.blueGrey.shade700, fontWeight: FontWeight.bold)),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 95, child: Text(r.col1, textAlign: TextAlign.right, style: const TextStyle(fontSize: 13, color: Color(0xFF2C3E50), fontWeight: FontWeight.w600))),
                                          SizedBox(width: 105, child: Text(r.col2, textAlign: TextAlign.right, style: const TextStyle(fontSize: 13, color: Color(0xFF2C3E50), fontWeight: FontWeight.w600))),
                                          SizedBox(width: 105, child: Text(r.col3, textAlign: TextAlign.right, style: const TextStyle(fontSize: 13, color: Color(0xFF2C3E50), fontWeight: FontWeight.w700))),
                                          SizedBox(width: 95, child: Text(r.col4, textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500))),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 1, thickness: 1, color: Color(0xFFF1F3F5)),
                                  ],
                                )).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _TechRow {
  final String size;
  final String sub;
  final String col1;
  final String col2;
  final String col3;
  final String col4;

  const _TechRow({
    required this.size,
    required this.sub,
    required this.col1,
    required this.col2,
    required this.col3,
    required this.col4,
  });
}