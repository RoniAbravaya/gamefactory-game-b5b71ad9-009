import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:testLast-puzzle-09/components/player.dart';
import 'package:testLast-puzzle-09/components/obstacle.dart';
import 'package:testLast-puzzle-09/components/collectible.dart';
import 'package:testLast-puzzle-09/services/analytics.dart';
import 'package:testLast-puzzle-09/services/ads.dart';
import 'package:testLast-puzzle-09/services/storage.dart';

/// The main game class for the 'testLast-puzzle-09' game.
class testLast-puzzle-09Game extends FlameGame with TapDetector {
  /// The current game state.
  GameState _gameState = GameState.playing;

  /// The player component.
  late Player _player;

  /// The list of obstacles in the game.
  final List<Obstacle> _obstacles = [];

  /// The list of collectibles in the game.
  final List<Collectible> _collectibles = [];

  /// The current score.
  int _score = 0;

  /// The analytics service.
  final AnalyticsService _analyticsService = AnalyticsService();

  /// The ads service.
  final AdsService _adsService = AdsService();

  /// The storage service.
  final StorageService _storageService = StorageService();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the level
    await _loadLevel();

    // Add the player, obstacles, and collectibles to the game
    add(_player);
    _obstacles.forEach(add);
    _collectibles.forEach(add);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the game state
    switch (_gameState) {
      case GameState.playing:
        // Update the player, obstacles, and collectibles
        _player.update(dt);
        _obstacles.forEach((obstacle) => obstacle.update(dt));
        _collectibles.forEach((collectible) => collectible.update(dt));

        // Check for collisions and other game logic
        _handleCollisions();
        _checkGameOver();
        break;
      case GameState.paused:
        // Pause the game
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

    // Handle tap input for the player
    _player.onTap(info.eventPosition.game);
  }

  /// Loads the current level.
  Future<void> _loadLevel() async {
    // Load the level data from storage or other sources
    final levelData = await _storageService.loadLevelData();

    // Create the player, obstacles, and collectibles based on the level data
    _player = Player(levelData.playerPosition);
    _obstacles.addAll(levelData.obstacles.map((data) => Obstacle(data)));
    _collectibles.addAll(levelData.collectibles.map((data) => Collectible(data)));
  }

  /// Handles collisions between the player, obstacles, and collectibles.
  void _handleCollisions() {
    // Check for collisions and update the game state accordingly
    for (final obstacle in _obstacles) {
      if (_player.overlaps(obstacle)) {
        _gameState = GameState.gameOver;
        _analyticsService.logLevelFail();
        break;
      }
    }

    for (final collectible in _collectibles) {
      if (_player.overlaps(collectible)) {
        _score += collectible.value;
        _collectibles.remove(collectible);
        _analyticsService.logCollectiblePickup();
        break;
      }
    }
  }

  /// Checks if the game is over and updates the game state accordingly.
  void _checkGameOver() {
    // Check if the player has no more moves or the time is up
    if (_player.noMoreMoves || _player.timeUp) {
      _gameState = GameState.gameOver;
      _analyticsService.logLevelFail();
    }

    // Check if the player has completed the level
    if (_collectibles.isEmpty) {
      _gameState = GameState.levelComplete;
      _analyticsService.logLevelComplete();
      _storageService.saveLevelProgress();
      _adsService.showRewardedAd();
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