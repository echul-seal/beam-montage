#!/bin/sh
# build2.sh: beat recut on SINGULARITY v4.2 audio. EDL2 lines: file in frames [slow]
# Cut points = librosa beats (117.5 bpm) from 32.09s of the track; chapel from the 60.09s hit to the track's end (69.80s).
set -e
cd ~/w
export PATH=$HOME/.local/bin:$PATH; FF="ffmpeg -nostdin"
MSTART=32.09
mkdir -p g2
GRADE="scale=1280:720:flags=lanczos,fps=24,eq=saturation=0.78:contrast=1.06:gamma=0.98,colorbalance=rs=-0.06:gs=-0.01:bs=0.06:rm=-0.04:gm=0.0:bm=0.03:rh=0.02:gh=0.0:bh=-0.01,curves=all='0/0.03 0.25/0.22 0.75/0.78 1/0.97'"
i=0
: > list2.txt
while read f a n s; do
  [ -z "$f" ] && continue
  i=$((i+1)); o=g2/$(printf %02d $i).mp4
  if [ "$s" = slow ]; then
    src=$(ffprobe -v error -count_frames -select_streams v -show_entries stream=nb_read_frames -of csv=p=0 clips/$f)
    PRE="fps=24,setpts=PTS*$n/$src,fps=24,"
  else PRE=""; fi
  $FF -v error -y -ss $a -i clips/$f -an -vf "${PRE}$GRADE" -frames:v $n -c:v libx264 -crf 14 -preset fast -pix_fmt yuv420p $o
  echo "file '$o'" >> list2.txt
done < edl2.txt
$FF -v error -y -f concat -safe 0 -i list2.txt -c copy cut2.mp4
DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 cut2.mp4)
FO=$(awk "BEGIN{print $DUR-3}")
$FF -v error -y -i cut2.mp4 -ss $MSTART -i music/sing.wav -filter_complex "[0:v]crop=1280:536,pad=1280:720:0:92:black,noise=alls=7:allf=t,fade=t=in:st=0:d=0.4,fade=t=out:st=$FO:d=3[v];[1:a]atrim=0:$DUR,asetpts=PTS-STARTPTS,afade=t=in:st=0:d=0.05,afade=t=out:st=$(awk "BEGIN{print $DUR-3}"):d=3,loudnorm=I=-16:TP=-1.5[a]" -map "[v]" -map "[a]" -c:v libx264 -crf 18 -preset slow -pix_fmt yuv420p -c:a aac -b:a 192k -ar 48000 -movflags +faststart final2.mp4
ffmpeg -nostdin -v error -y -i final2.mp4 -c:v libx264 -preset medium -b:v 6000k -maxrate 7000k -bufsize 12000k -pix_fmt yuv420p -c:a copy -movflags +faststart deliver2.mp4
ffmpeg -nostdin -v error -y -i deliver2.mp4 -vf "fps=1,scale=320:-1,tile=6x7" -frames:v 1 qc2.jpg
ffprobe -v error -show_entries format=duration,size -of csv=p=0 deliver2.mp4 > enc2.txt; stat -c %s deliver2.mp4 qc2.jpg >> enc2.txt
touch build2.flag
