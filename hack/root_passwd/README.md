# Root Password

The root password is stored at file /etc/shadow, and simply we can using John the Ripper try to crack it. 


```
# john shadow
.....
# john --show shadow
root:123:::::::

1 password hash cracked, 0 left
#

```

## The password for root is 123, can you believe?
