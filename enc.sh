export PATH=$HOME/.local/bin:$PATH
cd ~/w
ffmpeg -nostdin -v error -y -i final.mp4 -c:v libx264 -preset medium -b:v 6000k -maxrate 7000k -bufsize 12000k -pix_fmt yuv420p -c:a copy -movflags +faststart deliver.mp4
ffmpeg -nostdin -v error -y -i deliver.mp4 -vf "fps=0.5,scale=400:-1,tile=4x7" -frames:v 1 qc.jpg
stat -c '%s' deliver.mp4 qc.jpg > enc.txt; ffprobe -v error -show_entries format=duration -of csv=p=0 deliver.mp4 >> enc.txt
touch enc.flag
