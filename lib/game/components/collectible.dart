import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:audioplayers/audioplayers.dart';

/// A collectible item component for a puzzle game.
class Collectible extends SpriteComponent with Collidable, HasGameRef {
  /// The score value of the collectible.
  final int scoreValue;

  /// The audio player for the collection sound effect.
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Creates a new instance of the [Collectible] component.
  Collectible({
    required Sprite sprite,
    required this.scoreValue,
    Vector2? position,
    Vector2? size,
  }) : super(
          sprite: sprite,
          position: position,
          size: size ?? Vector2.all(32.0),
        ) {
    addEffect(RotateEffect.by(
      2 * pi,
      EffectController(
        duration: 2,
        infinite: true,
        curve: Curves.linear,
      ),
    ));
    addEffect(MoveEffect.by(
      Vector2(0, 10),
      EffectController(
        duration: 1,
        infinite: true,
        curve: Curves.easeInOut,
      ),
    ));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      _audioPlayer.play(AssetSource('collect_sound.mp3'));
      gameRef.score += scoreValue;
      removeFromParent();
    }
  }
}