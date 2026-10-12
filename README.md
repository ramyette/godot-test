# Godot Top-Down Shooter Research Prototype

This is an individual research prototype created for the CSCE 490/492 Research Milestone.

The purpose of this project was to learn and evaluate the Godot Engine for my team’s capstone project, a top-down pawn shop manager. Although this prototype is a shooter rather than a pawn shop game, it allowed me to practice the same Godot systems that will transfer to our project: 2D scenes, player input, collision detection, UI, timers, enemy behavior, instancing, and gameplay state.

## Features

- Top-down player movement
- Mouse-based aiming
- Hitscan shooting using `RayCast2D`
- Animated bullet tracer effects
- Enemies that spawn at randomized spawn points
- Enemies that chase the player and deal contact damage
- Player health bar and delayed health regeneration
- Player death screen with a Replay button
- Enemy limit to control the number of active enemies

## Controls

- Move: `WASD` / arrow keys
- Aim: Mouse
- Shoot: Left mouse button

This project was created with Godot v4.7.

## Project Structure

- `scripts/Player.gd` — player movement, aiming, shooting, health, healing, and death
- `scripts/Enemy.gd` — enemy movement, player contact, and damage behavior
- `scripts/EnemySpawner.gd` — enemy spawning and active-enemy limit
- `scripts/Tracer.gd` — bullet-trail visual effect
- `scripts/DeathScreen.gd` — replay button behavior

## What I Learned

Through this project, I learned how to:

- Create and connect scenes in Godot
- Write GDScript for player and enemy behavior
- Use input actions and mouse position for gameplay controls
- Use `Area2D` and `RayCast2D` for collision and hit detection
- Update a `ProgressBar` UI element through code
- Use timers and cooldown values for shooting, damage, and healing
- Instantiate scenes at runtime for enemies and visual effects
- Organize a Godot project into separate scripts and scenes
- Use Git and GitHub commits to track development

## Demo Video

[Watch the demo video here](https://youtu.be/PaaEPuHBHrA)

## Author

Rivers Amyette  
CSCE 490 — Fall 2026
