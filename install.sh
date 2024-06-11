#!/bin/bash
pkg update; pkg upgrade
# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\n\t'

finish() {
  local ret=$?
  if [ ${ret} -ne 0 ] && [ ${ret} -ne 130 ]; then
    echo
    echo "LỖI: Không thể thiết lập XFCE trên Termux."
    echo "Vui lòng tham khảo (các) thông báo lỗi ở trên"
  fi
}

trap finish EXIT

clear

echo ""
echo "Tập lệnh này sẽ cài đặt XFCE Desktop trong Termux cùng với root Ubuntu"
echo ""
read -r -p "Vui lòng nhập tên người dùng để cài đặt root: " username </dev/tty

termux-change-repo
pkg update -y -o Dpkg::Options::="--force-confold"
pkg upgrade -y -o Dpkg::Options::="--force-confold"
sed -i '12s/^#//' $HOME/.termux/termux.properties

# Display a message 
clear -x
echo ""
echo "Thiết lập quyền truy cập Bộ lưu trữ Termux." 
# Wait for a single character input 
echo ""
read -n 1 -s -r -p "Bấm phím bất kỳ để tiếp tục..."
termux-setup-storage

pkgs=('wget' 'ncurses-utils' 'dbus' 'proot-distro' 'x11-repo' 'tur-repo' 'pulseaudio')

pkg uninstall dbus -y
pkg update
pkg install "${pkgs[@]}" -y -o Dpkg::Options::="--force-confold"

#Create default directories
mkdir -p Desktop
mkdir -p Downloads

#Download required install scripts
wget https://github.com/phoenixbyrd/Termux_XFCE/raw/main/xfce.sh
wget https://github.com/phoenixbyrd/Termux_XFCE/raw/main/proot.sh
wget https://github.com/phoenixbyrd/Termux_XFCE/raw/main/utils.sh
chmod +x *.sh

./xfce.sh "$username"
./proot.sh "$username"
./utils.sh

# Display a message 
clear -x
echo ""
echo "Cài đặt Termux-X11 APK" 
# Wait for a single character input 
echo ""
read -n 1 -s -r -p "Bấm phím bất kỳ để tiếp tục..."
wget https://github.com/termux/termux-x11/releases/download/nightly/app-arm64-v8a-debug.apk
mv app-arm64-v8a-debug.apk $HOME/storage/downloads/
termux-open $HOME/storage/downloads/app-arm64-v8a-debug.apk

source $PREFIX/etc/bash.bashrc
termux-reload-settings

clear -x
echo ""
echo ""
echo "Thiết lập đã hoàn tất thành công!"
echo ""
echo "Bây giờ bạn có thể kết nối với Termux XFCE4 Desktop để mở màn hình nền bằng lệnh start"
echo ""
echo "Lệnh này sẽ khởi động máy chủ termux-x11 trong termux và khởi động XFCE Desktop, sau đó mở ứng dụng Termux-X11 đã cài đặt."
echo ""
echo "Để thoát, nhấp đúp vào biểu tượng Kill Termux X11 trên bảng điều khiển."
echo ""
echo "Hãy tận hưởng trải nghiệm Termux XFCE4 Desktop của bạn!"
echo ""
echo ""

rm xfce.sh
rm proot.sh
rm utils.sh
rm install.sh
