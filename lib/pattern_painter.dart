import 'package:flutter/material.dart';

class PatternPainter extends CustomPainter {
  final List<int> selectedNodes;
  final Offset? currentPosition;
  final bool isDragging;

  PatternPainter({
    required this.selectedNodes,
    required this.currentPosition,
    required this.isDragging,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double nodeSize = size.width / 3;
    final double defaultRadius = nodeSize * 0.22;
    final double activeRadius = nodeSize * 0.28;

    // Paints
    final Paint defaultNodePaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..style = PaintingStyle.fill;

    final Paint activeNodePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint glowPaint = Paint()
      ..color = const Color(0xFF4FC3F7).withValues(alpha: 0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12.0)
      ..style = PaintingStyle.fill;

    final Paint outerGlowPaint = Paint()
      ..color = const Color(0xFF0288D1).withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25.0)
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = const Color(0xFF4FC3F7)
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final Paint lineGlowPaint = Paint()
      ..color = const Color(0xFF4FC3F7).withValues(alpha: 0.5)
      ..strokeWidth = 16.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0)
      ..style = PaintingStyle.stroke;

    List<Offset> nodeCenters = [];

    // Calculate all node centers
    for (int i = 0; i < 9; i++) {
      int row = i ~/ 3;
      int col = i % 3;
      double cx = (col + 0.5) * nodeSize;
      double cy = (row + 0.5) * nodeSize;
      nodeCenters.add(Offset(cx, cy));
    }

    // Draw lines between selected nodes
    if (selectedNodes.isNotEmpty) {
      Path path = Path();
      path.moveTo(
        nodeCenters[selectedNodes[0]].dx,
        nodeCenters[selectedNodes[0]].dy,
      );

      for (int i = 1; i < selectedNodes.length; i++) {
        path.lineTo(
          nodeCenters[selectedNodes[i]].dx,
          nodeCenters[selectedNodes[i]].dy,
        );
      }

      // Draw line to current drag position
      if (isDragging && currentPosition != null) {
        path.lineTo(currentPosition!.dx, currentPosition!.dy);
      }

      canvas.drawPath(path, lineGlowPaint);
      canvas.drawPath(path, linePaint);
    }

    // Draw all nodes
    for (int i = 0; i < 9; i++) {
      final center = nodeCenters[i];
      final isSelected = selectedNodes.contains(i);

      if (isSelected) {
        // Draw glow effects
        canvas.drawCircle(center, activeRadius + 5, glowPaint);
        canvas.drawCircle(center, activeRadius + 15, outerGlowPaint);
        // Draw active node
        canvas.drawCircle(center, activeRadius, activeNodePaint);
      } else {
        // Draw default node
        canvas.drawCircle(center, defaultRadius, defaultNodePaint);
      }
    }

    // Draw touch feedback indicator
    if (isDragging && currentPosition != null && selectedNodes.isNotEmpty) {
      canvas.drawCircle(
        currentPosition!,
        activeRadius * 1.5,
        Paint()..color = Colors.white.withValues(alpha: 0.1),
      );
      canvas.drawCircle(
        currentPosition!,
        activeRadius * 0.5,
        Paint()..color = const Color(0xFF0288D1),
      );
    }
  }

  @override
  bool shouldRepaint(covariant PatternPainter oldDelegate) {
    return oldDelegate.selectedNodes != selectedNodes ||
        oldDelegate.currentPosition != currentPosition ||
        oldDelegate.isDragging != isDragging;
  }
}
