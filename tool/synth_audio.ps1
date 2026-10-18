# Dev-placeholder audio synthesis (docs/SOUND_SPEC.md).
# Voice slots: Windows SAPI ko-KR (Heami). SFX slots: procedural PCM tones.
# Studio recordings later replace files 1:1 by slot id ??no code changes.
param([string]$ProjectRoot = "D:\Claude\hangul_quest")

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Speech

# ---- voice ------------------------------------------------------------------
$jobs = Get-Content (Join-Path $ProjectRoot "tool\tts_jobs.json") -Raw | ConvertFrom-Json
$synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
$synth.SelectVoice("Microsoft Heami Desktop")
$synth.Rate = -1   # slightly slow for learners

$done = 0
foreach ($job in $jobs) {
  $path = Join-Path $ProjectRoot $job.file.Replace('/', '\')
  New-Item -ItemType Directory -Force -Path (Split-Path $path) | Out-Null
  $synth.SetOutputToWaveFile($path)
  $synth.Speak($job.text)
  $done++
}
$synth.SetOutputToNull()
$synth.Dispose()
Write-Output "voice files: $done"

# ---- sfx (procedural tones) -------------------------------------------------
function Write-Tone {
  param([string]$Path, [double[]]$Freqs, [double]$Dur, [double]$Gain = 0.4, [switch]$Chirp)
  $rate = 22050
  $n = [int]($rate * $Dur)
  $samples = New-Object 'System.Int16[]' $n
  for ($i = 0; $i -lt $n; $i++) {
    $t = $i / $rate
    $env = [Math]::Exp(-4.0 * $t / $Dur)      # exponential decay envelope
    $v = 0.0
    foreach ($f in $Freqs) {
      $ff = if ($Chirp) { $f * (1.0 + 0.6 * $t / $Dur) } else { $f }
      $v += [Math]::Sin(2 * [Math]::PI * $ff * $t)
    }
    $v = $v / $Freqs.Count * $Gain * $env
    $samples[$i] = [int16]([Math]::Max(-1.0, [Math]::Min(1.0, $v)) * 32767)
  }
  New-Item -ItemType Directory -Force -Path (Split-Path $Path) | Out-Null
  $bytes = New-Object byte[] ($n * 2)
  [Buffer]::BlockCopy($samples, 0, $bytes, 0, $bytes.Length)
  $fs = [IO.File]::Create($Path)
  $bw = New-Object IO.BinaryWriter($fs)
  $bw.Write([Text.Encoding]::ASCII.GetBytes("RIFF")); $bw.Write([int](36 + $bytes.Length))
  $bw.Write([Text.Encoding]::ASCII.GetBytes("WAVEfmt ")); $bw.Write([int]16)
  $bw.Write([int16]1); $bw.Write([int16]1); $bw.Write([int]$rate)
  $bw.Write([int]($rate * 2)); $bw.Write([int16]2); $bw.Write([int16]16)
  $bw.Write([Text.Encoding]::ASCII.GetBytes("data")); $bw.Write([int]$bytes.Length)
  $bw.Write($bytes); $bw.Close(); $fs.Close()
}

$sfxRoot = Join-Path $ProjectRoot "assets\audio\sfx"
Write-Tone -Path "$sfxRoot\tap_correct.wav"       -Freqs 880, 1320       -Dur 0.12
Write-Tone -Path "$sfxRoot\tap_wrong.wav"         -Freqs 196, 185        -Dur 0.25
Write-Tone -Path "$sfxRoot\combo_2.wav"           -Freqs 880, 1108       -Dur 0.15 -Chirp
Write-Tone -Path "$sfxRoot\combo_3.wav"           -Freqs 988, 1244       -Dur 0.15 -Chirp
Write-Tone -Path "$sfxRoot\combo_4.wav"           -Freqs 1108, 1396      -Dur 0.18 -Chirp
Write-Tone -Path "$sfxRoot\block_pick.wav"        -Freqs 523             -Dur 0.06
Write-Tone -Path "$sfxRoot\block_drop.wav"        -Freqs 659, 523        -Dur 0.10
Write-Tone -Path "$sfxRoot\block_reject.wav"      -Freqs 220, 208        -Dur 0.20
Write-Tone -Path "$sfxRoot\syllable_complete.wav" -Freqs 523, 659, 784   -Dur 0.35 -Chirp
Write-Tone -Path "$sfxRoot\level_up.wav"          -Freqs 523, 659, 784, 1046 -Dur 0.6 -Chirp
Write-Tone -Path "$sfxRoot\card_unlock.wav"       -Freqs 784, 1046, 1318 -Dur 0.5 -Chirp
Write-Tone -Path "$sfxRoot\streak.wav"            -Freqs 659, 830        -Dur 0.3 -Chirp
Write-Tone -Path "$sfxRoot\countdown.wav"         -Freqs 440             -Dur 0.10
Write-Tone -Path "$sfxRoot\result_star.wav"       -Freqs 1046, 1318      -Dur 0.25 -Chirp
Write-Output "sfx files: 14"

