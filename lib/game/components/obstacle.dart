import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/painting.dart';

/// Represents an obstacle in the puzzle game.
class Obstacle extends PositionComponent with CollisionCallbacks {
  /// The speed at which the obstacle moves.
  final double _speed;

  /// The damage dealt to the player upon collision.
  final int _damage;

  /// The sprite or shape representing the obstacle.
  final Sprite _sprite;

  /// Creates a new instance of the [Obstacle] class.
  ///
  /// [position]: The initial position of the obstacle.
  /// [size]: The size of the obstacle.
  /// [speed]: The speed at which the obstacle moves.
  /// [damage]: The damage dealt to the player upon collision.
  /// [sprite]: The sprite or shape representing the obstacle.
  Obstacle({
    required Vector2 position,
    required Vector2 size,
    required double speed,
    required int damage,
    required Sprite sprite,
  })  : _speed = speed,
        _damage = damage,
        _sprite = sprite,
        super(position: position, size: size);

  @override
  void onMount() {
    super.onMount();
    addShape(HitboxShape.rectangle(size: size));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= _speed * dt;

    // Respawn the obstacle if it goes off-screen
    if (position.x < -size.x) {
      position.x = parent!.size.x + size.x;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    // Handle collision with the player or other game objects
    if (other is Player) {
      other.takeDamage(_damage);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _sprite.render(canvas, position: position, size: size);
  }
}