## Git
### Contents
- [Git](#git)
    - [pull](#pull)
    - [alias](#alias)
    - [diff](#diff)
    - [log](#log)
    - [bare repo](#bare)
    - [branch](#branch)
- [Github](#github)
    * [make repo empty](#empty)
    * [delete remote branch](#delete)
    * [untrace certain files](#untrace)
    * [syncing a fork](#sync)

<a id=git></a>
### Git
<a id=pull></a>
#### pull
<http://hungyuhei.github.io/2012/08/07/better-git-commit-graph-using-pull---rebase-and-merge---no-ff.html>

_为了使提交更加整洁一些, 使用 `git pull --rebase`_

```git
# git pull origin master
git pull origin master --rebase
```

<a id=alias></a>
#### alias
```git
git config alias.co checkout
git config --global alias.dfcs 'diff --cached --stat'
```

<a id=branch></a>
#### branch
```git
git branch -a
# delete branch 'devel'
git branch -d <devel>
```

<a id=diff></a>
#### diff
```git
git diff --since=1.hour.ago --until=1.minute.ago
```

<a id=log></a>
#### log
```git
git log -p --author='PENG'
```

<a id=bare></a>
#### bare repository
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

---
<a id=github></a>
### Github
<a id=empty></a>
#### make repo empty
> make new branch

```git
git checkout --orphan orphan
git add -A
git commit -am "Init commit"
git branch -D master
```

> Rename current branch to master and push

```git
git branch -m master
git push origin master --force
```

<a id='delete'></a>
#### delete remote branch
```git
git push origin :[branch_name]

# Exp: delete branch 'feature'
git push origin :feature
```

<a id='untrace'></a>
#### untrace certain files
> refer <https://gist.github.com/nasirkhan/5919173>

```git
git update-index --assume-unchanged FILE_NAME
git update-index --no-assume-unchanged FILE_NAME
```

<a id='sync'></a>
#### syncing a fork

follow steps:

1. [Configuring a remote for a fork](https://help.github.com/articles/configuring-a-remote-for-a-fork/)<br>
2. [Syncing a fork](https://help.github.com/articles/syncing-a-fork/)
