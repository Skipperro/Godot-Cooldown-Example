extends Node2D

var player: KinematicBody2D = null
var label: Label = null
var progressbar: ProgressBar = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Player
	label = $GUI/Label
	progressbar = $GUI/ProgressBar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player == null:
		return
	
	if player.SprintingNow:
		label.text = "Status: SPRINTING NOW"
		progressbar.visible = true
		progressbar.value = (player.SprintingSince / player.SprintDuration) * 100  
	else:
		if (player.SprintCooldownLeft > 0.0):
			label.text = "Status: Cooldown"
			progressbar.visible = true
			progressbar.value = (player.SprintCooldownLeft / player.SprintCooldown) * 100  
		else:
			label.text = "Status: Ready"
			progressbar.visible = false
