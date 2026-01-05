import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';

/// The Player component for the puzzle game.
class Player extends SpriteAnimationComponent with HasHitboxes, Collidable {
  /// The player's current health.
  int _health = 100;

  /// The maximum health the player can have.
  final int maxHealth = 100;

  /// The duration of the player's invulnerability frames after taking damage.
  final double invulnerabilityDuration = 2.0;

  /// The timer for the player's invulnerability frames.
  double _invulnerabilityTimer = 0.0;

  /// Whether the player is currently invulnerable.
  bool get isInvulnerable => _invulnerabilityTimer > 0.0;

  /// Constructs a new Player instance.
  Player(Vector2 position, Vector2 size, SpriteAnimation animation)
      : super(
          position: position,
          size: size,
          animation: animation,
        ) {
    addHitbox(HitboxRectangle());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update invulnerability timer
    if (_invulnerabilityTimer > 0.0) {
      _invulnerabilityTimer -= dt;
    }
  }

  /// Damages the player, reducing their health.
  /// Returns true if the player was damaged, false if they were invulnerable.
  bool takeDamage(int amount) {
    if (isInvulnerable) {
      return false;
    }

    _health = (_health - amount).clamp(0, maxHealth);
    _invulnerabilityTimer = invulnerabilityDuration;
    return true;
  }

  /// Heals the player, increasing their health up to the maximum.
  void heal(int amount) {
    _health = (_health + amount).clamp(0, maxHealth);
  }

  /// Checks if the player is dead (health is 0 or less).
  bool get isDead => _health <= 0;
}