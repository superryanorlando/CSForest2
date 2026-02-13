function inputSetup() {
	bufferTimer = 3;
	
	zKeyReal = 0;
	zKeyTimer = 0;
	
}

function playerInputs(){
	//arrow keys
	rightKey = keyboard_check(vk_right)
	leftKey = keyboard_check(vk_left)
	upKey = keyboard_check(vk_up)
	downKey = keyboard_check(vk_down)
	test = keyboard_check(ord("Z")) 
	//action buttons
	zKey = keyboard_check(ord("Z"))
	xKey = keyboard_check(ord("X"))
	cKey = keyboard_check(ord("C"))
	
	zKeyPressed = keyboard_check_pressed(ord("Z"))
	xKeyPressed = keyboard_check_pressed(ord("X"))
	cKeyPressed = keyboard_check_pressed(ord("C"))
	

	
	//jumping
	if (zKeyPressed) {
		zKeyTimer=bufferTimer;
	}
	if (zKeyTimer>0) {
		zKeyReal = 1;
		zKeyTimer--;
	} else {
		zKeyReal = 0;
	}
	
	
	zKeyPressed = keyboard_check_pressed(ord("Z"))
	xKeyPressed = keyboard_check_pressed(ord("X"))
	cKeyPressed = keyboard_check_pressed(ord("C"))

	//movement
	if (oPlayer.canMove) {
		movDirection = rightKey-leftKey;
		xSpeed = movDirection * movSpeed;
	} else {
		xSpeed = 0;
	}
	
	}
