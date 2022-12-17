extends Control

const FREQ_MAX = 4000

var spectrum
var vu_count

func _ready():
	AudioServer.add_bus_effect(0, AudioEffectSpectrumAnalyzer.new())
	spectrum = AudioServer.get_bus_effect_instance(0, 0)
	vu_count = $VB.get_child_count()


func _process(_delta):
	if $Audio.playing:
		var prev_hz = 0
		var data = PoolByteArray()
		for i in range(1, vu_count + 1):
			var hz = i * FREQ_MAX / vu_count;
			var magnitude = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
			data.append(255 * clamp(magnitude * 3.0, 0, 1))
			$VB.get_child(i - 1).value = 100 * magnitude
			prev_hz = hz


func _on_Play_pressed():
	$Audio.play()
