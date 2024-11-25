import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller.dart';

class AnimatedIconsView extends ConsumerWidget {
  const AnimatedIconsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the state from the provider
    final viewState = ref.watch(viewStateProvider);
    final viewController = ref.read(viewStateProvider.notifier);

    return Padding(
      padding: const EdgeInsets.only(left: 400),
      child: Center(
        child: SizedBox(
          height: 100,
          // Adjust the height for the grid
          child:AnimatedReorderableGridView(
            items: List.generate(
              viewState.items.length,
                  (index) => Key('$index'), // Use unique keys for reordering
            ),
            scrollDirection: Axis.vertical,
            sliverGridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10, // Number of items per row
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            onReorder: (oldIndex, newIndex) {
              // Call the controller's reorder function
              viewController.reorderItems(oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              final icon = viewState.items[index];

              return Card(
                key: Key('$index'), // Ensure a key is provided
                color: Colors.white, // Ensure a consistent background color
                shadowColor: Colors.transparent, // Remove shadow effects
                elevation: 0, // Disable elevation for flat appearance
                child: _buildIconWidget(icon),
              );
            },
            enterTransition: [FadeIn(), ScaleIn()],
            insertDuration: const Duration(milliseconds: 200),
            removeDuration: const Duration(milliseconds: 200),
          ),

        ),
      ),
    );
  }

  /// Helper method to build the icon widget
  Widget _buildIconWidget(IconData icon) {
    return Container(
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

