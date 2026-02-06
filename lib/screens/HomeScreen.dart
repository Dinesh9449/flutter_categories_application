import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_categories_application/models/homecategorymodel.dart';
import 'package:flutter_categories_application/services/homecategoryservices.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with TickerProviderStateMixin {
  int selectedIndex = -1;

  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF772D8E), // top purple
              Color(0xFF2E0F6E),
            ],
            begin: Alignment.topLeft, // starts from top
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<HomeCategoriesModel?>(
          future: Homecategoryservices.fetchHomeCategories(),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.data?.record?.categories == null) {
              return const Center(
                child: Text(
                  'Failed to load categories',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            final categories = snapshot.data!.record!.categories!;
            return buildCircularUI(context, categories);
          },
        ),
      ),
    );
  }

  Widget buildCircularUI(BuildContext context, List<Categories> categories) {
    const double categoryRadius = 130;
    const double canvasSize = 360;

    return Center(
      child: SizedBox(
        width: 360,
        height: 360,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(canvasSize, canvasSize),
              painter: RadialRayPainter(
                itemCount: categories.length,
                innerRadius: 55,
                outerRadius: categoryRadius - 5,
              ),
            ),
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.deepPurple,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.home, color: Colors.white, size: 30),
                  SizedBox(height: 4),
                  Text('Home', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            for (int i = 0; i < categories.length; i++)
              buildCategoryItem(
                categories[i],
                i,
                categories.length,
                categoryRadius,
                Size(canvasSize, canvasSize),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryItem(
    Categories category,
    int index,
    int total,
    double radius,
    Size size,
  ) {
    final double angle = (2 * pi / total) * index;
    final bool isSelected = selectedIndex == index;
    final center = Offset(size.width / 2, size.height / 2);

    final Offset position = Offset(
      center.dx + radius * cos(angle),
      center.dy + radius * sin(angle),
    );

    return Positioned(
      left: position.dx - 42,
      top: position.dy - 42,
      child: Semantics(
        label: category.name ?? 'Category',
        button: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: CircleAvatar(
            radius: 42,
            backgroundColor: isSelected
                ? Colors.deepPurple.shade50
                : Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  category.image ?? '',
                  height: 28,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
                const SizedBox(height: 6),
                Text(
                  category.name ?? '',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RadialRayPainter extends CustomPainter {
  final int itemCount;
  final double innerRadius;
  final double outerRadius;

  RadialRayPainter({
    required this.itemCount,
    required this.innerRadius,
    required this.outerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final angleStep = (2 * pi) / itemCount;
    final rayWidth = angleStep * 0.75;

    for (int i = 0; i < itemCount; i++) {
      final angle = angleStep * i;

      final innerLeft = Offset(
        center.dx + innerRadius * cos(angle - rayWidth / 5),
        center.dy + innerRadius * sin(angle - rayWidth / 5),
      );

      final innerRight = Offset(
        center.dx + innerRadius * cos(angle + rayWidth / 5),
        center.dy + innerRadius * sin(angle + rayWidth / 5),
      );

      final outerLeft = Offset(
        center.dx + outerRadius * cos(angle - rayWidth / 2),
        center.dy + outerRadius * sin(angle - rayWidth / 2),
      );

      final outerRight = Offset(
        center.dx + outerRadius * cos(angle + rayWidth / 2),
        center.dy + outerRadius * sin(angle + rayWidth / 2),
      );

      final path = Path()
        ..moveTo(innerLeft.dx, innerLeft.dy)
        ..lineTo(outerLeft.dx, outerLeft.dy)
        ..lineTo(outerRight.dx, outerRight.dy)
        ..lineTo(innerRight.dx, innerRight.dy)
        ..close();

      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.45),
            Colors.white.withOpacity(0.12),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: outerRadius));

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RadialLinePainter extends CustomPainter {
  final int itemCount;
  final double radius;

  RadialLinePainter({required this.itemCount, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < itemCount; i++) {
      final angle = (2 * pi / itemCount) * i;

      final endPoint = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      canvas.drawLine(center, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
