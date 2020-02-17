## Git
### Contents
- [Git Basic Commands ](#git)
    - [pull](#pull)
    - [alias](#alias)
    - [diff](#diff)
    - [log](#log)
    - [branch](#branch)
    - [commit](#commit)
    - [amend](#amend)
    - [checkout](#checkout)
    - [tag](#tag)
    - [reset](#reset)
    - [remote](#remote)
    - [cherry-pick](#cherry)
    - [revert](#revert)
- [Github Associate Manipulation](#github)
    * [Make a **bare** repository](#bare)
    * [Make repo empty](#empty)
    * [Untrace certain files](#untrace)
    * [Configuring a remote for a fork](#forafork)
    * [Syncing a fork](#sync)

<a id=git></a>

### Git
<a id=pull></a>

#### [pull](http://hungyuhei.github.io/2012/08/07/better-git-commit-graph-using-pull---rebase-and-merge---no-ff.html)

_To make commits looked more clean, use `git pull --rebase`_

```bash
# git pull origin master
git pull origin master --rebase
```

<a id=alias></a>
#### alias
```bash
git config alias.co checkout
git config --global alias.dfcs 'diff --cached --stat'
```

<a id=checkout></a>
#### checkout
- remove already `indexed` file back to `workspace`

```bash
# from workspace to index
git add <file_name>

# then regret add
git checkout <file_name>
```

- new branch from history commit

```bash
git checkout -b <branch_name> <sha1>
```

<a id=branch></a>
#### branch
- make a new branch, notice `-b`

```bash
git checkout -b <branch_name>
```

- list all branches

```bash
git branch -a
```

- delete **local** branch

```bash
git branch -d <branch_name>
```

- delete **remote** branch, notice `:` before `branch_name`

```bash
git push origin :<branch_name>

# Example: delete branch 'feature'
git push origin :feature
```

<a id=diff></a>

#### diff
```bash
git diff --since=1.hour.ago --until=1.minute.ago
```

<a id=log></a>

#### log
```bash
git log -p --author='PENG'
```

<a id=commit></a>

#### commit

```bash
git status
git diff
git add .
git commit -m 'This is my first commit'
git show 82fb783

commit 82fb78377e99c98a902bc174e67d3913ed419ce7
Author: Peng Xiang <hi.pxiang@gmail.com>
Date:   Fri Dec 13 11:13:23 2019 +0800

    add rime pro package

diff --git a/template/rime_pro.zip b/template/rime_pro.zip
new file mode 100644
index 0000000..4a32888
Binary files /dev/null and b/template/rime_pro.zip differ
```

<a id=amend></a>

#### amend

if you need to correct the commit message

```bash
git commit --amend

# then use --force
# push to GitHub
git push origin master --force
```

if you need to modify some info of the submitter, such as `username` and `email` after pushing code to GitHub

```bash
git commit --amend --author='Peng Xiang <hi.pxiang@gmail.com>'
```

**Notice** `<>` was the essential sign for email address

```bash
# then use --force
git push origin master --force
```

<a id=reset></a>

#### reset
```bash
# help page
--soft
    Does not touch the index file nor the working tree at all (but resets
    the head to <commit>, just like all modes do). This leaves all your
    changed files "Changes to be committed", as git status would put it.

--mixed
    Resets the index but not the working tree (i.e., the changed files are
    preserved but not marked for commit) and reports what has not been
    updated. This is the default action.

--hard
    Resets the index and working tree. Any changes to tracked files in the
    working tree since <commit> are discarded.
```

default was **--mixed**

```bash
git reset HEAD -- filename
```

<a id=tag></a>
#### tag

delete tag both on local and remote machine

```bash
#!/bin/bash
set -x
tags=`git tag`
for tag in $tags; do
    git tag --delete $tag
    git push origin :refs/tags/$tag
done
```

<a id=remote></a>

#### remote

- directly update our local repo with any changes made in the central repo

  set **upstream** branch

  ```bash
  git remote add upstream <url-to-central-repo>
  git pull upstream
  ```

- change your remote's URL

  ```bash
  # check
  git remote -v
  origin  https://github.com/iqiyi/dpvs (fetch)
  origin  https://github.com/iqiyi/dpvs (push)
  
  git remote set-url origin https://github.com/xiangp126/dpvs
  
  # check
  git remote -v
  origin  https://github.com/xiangp126/dpvs (fetch)
  origin  https://github.com/xiangp126/dpvs (push)
  ```

<a id=cherry></a>

#### cherry-pick

Apply the changes introduced by some existing commits

- cherry-pick from a different branch

```bash
git checkout <branch-to-cherry-pick>
git cherry-pick <commit-id-to-cherry-pick-from>
```

- cherry-pick from a different repository

  You'll need to add the other repository as a remote, then  fetch its changes. From there you see the commit and you can cherry-pick it.

```bash
# Here's an example of the remote-fetch-merge.
cd /home/you/projectA
git remote add projectB /home/you/projectB
git fetch projectB

# Then you can:
git cherry-pick <first_commit>..<last_commit>
```

<a id=revert></a>

#### revert

[Git Revert Tutorials](https://www.atlassian.com/git/tutorials/undoing-changes/git-revert)

```
NAME
       git-revert - Revert some existing commits

SYNOPSIS
       git revert [--[no-]edit] [-n] [-m parent-number] [-s] [-S[<keyid>]] <commit>...
       git revert --continue
       git revert --quit
       git revert --abort
```

---
<a id=github></a>
### Github
<a id=bare></a>
#### make a bare repository
On remote machine run as server like `Github`

```bash
# git bare local private repository
# use git-shell | not bash
useradd -m -s "$(which git-shell)" git
cd /usr/local/src/

git init --bare sample
sudo chown -R git:git sample
```

On Local Machinde

```bash
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

<a id=empty></a>
#### make repo empty
make new branch

```bash
git checkout --orphan orphan
git add -A
git commit -am "Init commit"
git branch -D master
```

Rename current branch to master and push

```bash
git branch -m master
git push origin master --force
```

<a id='untrace'></a>
#### untrace certain files
> refer <https://gist.github.com/nasirkhan/5919173>

```bash
git update-index --assume-unchanged FILE_NAME
git update-index --no-assume-unchanged FILE_NAME
```

<a id=forafork></a>
#### [Configuring a remote for a fork](https://help.github.com/articles/configuring-a-remote-for-a-fork/)

List the current configured remote repository for your fork

```bash
git remote -v
origin  https://github.com/YOUR_USERNAME/YOUR_FORK.git (fetch)
origin  https://github.com/YOUR_USERNAME/YOUR_FORK.git (push)
```

Specify a new remote `upstream` repository that will be synced with the fork

```bash
git remote add upstream https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git
```

Verify the new upstream repository you've specified for your fork

```bash
git remote -v
origin    https://github.com/YOUR_USERNAME/YOUR_FORK.git (fetch)
origin    https://github.com/YOUR_USERNAME/YOUR_FORK.git (push)
upstream  https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git (fetch)
upstream  https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git (push)
```

<a id='sync'></a>
#### [Syncing a fork](https://help.github.com/articles/syncing-a-fork/)

Fetch the branches and their respective commits from the `upstream` repository.<br>
Commits to master will be stored in a **local** branch, `upstream/master`

```bash
git fetch upstream
remote: Counting objects: 75, done.
remote: Compressing objects: 100% (53/53), done.
remote: Total 62 (delta 27), reused 44 (delta 9)
Unpacking objects: 100% (62/62), done.
From https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY
 * [new branch]      master     -> upstream/master
```

Check out your fork's local `master` branch

```bash
git checkout master
Switched to branch 'master'
```

Merge the changes from **local** `upstream/master` into your **local** `master` branch.<br>
This brings your **fork's** `master` branch _into sync with_ the **upstream** repository, without losing your local changes.

```bash
git merge upstream/master
Updating a422352..5fdff0f
Fast-forward
 README                    |    9 -------
 README.md                 |    7 ++++++
 2 files changed, 7 insertions(+), 9 deletions(-)
 delete mode 100644 README
 create mode 100644 README.md
```

If your local branch didn't have any unique commits, Git will instead perform a "fast-forward":

```bash
git merge upstream/master
Updating 34e91da..16c56ad
Fast-forward
 README.md                 |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)
```