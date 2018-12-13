```
docker run --name kelu -d -t -v d:/Github/debian/var/local:/var/local -v d:/Github/debian/src:/app -v d:/Github/debian/root:/root  -v d:/Github/debian/src/sources.list:/etc/apt/sources.list dunecommunity/debian-full tail -f /var/local/log/tmp

docker exec -it kelu /bin/bash

cd /var/local/KeluLinuxKit && ./keluLinuxKit.sh install all

exit

docker exec -it kelu /bin/zsh
docker stop kelu && docker rm kelu
```
