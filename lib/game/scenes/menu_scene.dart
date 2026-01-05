import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

/// The main menu scene for the puzzle game.
class MenuScene extends Component with TapCallbacks {
  /// The title of the game.
  late final TextComponent _titleComponent;

  /// The button to start the game.
  late final ButtonComponent _playButton;

  /// The button to access the level select screen.
  late final ButtonComponent _levelSelectButton;

  /// The button to access the settings screen.
  late final ButtonComponent _settingsButton;

  /// The background animation.
  late final SpriteAnimationComponent _backgroundAnimation;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Create the title component
    _titleComponent = TextComponent(
      text: 'testLast-puzzle-09',
      position: Vector2(size.x / 2, 100),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(_titleComponent);

    // Create the play button
    _playButton = ButtonComponent(
      position: Vector2(size.x / 2, 300),
      size: Vector2(200, 60),
      anchor: Anchor.topCenter,
      child: TextComponent(
        text: 'Play',
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: () {
        // Navigate to the game scene
      },
    );
    add(_playButton);

    // Create the level select button
    _levelSelectButton = ButtonComponent(
      position: Vector2(size.x / 2, 400),
      size: Vector2(200, 60),
      anchor: Anchor.topCenter,
      child: TextComponent(
        text: 'Level Select',
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: () {
        // Navigate to the level select scene
      },
    );
    add(_levelSelectButton);

    // Create the settings button
    _settingsButton = ButtonComponent(
      position: Vector2(size.x / 2, 500),
      size: Vector2(200, 60),
      anchor: Anchor.topCenter,
      child: TextComponent(
        text: 'Settings',
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: () {
        // Navigate to the settings scene
      },
    );
    add(_settingsButton);

    // Create the background animation
    _backgroundAnimation = SpriteAnimationComponent(
      animation: SpriteAnimation.spriteList([
        // Add your background sprites here
      ], stepTime: 0.1),
      position: Vector2.zero(),
      size: size,
    );
    add(_backgroundAnimation);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _backgroundAnimation.update(dt);
  }
}