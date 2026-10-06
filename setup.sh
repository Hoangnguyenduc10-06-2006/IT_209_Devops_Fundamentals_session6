#!/usr/bin/env bash
# Bài 1 - FHS & phân quyền thư mục cho /var/www/my-app
# Chạy bằng user non-root có quyền sudo:  bash setup.sh
set -euo pipefail

APP_DIR=/var/www/my-app
OWNER="${SUDO_USER:-$USER}"   # user non-root làm chủ sở hữu
GROUP=www-data

# 0. Đảm bảo nhóm www-data tồn tại (Ubuntu có sẵn)
getent group "$GROUP" >/dev/null || sudo groupadd "$GROUP"

# 1. Tạo cấu trúc thư mục
sudo mkdir -p "$APP_DIR/public"
sudo mkdir -p "$APP_DIR/logs"

# 2. Đổi chủ sở hữu / nhóm sở hữu (làm trước chmod để -R không ghi đè gì)
sudo chown -R "$OWNER:$GROUP" "$APP_DIR"

# 3. Phân quyền
#    public: Owner rwx, Group r-x, Others --- (750)
sudo chmod 750 "$APP_DIR/public"
#    logs:   Owner rwx, Group rwx, Others --- (770)
sudo chmod 770 "$APP_DIR/logs"

# Cách tương đương bằng ký tự (symbolic):
#   sudo chmod u=rwx,g=rx,o=  "$APP_DIR/public"
#   sudo chmod u=rwx,g=rwx,o= "$APP_DIR/logs"

# 4. Kiểm tra
ls -la "$APP_DIR"
stat -c '%A %a %U:%G %n' "$APP_DIR/public" "$APP_DIR/logs"
