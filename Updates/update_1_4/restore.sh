#!/bin/sh

sudo service dizaynvip stop
sudo perl -i -pe 's/(version=[0-9].)(\d+)$/$1.($2-1)/e' settings.ini
sudo mv autovip_ls backup/autovip_ls.last.2
sleep 1
sudo mv backup/autovip_ls.last ./autovip_ls
sudo mv backup/autovip_ls.last.2 backup/autovip_ls.last
sudo chmod +x autovip_ls
sudo service dizaynvip start

exec $SHELL
