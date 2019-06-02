# local_scripts
* 基本的に頂いてきたスクリプトをベースに改修してる感じで
* 公開しちゃっても問題ない範囲で

# block_ssh_attack
* 2000年代に作ったスクリプト
* swatch使ってhosts.denyに当該IPを突っ込んでいく感じ
* https://ry.tl/brute_force_attack.html のやり方に変更

# usbhdd_spindown
* 外付けUSB-HDDが回転しっぱなしなのがツラいため導入
* sdparm を導入してスクリプトで制御する感じ
* どこかからか頂いたスクリプトをベースにUUIDに対応
* UUIDで指定しないと hda hdbがコロコロ変わっちゃうので、、、
