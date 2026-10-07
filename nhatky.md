root@azvps-nguyenduc:~# mkdir -p /var/www/my-app/public
mkdir -p /var/www/my-app/logs
root@azvps-nguyenduc:~# chmod 750 /var/www/my-app/public
chmod 770 /var/www/my-app/logs
root@azvps-nguyenduc:~# awk -F: '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd
root@azvps-nguyenduc:~# adduser duc
Adding user `duc' ...
Adding new group `duc' (1000) ...
Adding new user `duc' (1000) with group `duc' ...
Creating home directory `/home/duc' ...
Copying files from `/etc/skel' ...
New password:
Retype new password:
Sorry, passwords do not match.
passwd: Authentication token manipulation error
passwd: password unchanged
Try again? [y/N] y
New password:
Retype new password:
passwd: password updated successfully
Changing the user information for duc
Enter the new value, or press ENTER for the default
        Full Name []: hoangduc
        Room Number []:
        Work Phone []:
        Home Phone []:
        Other []:
Is the information correct? [Y/n]
root@azvps-nguyenduc:~# awk -F: '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd
duc
root@azvps-nguyenduc:~# chown -R duc:www-data /var/www/my-app
root@azvps-nguyenduc:~# ls -la /var/www/my-app
total 16
drwxr-xr-x 4 duc  www-data 4096 Oct  7 07:14 .
drwxr-xr-x 5 root root     4096 Oct  7 07:14 ..
drwxrwx--- 2 duc  www-data 4096 Oct  7 07:14 logs
drwxr-x--- 2 duc  www-data 4096 Oct  7 07:14 public