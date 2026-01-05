/// Mechanic Components
/// 
/// Auto-generated components for game mechanics.

import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';


class CollidableComponent extends PositionComponent with CollisionCallbacks {
  final List<String> collidesWith;
  
  CollidableComponent({
    required Vector2 position,
    required Vector2 size,
    this.collidesWith = const [],
  }) : super(position: position, size: size);
  
  @override
  Future<void> onLoad() async {
    await add(RectangleHitbox());
  }
  
  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    handleCollision(other);
  }
  
  void handleCollision(PositionComponent other) {
    // Override in subclass
  }
}

