import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller.dart';

class AnimatedIconsView extends ConsumerStatefulWidget {
  const AnimatedIconsView({Key? key}) : super(key: key);

  @override
  ConsumerState<AnimatedIconsView> createState() => _AnimatedIconsViewState();
}

class _AnimatedIconsViewState extends ConsumerState<AnimatedIconsView> {
  @override
  Widget build(BuildContext context) {
    // Watch the viewStateProvider to get the current state (items and their positions)
    final viewState = ref.watch(viewStateProvider);

    return Center(
      child: SizedBox(
        height: 80,
        width: 500,
        child: Stack(
          children: viewState.items.asMap().entries.map((entry) {
            final index = entry.key;
            final icon = entry.value;

            return AnimatedPositioned(
              key: ValueKey(icon),
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              left: viewState.positions[index],
              top: 10.0,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  // Trigger the drag logic via the controller
                  ref.read(viewStateProvider.notifier).onDrag(
                    details: details,
                    index: index,
                  );
                },
                onHorizontalDragEnd: (_) {
                  // Call the reset method to reset positions after dragging ends
                  ref.read(viewStateProvider.notifier).resetPositions();
                },
                child: _buildIconWidget(icon, 60, 60),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Helper method to build the icon widget with a background and centered icon
  Widget _buildIconWidget(IconData icon, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.primaries[icon.hashCode % Colors.primaries.length],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }
}