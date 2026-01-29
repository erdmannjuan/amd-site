BEGIN { FS="," }
NR==1 { print; next }
!seen[$1]++ { print }
