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
	
	if (zKeyReal) {
		var _nbj = 30;
		while (_nbj>0) {
			zKeyPressed = true;
			_nbj--;
		}
		
	}
	zKeyPressed = keyboard_check_pressed(ord("Z"))
	xKeyPressed = keyboard_check_pressed(ord("X"))
	cKeyPressed = keyboard_check_pressed(ord("C"))

	//movement
	movDirection = rightKey-leftKey;
	xSpeed = movDirection * movSpeed;
	}
