import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:testLast-puzzle-09/analytics_service.dart';
import 'package:testLast-puzzle-09/game_controller.dart';
import 'package:testLast-puzzle-09/level_config.dart';
import 'package:testLast-puzzle-09/level_manager.dart';
import 'package:testLast-puzzle-09/ui/game_overlay.dart';

/// The main FlameGame class for the testLast-puzzle-09 game.
class testLast-puzzle-09Game extends FlameGame with TapDetector {
  /// The current game state.
  GameState _gameState = GameState.playing;

  /// The score of the current game.
  int _score = 0;

  /// The number of lives the player has.
  int _lives = 3;

  /// The level manager for the game.
  late LevelManager _levelManager;

  /// The game controller for the game.
  late GameController _gameController;

  /// The analytics service for the game.
  late AnalyticsService _analyticsService;

  /// The game overlay for the game.
  late GameOverlay _gameOverlay;

  @override
  Future<void> onLoad() async {
    // Set up the camera and world
    camera.viewport = FixedResolutionViewport(Vector2(800, 1400));
    camera.followComponent(this);

    // Initialize the level manager
    _levelManager = LevelManager(this);
    await _levelManager.loadLevel(1);

    // Initialize the game controller
    _gameController = GameController(this);

    // Initialize the analytics service
    _analyticsService = AnalyticsService();

    // Initialize the game overlay
    _gameOverlay = GameOverlay(this);
    add(_gameOverlay);

    // Log the game start event
    _analyticsService.logEvent('game_start');
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the game state and handle game logic
    switch (_gameState) {
      case GameState.playing:
        _gameController.update(dt);
        break;
      case GameState.paused:
        // Pause the game logic
        break;
      case GameState.gameOver:
        // Handle game over logic
        break;
      case GameState.levelComplete:
        // Handle level complete logic
        break;
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    _gameController.handleTap(info.eventPosition.game);
  }

  /// Handles a collision between two game objects.
  void handleCollision(CollisionComponent a, CollisionComponent b) {
    try {
      _gameController.handleCollision(a, b);
    } catch (e) {
      // Handle the collision error gracefully
      print('Collision error: $e');
    }
  }

  /// Increases the player's score by the given amount.
  void increaseScore(int amount) {
    _score += amount;
    _gameOverlay.updateScore(_score);
  }

  /// Decreases the player's lives by the given amount.
  void decreaseLives(int amount) {
    _lives -= amount;
    _gameOverlay.updateLives(_lives);

    if (_lives <= 0) {
      _gameState = GameState.gameOver;
      _analyticsService.logEvent('level_fail');
    }
  }

  /// Sets the game state to the given state.
  void setGameState(GameState state) {
    _gameState = state;
    _gameOverlay.updateGameState(state);
  }

  /// Completes the current level.
  void completeLevelAndUnlockNext() {
    _gameState = GameState.levelComplete;
    _analyticsService.logEvent('level_complete');

    // Unlock the next level
    int currentLevel = _levelManager.currentLevel;
    if (currentLevel < LevelConfig.maxLevels) {
      _levelManager.unlockLevel(currentLevel + 1);
      _analyticsService.logEvent('level_unlocked');
    }
  }
}

/// The possible game states.
enum GameState {
  playing,
  paused,
  gameOver,
  levelComplete,
}