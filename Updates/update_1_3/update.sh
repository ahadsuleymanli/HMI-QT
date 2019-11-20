#!/bin/sh

sudo service dizaynvip stop
mkdir backup
sudo rm backup/autovip_ls.last
sudo mv autovip_ls backup/autovip_ls.last
sudo cp update_1_3/autovip_ls .
#sudo cp update_1_3/autovip_ls backup/autovip_ls.last
sudo chmod +x autovip_ls


sudo rm AutoUpdater
sudo rm backup/AutoUpdater2.last
sudo mv AutoUpdater2 backup/AutoUpdater2.last
sudo cp update_1_3/AutoUpdater2 .
#sudo cp update_1_3/AutoUpdater2 backup/AutoUpdater2.last
sudo chmod +x AutoUpdater2


sudo cp update_1_3/proto.ini .
sudo cp update_1_3/settings.ini .

sudo cp update_1_3/restore.sh backup/restore.sh
sudo chmod +x backup/restore.sh

sudo service dizaynvip start

exec $SHELL
