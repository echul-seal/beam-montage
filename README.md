# Beam montage

53.0 s, 1280x720 with 2.39:1 bars, 24 fps.

Final: https://renders.heyseal.ai/deliverables/3af6dff4-961b-47d5-840c-77eaf506f998/1215682b-0beb-4ec1-a839-f837b425dfc6.mp4
Score: https://renders.heyseal.ai/deliverables/3af6dff4-961b-47d5-840c-77eaf506f998/73d145cb-f7d8-4140-82b5-b95f6babe9d0.mp3 (Suno V5.5 instrumental, used from 2.5 s)
QC sheet: https://renders.heyseal.ai/deliverables/3af6dff4-961b-47d5-840c-77eaf506f998/5eefd5d1-7ee1-489b-9f9d-31160c29f98d.jpg

## Pipeline
- Stills: Echul's (GPT Image 2). Convoy Z markings removed with Nano Banana Pro. New street-at-dusk still made with Nano Banana Pro.
- Animation: Seedance 2.5, 720p, 5 s (chapel 8 s), no audio, small real motion prompts.
- Edit: build.sh (grade per clip: desat 0.78, cool shadows/mids, warm-safe highlights, soft S-curve; concat; crop to 2.39 + bars; grain alls=7; fades; loudnorm -16 LUFS). enc.sh re-encodes to ~6 Mbps for Telegram.

## Shot list (edl.txt)
1 glasses / code in lenses 4.0s
2 data center rooftops 4.0s
3 tower by the lake 4.5s
4 top-down down the tower 3.5s
5 smoker on the loading dock 4.0s
6 fire trucks to the glowing plant 5.0s
7 convoy in snow, smoke column (Z removed) 4.0s
8 soldier's back, radio 3.5s
9 chamber, flags and world map 4.5s
10 four silhouettes at the glowing opening 4.0s
11 NEW city street at dusk, people looking up at the beam 4.0s
12 chapel, iron cross, beam with ring 8.0s

## v2: beat recut (Nov 19)
37.8 s, 11 shots (city street dropped). Audio: SINGULARITY v4.2 soundtrack, 32.09 s to the end (69.80 s), 3 s fade out.
Final: https://renders.heyseal.ai/deliverables/3af6dff4-961b-47d5-840c-77eaf506f998/d18d0cb0-a2ea-4bf1-bda4-d02dd79db133.mp4
QC sheet: https://renders.heyseal.ai/deliverables/3af6dff4-961b-47d5-840c-77eaf506f998/a53e6fac-9f52-4a6b-8ca8-dc7cf2e39d62.jpg
Beats: librosa 1.0.1 beat_track, 117.5 bpm (beats.py, beats.txt). Every cut lands on a detected beat; shots 1.5-3.6 s; chapel enters on the 60.09 s hit and holds 9.7 s (slowed to fill) under the fade.
Files: edl2.txt (file, in-point s, frames, [slow]), build2.sh (same grade, 2.39 bars, grain alls=7; also writes the Telegram encode and QC sheet).
