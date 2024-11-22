import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This class holds the state of the icons and their positions.
class ViewState {
  final List<IconData> items;
  final List<double> positions;

  const ViewState({
    required this.items,
    required this.positions,
  });

  /// Initial state constructor
  factory ViewState.init() {
    return ViewState(
      items: [
        Icons.person,
        Icons.message,
        Icons.call,
        Icons.camera,
        Icons.photo,
      ],
      positions: List.generate(
          5, (index) => index * 80.0), // 5 items, spaced 80 pixels apart
    );
  }

  /// Copy with method to update only the parts of the state that need changing
  ViewState copyWith({List<IconData>? items, List<double>? positions}) {
    return ViewState(
      items: items ?? this.items,
      positions: positions ?? this.positions,
    );
  }
}

/// The controller that handles state updates related to dragging and reordering icons.
class ViewStateController extends StateNotifier<ViewState> {
  ViewStateController() : super(ViewState.init());

  /// Handle the dragging logic, updating the positions of icons.
  void onDrag({
    required DragUpdateDetails details,
    required int index,
  }) {
    // Make a copy of the current positions to avoid direct mutation
    List<double> updatedPositions = List.from(state.positions);

    // Apply the drag delta to the current position of the dragged item
    updatedPositions[index] += details.primaryDelta ?? 0.0;

    // Check if any item is close to the dragged item to trigger reorder
    // You should only reorder when the dragged item moves past other items.
    for (int i = 0; i < updatedPositions.length; i++) {
      if (i != index &&
          (updatedPositions[index] - updatedPositions[i]).abs() < 40) {
        // If positions are close enough, reorder the items
        reorderItems(index, i);
        // No need to reset positions, just stop the loop after reordering
        break;
      }
    }

    // Update the state with the new positions after the drag update.
    state = state.copyWith(positions: updatedPositions);
  }

  /// Helper method to reorder items
  void reorderItems(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 0; // Adjust for item removal
    final updatedItems = List<IconData>.from(state.items);
    final item = updatedItems.removeAt(oldIndex);
    updatedItems.insert(newIndex, item);
    state = state.copyWith(items: updatedItems);
  }

  /// Reset the positions of the items to their default state
  void resetPositions() {
    state = state.copyWith(
        positions: List.generate(
            5, (index) => index * 80.0)); // Reset to initial positions
  }
}

/// Riverpod provider to access and manage the view state
final viewStateProvider = StateNotifierProvider<ViewStateController, ViewState>(
      (ref) => ViewStateController(),
);
