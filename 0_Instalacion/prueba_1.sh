#!/usr/bin/env bash
# Comprobar que ffmpeg está presente y es capaz de crear un MP4
cat << 'EOF' > main.sh
gmt begin
	echo ${MOVIE_FRAME} | gmt text -R0/1/0/1 -JX10c -F+f200p+cCM -B0 -X0 -Y0
gmt end
EOF
gmt movie main.sh -Nprueba_1 -T25 -C10cx10cx30 -Gred -D4 -Zs -Fmp4 -Fgif
