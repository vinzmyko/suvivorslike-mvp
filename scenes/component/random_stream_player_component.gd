extends AudioStreamPlayer

@export var streams: Array[AudioStream]

@export var randomised_pitch = true
@export var min_pitch = 0.9
@export var max_pitch = 1.1

func play_random():
	#safety check
	if streams == null || streams.size() == 0:
		printerr("Audio stream array does not contain anything")
		return

	if randomised_pitch:
		pitch_scale = randf_range(min_pitch, max_pitch)
	else:
		pitch_scale = 1
					
	stream = streams.pick_random()

	play()

