import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// The main game scene that handles level loading, game logic, and UI.
class GameScene extends Component with HasGameRef {
  /// The player component.
  late Player player;

  /// The obstacles in the level.
  final List<Obstacle> obstacles = [];

  /// The collectibles in the level.
  final List<Collectible> collectibles = [];

  /// The current score.
  int score = 0;

  /// Whether the game is paused.
  bool isPaused = false;

  @override
  Future<void> onLoad() async {
    /// Load the current level
    await _loadLevel();

    /// Spawn the player
    player = Player()..position = Vector2(100, 500);
    add(player);

    /// Spawn the obstacles
    for (final obstacleData in _levelData.obstacles) {
      final obstacle = Obstacle()
        ..position = Vector2(obstacleData.x, obstacleData.y)
        ..size = Vector2(obstacleData.width, obstacleData.height);
      obstacles.add(obstacle);
      add(obstacle);
    }

    /// Spawn the collectibles
    for (final collectibleData in _levelData.collectibles) {
      final collectible = Collectible()
        ..position = Vector2(collectibleData.x, collectibleData.y)
        ..size = Vector2(collectibleData.width, collectibleData.height);
      collectibles.add(collectible);
      add(collectible);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isPaused) {
      /// Update player and check for collisions
      player.update(dt);
      _checkCollisions();

      /// Check for win/lose conditions
      if (_isLevelComplete()) {
        _handleLevelComplete();
      } else if (_isLevelFailed()) {
        _handleLevelFail();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    /// Render the score
    final scoreText = TextComponent(text: 'Score: $score')
      ..position = Vector2(20, 20)
      ..anchor = Anchor.topLeft;
    scoreText.render(canvas);

    /// Render the pause button
    final pauseButton = ButtonComponent(
      position: Vector2(gameRef.size.x - 50, 20),
      size: Vector2(40, 40),
      onPressed: _togglePause,
      child: TextComponent(text: isPaused ? 'Resume' : 'Pause'),
    );
    pauseButton.render(canvas);
  }

  void _togglePause() {
    isPaused = !isPaused;
  }

  void _checkCollisions() {
    /// Check for collisions between player and obstacles/collectibles
    for (final obstacle in obstacles) {
      if (player.isColliding(obstacle)) {
        _handleObstacleCollision(obstacle);
      }
    }

    for (final collectible in collectibles) {
      if (player.isColliding(collectible)) {
        _handleCollectibleCollection(collectible);
      }
    }
  }

  void _handleObstacleCollision(Obstacle obstacle) {
    /// Handle the player colliding with an obstacle
    _handleLevelFail();
  }

  void _handleCollectibleCollection(Collectible collectible) {
    /// Handle the player collecting a collectible
    collectibles.remove(collectible);
    score += 10;
  }

  bool _isLevelComplete() {
    /// Check if the level is complete (e.g., all collectibles collected)
    return collectibles.isEmpty;
  }

  bool _isLevelFailed() {
    /// Check if the level has failed (e.g., player ran out of moves)
    return false; // Implement your own logic here
  }

  void _handleLevelComplete() {
    /// Handle the level being completed
    print('Level completed! Score: $score');
  }

  void _handleLevelFail() {
    /// Handle the level being failed
    print('Level failed!');
  }

  Future<void> _loadLevel() async {
    /// Load the current level data
    _levelData = await loadLevelData();
  }

  LevelData _levelData;

  Future<LevelData> loadLevelData() async {
    /// Load the level data from a file or network
    return LevelData(
      obstacles: [
        ObstacleData(x: 200, y: 400, width: 50, height: 50),
        ObstacleData(x: 300, y: 500, width: 75, height: 75),
      ],
      collectibles: [
        CollectibleData(x: 150, y: 450, width: 25, height: 25),
        CollectibleData(x: 400, y: 550, width: 25, height: 25),
      ],
    );
  }
}

/// Represents the player component.
class Player extends SpriteComponent {
  // Implement the player logic here
}

/// Represents an obstacle component.
class Obstacle extends SpriteComponent {
  // Implement the obstacle logic here
}

/// Represents a collectible component.
class Collectible extends SpriteComponent {
  // Implement the collectible logic here
}

/// Represents the level data.
class LevelData {
  final List<ObstacleData> obstacles;
  final List<CollectibleData> collectibles;

  LevelData({
    required this.obstacles,
    required this.collectibles,
  });
}

/// Represents the data for an obstacle.
class ObstacleData {
  final double x;
  final double y;
  final double width;
  final double height;

  ObstacleData({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
}

/// Represents the data for a collectible.
class CollectibleData {
  final double x;
  final double y;
  final double width;
  final double height;

  CollectibleData({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
}