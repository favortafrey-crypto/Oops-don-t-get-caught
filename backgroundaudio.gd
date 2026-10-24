
extends AudioStreamPlayer

func _ready():
    print("Audio test started")
    if stream:
        play()
        print("Playing: ", playing)
    else:
        print("No audio stream assigned")