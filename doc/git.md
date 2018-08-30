## git

### alias
```git
git config alias.co checkout
git config --global alias.dfcs 'diff --cached --stat'
```

### diff
```git
git diff --since=1.hour.ago --until=1.minute.ago
```

### log
```git
git log -p --author='Peng'
```

### bare repository
```bash
# git bare local private repository
# use git-shell | not bash
useradd -m -s "$(which git-shell)" git
cd /usr/local/src/

git init --bare sample
sudo chown -R git:git sample
```

```bash
# On Local Machinde | access repository somewhere else
#  Create authorized_keys for user: git | Important
su -
cd /home/git
mkdir .ssh
touch .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
chown -R git:git .ssh

# Put pub key of access user into /home/git/.ssh/authorized_keys
# One line for each user

git remote add origin git@<team server ip>:/usr/local/src/sample
git clone git@<remote server ip>:/usr/local/src/sample

git pull origin master
git push origin master
```