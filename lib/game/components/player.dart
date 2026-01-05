import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';

/// The player character in the puzzle game.
class Player extends SpriteAnimationComponent with TapCallbacks, CollisionCallbacks {
  /// The player's current health/lives.
  int _health = 3;

  /// The player's current score.
  int _score = 0;

  /// Constructs a new [Player] instance.
  Player({
    required Vector2 position,
    required Vector2 size,
    required SpriteAnimation idleAnimation,
    required SpriteAnimation walkingAnimation,
    required SpriteAnimation jumpingAnimation,
  }) : super(
          position: position,
          size: size,
          animation: idleAnimation,
        );

  @override
  void onTapDown(TapDownInfo info) {
    // Handle player input, such as jumping.
    _jump();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // Handle player collisions, such as taking damage.
    _takeDamage();
  }

  /// Moves the player.
  void _move(Vector2 direction) {
    // Apply physics-based movement to the player.
    position += direction;
  }

  /// Jumps the player.
  void _jump() {
    // Apply a jump force to the player.
    // Update the player's animation to the jumping state.
  }

  /// Decrements the player's health.
  void _takeDamage() {
    _health--;
    if (_health <= 0) {
      // Handle player death.
    }
  }

  /// Increments the player's score.
  void _increaseScore(int amount) {
    _score += amount;
    // Update the game's score display.
  }
}