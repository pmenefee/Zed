using Godot;
using System;

public partial class splash_screen : Node2D
{
	public override void _Input(InputEvent @event)
	{
		if (@event is InputEventKey)
		{
			GetTree().ChangeSceneToFile("res://scenes/main.tscn");
		}
	}
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
