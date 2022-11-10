extends KinematicBody2D

# Player settings to play with
export var SprintCooldown = 5.0		# How long the cooldown between sprints will be
export var SprintDuration = 1.0		# For how long the player can sprint
export var SprintSpeed = 20000.0	# Speed during the sprint
export var RegularSpeed = 5000.0	# Regular speed without sprint

#Internal variables needed for sprint logic
var SprintCooldownLeft = 0.0		# Tracks how many seconds of cooldown are left
var SprintingSince = 0.0			# Tracks how long the sprinting is active
var SprintingNow = false			# Tells if player is sprinting now
var moveVector = Vector2.ZERO		# Movement direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handleInputs()
	handleSprint(delta)
	movePlayer(delta)

# Function that deals with sprint cooldowns
func handleSprint(delta):
	if SprintingNow:
		# Count time in sprint status and stop sprint if it's active for too long
		SprintingSince += delta
		if SprintingSince > SprintDuration:
			stopSprint()
	else:
		# Every frame, if player is not on sprint and cooldown is positive, reduce it by delta
		if SprintCooldownLeft > 0.0:
			SprintCooldownLeft -= delta
			# Make sure it doesn't go into negative numbers
			if SprintCooldownLeft < 0.0:
				SprintCooldownLeft = 0.0

# Function responsible for moving player on the map by calculated vector.
# See handleInputs() for keyboard support
func movePlayer(delta):
	var endVector = moveVector
	if endVector.length() > 0.0:
		endVector = endVector.normalized()			# Normalize the vector to have same speed even if moving diagonaly
		if SprintingNow:
			endVector = endVector * SprintSpeed * delta		# Go fast if sprinting
		else:
			endVector = endVector * RegularSpeed * delta	# Go slow if not sprinting
		move_and_slide(endVector)	# Do the actual move

# Function that converts key inputs into movement plan for the player.
# See movePlayer() for actual movement on the level
func handleInputs():
	moveVector = Vector2.ZERO
	if Input.is_action_pressed("up"):
		moveVector += Vector2.UP
	if Input.is_action_pressed("down"):
		moveVector += Vector2.DOWN
	if Input.is_action_pressed("right"):
		moveVector += Vector2.RIGHT
	if Input.is_action_pressed("left"):
		moveVector += Vector2.LEFT

	if Input.is_action_just_pressed("sprint") and moveVector.length() > 0.0:
		if SprintCooldownLeft == 0.0 and SprintingNow == false:
			startSprint()
		else:
			print("Sorry, can't sprint now!")
	if Input.is_action_just_released("sprint") or moveVector.length() == 0.0:
		if SprintingNow:
			stopSprint()

# Function that sets variables required to start the sprint
func startSprint():
	print("Sprint started")
	SprintingSince = 0.0
	SprintingNow = true

# Function that sets variables required to stop the sprint
func stopSprint():
	print("Sprint stopped")
	SprintingNow = false
	SprintingSince = 0.0
	SprintCooldownLeft = SprintCooldown
