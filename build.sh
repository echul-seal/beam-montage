#!/bin/sh
# build.sh: grade each clip, cut to EDL, letterbox 2.39, grain, music.
# EDL lines: file in out   (seconds)
set -e
cd ~/w
export PATH=$HOME/.local/bin:$PATH; FF="ffmpeg -nostdin"
mkdir -p g
# One grade: pull toward cool white-grey, keep highlights/warm sources (hue-selective via colorbalance on shadows/mids only), mild desat, gentle S-curve.
GRADE="scale=1280:720:flags=lanczos,fps=24,eq=saturation=0.78:contrast=1.06:gamma=0.98,colorbalance=rs=-0.06:gs=-0.01:bs=0.06:rm=-0.04:gm=0.0:bm=0.03:rh=0.02:gh=0.0:bh=-0.01,curves=all='0/0.03 0.25/0.22 0.75/0.78 1/0.97'"
i=0
: > list.txt
while read f a b; do
  [ -z "$f" ] && continue
  i=$((i+1)); o=g/$(printf %02d $i).mp4
  d=$(awk "BEGIN{print $b-$a}")
  $FF -v error -y -ss $a -t $d -i clips/$f -an -vf "$GRADE" -c:v libx264 -crf 14 -preset fast -pix_fmt yuv420p $o
  echo "file '$o'" >> list.txt
done < edl.txt
$FF -v error -y -f concat -safe 0 -i list.txt -c copy cut.mp4
DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 cut.mp4)
FO=$(awk "BEGIN{print $DUR-3}")
# 2.39 scope: 1280x536 picture in 1280x720 frame -> crop then pad black; film grain; fade in/out
$FF -v error -y -i cut.mp4 -ss ${MSTART:-0} -i music/${TRACK:-A}.mp3 -filter_complex "[0:v]crop=1280:536,pad=1280:720:0:92:black,noise=alls=7:allf=t,fade=t=in:st=0:d=1,fade=t=out:st=$FO:d=3[v];[1:a]atrim=0:$DUR,afade=t=in:st=0:d=1.5,afade=t=out:st=$(awk "BEGIN{print $DUR-4}"):d=4,loudnorm=I=-16:TP=-1.5[a]" -map "[v]" -map "[a]" -c:v libx264 -crf 18 -preset slow -pix_fmt yuv420p -c:a aac -b:a 192k -movflags +faststart final.mp4
ffprobe -v error -show_entries format=duration,size -of csv=p=0 final.mp4
