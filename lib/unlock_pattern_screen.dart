import 'package:flutter/material.dart';
import 'pattern_painter.dart';

class UnlockPatternScreen extends StatefulWidget {
  const UnlockPatternScreen({super.key});

  @override
  State<UnlockPatternScreen> createState() => _UnlockPatternScreenState();
}

class _UnlockPatternScreenState extends State<UnlockPatternScreen> {
  final List<int> _selectedNodes = [];
  Offset? _currentDragPosition;
  bool _isDragging = false;

  final GlobalKey _gridKey = GlobalKey();

  // Screen layout constants
  static const Color bgColor = Color(0xFF121B22);

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _selectedNodes.clear();
      _isDragging = true;
      _currentDragPosition = details.localPosition;
    });
    _detectNodeCollision(details.localPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentDragPosition = details.localPosition;
    });
    _detectNodeCollision(details.localPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
      _currentDragPosition = null;
    });
  }

  void _detectNodeCollision(Offset position) {
    final RenderBox? renderBox =
        _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Size size = renderBox.size;
    final double nodeSize = size.width / 3;
    final double hitRadius = nodeSize * 0.45; // hit area radius

    for (int i = 0; i < 9; i++) {
      if (_selectedNodes.contains(i)) continue;

      int row = i ~/ 3;
      int col = i % 3;

      double cx = (col + 0.5) * nodeSize;
      double cy = (row + 0.5) * nodeSize;

      if ((position - Offset(cx, cy)).distance <= hitRadius) {
        setState(() {
          _selectedNodes.add(i);
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            _buildHeader(),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: GestureDetector(
                      onPanStart: _onPanStart,
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: _onPanEnd,
                      child: Container(
                        key: _gridKey,
                        color: Colors.transparent,
                        child: CustomPaint(
                          painter: PatternPainter(
                            selectedNodes: _selectedNodes,
                            currentPosition: _currentDragPosition,
                            isDragging: _isDragging,
                          ),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'Draw your\nunlock pattern',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
    );
  }
}
