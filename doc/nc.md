## nc
- ncat
- netcat
- ncat
- socat

### connect
`C-D` to quit

- tcp

```ruby
ncat 192.168.10.1 80
ncat 2001::221 80
```

- udp

```ruby
ncat -u 192.168.10.1 80
ncat -u 2001::221 80
```

### listen

listen on port `8088`

- tcp

```ruby
nc -l 8088

tcp6       0      0 :::8888        :::*     LISTEN  5378/nc
```

- udp

```ruby
nc -u -l 8088

udp6       0      0 :::8888         :::*           4125/nc
```