## git

- [pull](#pull)
- [alias](#alias)
- [diff](#diff)
- [log](#log)
- [bare repo](#bare)

<a id = pull></a>
### pull
<http://hungyuhei.github.io/2012/08/07/better-git-commit-graph-using-pull---rebase-and-merge---no-ff.html>

为了使提交更加整洁一些, 使用 `git pull --rebase`

---
```git
git pull origin master --rebase
```

<a id = alias></a>
### alias
```git
git config alias.co checkout
git config --global alias.dfcs 'diff --cached --stat'
```

<a id = diff></a>
### diff
```git
git diff --since=1.hour.ago --until=1.minute.ago
```

<a id = log></a>
### log
```git
git log -p --author='Peng'
```

<a id = bare></a>
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