* Size of all packages on disk

```bash
rpm -qa --queryformat '%{SIZE}\n' | awk '{s+=$1} END {printf "%.2f GB\n", s/1024/1024/1024}'
```

* Biggest packages

```bash
rpm -qa --queryformat '%{SIZE}\t%{NAME}\n' | sort -rn | head -n 25 | awk '{printf "%.1f MB\t%s\n", $1/1024/1024, $2}'
```
