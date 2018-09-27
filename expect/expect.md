## expect

[Linux expect 教程中文版](http://xstarcd.github.io/wiki/shell/expect_handbook.html)

### spawn_id
```bash
spawn tip /dev/tty17     ;# open connection to
set tty $spawn_id        ;# tty to be spoofed
 
spawn login
set login $spawn_id
 
log_user 0
 
for {} {1} {} {
    set ready [select $tty $login]
 
    case $login in $ready {
        set spawn_id $login
        expect
          {"*password*" "*login*"}{
              send_user $expect_match
              set log 1
             }
          "*"        ;# ignore everything else
        set spawn_id    $tty;
        send $expect_match
    }
    case $tty in $ready {
        set spawn_id    $tty
        expect "* *"{
                if $log {
                  send_user $expect_match
                  set log 0
                }
               }
            "*" {
                send_user $expect_match
               }
        set spawn_id     $login;
        send $expect_match
    }
}
```