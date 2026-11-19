import librosa, numpy as np
y,sr=librosa.load('sing.wav',sr=22050,mono=True)
tempo,beats=librosa.beat.beat_track(y=y,sr=sr,units='time')
print('tempo',tempo)
rms=librosa.feature.rms(y=y,hop_length=512)[0]; t=librosa.times_like(rms,sr=sr,hop_length=512)
for s in range(0,70,2):
  m=(t>=s)&(t<s+2); print(s, round(float(rms[m].mean()),3), end=' | ')
print()
on=librosa.onset.onset_detect(y=y,sr=sr,units='time',backtrack=False)
print('beats',' '.join(f'{b:.2f}' for b in beats))
print('onsets',' '.join(f'{b:.2f}' for b in on))
np.savetxt('beats.txt',beats,fmt='%.3f')
