# Bài 1: Khảo sát FHS và Phân quyền File/Folder nâng cao

## 1. Bối cảnh

Triển khai thư mục ứng dụng web tại `/var/www/my-app` (theo chuẩn FHS, `/var` chứa dữ liệu thay đổi trong quá trình chạy, `/var/www` là nơi đặt web content):

```
/var/www/my-app
├── public   # mã nguồn static công khai  -> 750 (drwxr-x---)
└── logs     # nhật ký hệ thống bảo mật   -> 770 (drwxrwx---)
```

- **Owner:** user non-root đang đăng nhập (`$USER`)
- **Group:** `www-data` (nhóm của web server Nginx/Apache trên Ubuntu)

## 2. Nhật ký các lệnh đã thực hiện

```bash
# Kiểm tra nhóm www-data đã tồn tại
getent group www-data

# 1. Tạo cấu trúc thư mục
sudo mkdir -p /var/www/my-app/public
sudo mkdir -p /var/www/my-app/logs

# 2. Đổi chủ sở hữu và nhóm sở hữu
sudo chown -R $USER:www-data /var/www/my-app

# 3. Phân quyền bằng số (octal)
sudo chmod 750 /var/www/my-app/public
sudo chmod 770 /var/www/my-app/logs

# (Tương đương bằng ký tự - symbolic)
# sudo chmod u=rwx,g=rx,o=  /var/www/my-app/public
# sudo chmod u=rwx,g=rwx,o= /var/www/my-app/logs

# 4. Kiểm tra
ls -la /var/www/my-app
```

> Toàn bộ các lệnh trên được gom trong [setup.sh](./setup.sh).

## 3. Kết quả `ls -la /var/www/my-app`

<!-- TODO: dán output THỰC TẾ từ máy Linux của bạn vào đây (hoặc chèn ảnh chụp màn hình) -->
```text
$ ls -la /var/www/my-app
total 16
drwxr-xr-x 4 <user> www-data 4096 <date> .
drwxr-xr-x 3 root   root     4096 <date> ..
drwxrwx--- 2 <user> www-data 4096 <date> logs
drwxr-x--- 2 <user> www-data 4096 <date> public
```

## 4. Giải thích phân quyền

| Thư mục  | Octal | Symbolic     | Owner         | Group             | Others |
|----------|-------|--------------|---------------|-------------------|--------|
| `public` | 750   | `drwxr-x---` | rwx (7)       | r-x (5)           | --- (0)|
| `logs`   | 770   | `drwxrwx---` | rwx (7)       | rwx (7)           | --- (0)|

Cách quy đổi: `r = 4`, `w = 2`, `x = 1` → `rwx = 7`, `r-x = 5`, `--- = 0`.

**Lưu ý về quyền `x` trên thư mục:** Với thư mục, `x` là quyền *đi vào* (traverse / `cd`) và truy cập file bên trong. Đề bài ghi Group "chỉ được đọc", nhưng nếu đặt `740` (`r--`) thì group chỉ liệt kê được tên file mà **không đọc được nội dung**. Vì vậy dùng `750` để Group (web server `www-data`) đọc được trang tĩnh, đúng với kết quả mong đợi `drwxr-x---`.

**Về `chown -R`:** dùng `$USER:www-data` để user thường quản lý code/log, còn tiến trình web server (chạy dưới nhóm `www-data`) đọc được `public` và ghi được vào `logs`. Others bị chặn hoàn toàn để bảo vệ log.
