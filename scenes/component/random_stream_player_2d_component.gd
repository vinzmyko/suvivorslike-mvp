extends AudioStreamPlayer

@export var streams: Array[AudioStream]

var test: int = 3
var test_2: int = 4

func play_random():
	#safety check
	if streams == null || streams.size() == 0:
		return

	stream = streams.pick_random()
	play()