# sdparmのインストール、HDDスリープを設定
(参考：http://blog.goo.ne.jp/thaniwa/e/6ebcdf839e76f3454687cdb1cce01d14)
(参考 UUIDに対応：http://kassyjp.ninja-web.net/ras/jessie/spindown.htm)


# インストール
yum install sdparm

# スクリプト適宜修正
vi /root/usbhdd_spindown.sh

# 実行する
/root/usbhdd_spindown.sh 2c66c190-4bd1-49c8-b61f-073e3ff51719 600 2>&1 | logger -t usbhdd_spindown &

# 起動時に自動実行するため、上記を追記しとく
vi /etc/rc.local 

# fstabでうまくmountできないので最終的にべた書きで。。。
vi /etc/rc.local 
--------------------
mount -t ext3 /dev/disk/by-uuid/2c66c190-4bd1-49c8-b61f-073e3ff51719 /mnt/usbhdd
--------------------


