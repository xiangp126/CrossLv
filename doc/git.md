## Git

### Contents
- [Git Basic Commands](#git)
    - [alias](#alias)
    - [amend](#amend)
    - [apply](#apply)
    - [blame](#blame)
    - [branch](#branch)
    - [cherry](#cherry)
    - [cherry-pick](#cherry-pick)
    - [config](#config)
    - [checkout](#checkout)
    - [commit](#commit)
    - [diff](#diff)
    - [log](#log)
    - [pull](#pull)
    - [revert](#revert)
    - [reflog](#reflog)
    - [restore](#restore)
    - [reset](#reset)
    - [remote](#remote)
    - [rebase](#rebase)
    - [show](#show)
    - [tag](#tag)

- [GitHub Associated Manipulation](#github)
    * [Make a **bare** repository](#bare)
    * [Make repo empty](#empty)
    * [How to **untrace** certain files](#untrace)
    * [Configuring a remote for a fork](#forafork)
    * [Syncing a fork](#sync)

<a id=git></a>
### Git Basic Commands

<a id=pull></a>
#### [pull](http://hungyuhei.github.io/2012/08/07/better-git-commit-graph-using-pull---rebase-and-merge---no-ff.html)

_To make commits looked more clean, use `git pull --rebase`_

```bash
# git pull origin master
git pull origin master --rebase
```

<a id=push></a>
#### push
use the -u flag (upstream) when you make your first push

how to push newly created branch to upstream

```bash
-u, --set-upstream
git push -u origin BRANCH
```

or directly `push`

```bash
git push origin BRANCH
```

<a id=alias></a>
#### alias
```bash
git config alias.co checkout
git config --global alias.dfcs 'diff --cached --stat'
```

<a id=restore></a>
#### restore - Discard or unstage uncommitted local changes

- unstage uncommitted local changes

```bash
git restore --staged <Path-of-File>
```

<a id=branch></a>
#### branch
- list all branches, using parameter `-a`

```bash
git branch -a
```

- delete **local** branch

```bash
git branch -d <Branch_Name>
```

- delete **remote** branch, add `:` before `branch_name`

```bash
git push origin :<branch_name>

# Example: delete branch 'feature'
git push origin :feature
```

- rename branch

```bash
-m, --move
    Move/rename a branch and the corresponding reflog.

# rename current branch to <NEW-BRANCH-NAME>
git branch -m <NEW-BRANCH-NAME>

# Alternative
git branch --move <OLD-BRANCH-NAME> <NEW-BRANCH-NAME>
```

- Given one commit id, find which branch it belongs to

using paramter `--contains`, refer to [Finding what branch a Git commit came from](https://stackoverflow.com/questions/2706797/finding-what-branch-a-git-commit-came-from)

```bash
git branch -a --contains <Commit_Hash>
```

<a id=checkout></a>
#### checkout
- make a new branch, use paremeter `-b`

```bash
git checkout -b <New-Branch>
```

- switch to another branch

```bash
git checkout <New-Branch>
```

- check out paths from the index

```bash
git checkout <Path-of-File>
# or with force
git checkout --force <Path-of-File>
```

```
-f, --force
    When switching branches, proceed even if the index or the working tree differs from HEAD. This is used to throw away local changes.
    When checking out paths from the index, do not fail upon unmerged entries; instead, unmerged entries are ignored.
```

- remove already `indexed` file back to `workspace`

```bash
# from workspace to index
git add <file_name>

# then regret add
git checkout <file_name>
```

- create new branch from history commit and switch to it meanwhile

```bash
git checkout -b <branch_name> <sha1>
```

<a id=diff></a>
#### diff
```bash
git diff --since=1.hour.ago --until=1.minute.ago
```

<a id=log></a>
#### log
- match specific author

Limit the commits output to ones with author/committer header lines that match the specified pattern (regular expression)

```bash
git log -p --author='PENG'
```

- match specific commit message

Limit the commits output to ones with log message that matches the specified pattern (regular expression)

```bash
# --grep=<pattern>
git log --grep="Revert"
```

- show the log of specific branch

```bash
git log Repo_Name/Branch_Name
```

<a id=reflog></a>
#### reflog
Manage reflog information

```bash
git reflog
git reflog show <BRANCH_NAME>
```

<a id=cherry></a>
#### cherry
Find commits yet to be applied to upstream

```bash
-v
Show the commit subjects next to the SHA1s.

Syntax:
git cherry [-v] <upstream> <head>

For Example:
git cherry -v master develop_branch

+ 18e3ba57addc Initial Sync transfer

found one commit in develop_branch but not yet in master.
```

<a id=blame></a>
#### blame

Show what revision and author last modified each line of a file

    -L <start>,<end>, -L :<funcname>

When you are interested in **finding the origin for lines** 40-60 for file `foo.c`, you can use the `-L` option ():

```bash
# they mean the same thing, both ask for 21 lines starting at line 40
git blame -L 40,60 foo.c
git blame -L 40,+21 foo.c

# see changes only for specific function
git blame -L:write_data_func foo.c
```

<a id=apply></a>
#### apply

```bash
NAME
       git-apply - Apply a patch to files and/or to the index

DESCRIPTION
       Reads the supplied diff output (i.e. "a patch") and applies it to files. When running from a subdirectory in a
       repository, patched paths outside the directory are ignored. With the --index option the patch is also applied to the
       index, and with the --cached option the patch is only applied to the index. Without these options, the command applies
       the patch only to files, and does not require them to be in a Git repository.

       -R, --reverse
           Apply the patch in reverse.

```

<a id=show></a>
#### show
```bash
NAME
       git-show - Show various types of objects

SYNOPSIS
       git show [options] [<object>...]

DESCRIPTION
       Shows one or more objects (blobs, trees, tags and commits).

       For commits it shows the log message and textual diff. It also presents the merge commit in a special format as produced
       by git diff-tree --cc.
```

Question: I want to revert changes made by a particular commit to a given file only.

Tips:

```bash
git show some_commit_sha1 -- some_file.c | git apply -R
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

<a id=rebase></a>
#### rebase
EXP: use rebase to merge three recent commit into one

take A/B/C for example, H denotes HEAD

```bash
# HEAD~3 was not included in the operation
git rebase HEAD~3

A <- B <- C  <- D

H   H~1   H~2  H~3
```

then the commit C was list lowest and A was on the top

```bash
pick XXXX A
pick XXXX B
pick XXXX C

... some words to guide you
```

change pick at the left of each commit id to s or squash

```bash
pick XXXX A
s XXXX B
s XXXX C

... some words to guide you
```

then edit the merged commit message as you wish

<a id=cherry-pick></a>
#### cherry-pick

Apply the changes introduced by some existing commits

- cherry-pick specific commit from different branch

```bash
git checkout <branch-to-cherry-pick>
git cherry-pick <commit-id-to-cherry-pick-from>
```

- cherry-pick specific commit from a different repository

  You'll need to add the specific repository as a remote repository of yours, then fetch its changes. From there you can see the commit and then cherry-pick it.

```bash
# Here's an example of the remote-fetch-merge.
cd /home/you/projectA
git remote add projectB /home/the/projectB
git fetch projectB

# Then you can:
git cherry-pick <commit-id-to-cherry-pick-from>
```

- cherry-pick but not commit, `-n/--no-commit`

Only pick code changes but not make a commit

```bash
git cherry-pick --no-commit <commit-id-to-cherry-pick-from>
```

- **cherry-pick a range of commits in a row!! Verified | Important**

refer to [How to cherry pick a range of commits and merge into another branch?
](https://stackoverflow.com/questions/1994463/how-to-cherry-pick-a-range-of-commits-and-merge-into-another-branch)

```bash
# To cherry-pick all the commits from commit A to commit B (where A is older than B, and you want to keep A included), run:
git cherry-pick A^..B

#If you want to ignore A itself, run:
git cherry-pick A..B

# both cases B is included by default
```

- how to record the commit

```bash
-x
    When recording the commit, append a line that says "(cherry picked from commit ...)" to the original commit message in order to indicate which commit this change was cherry-picked from.
    This is done only for cherry picks without conflicts.
    Do not use this option if you are cherry-picking from your private branch because the information is useless to the recipient.
    If on the other hand you are cherry-picking between two publicly visible branches
    (e.g. backporting a fix to a maintenance branch for an older release from a development branch), adding this information can be useful.
```

- cherry-pick specific **merge** from different branch(**Deprecated**)

```bash
-m parent-number

--mainline parent-number

Usually you cannot cherry-pick a merge because you do not know which side of the merge should be considered the mainline.  This option specifies the parent number (starting from 1) of the mainline and allows cherry-pick to replay the change relative to the specified parent.
```

and you can try

```bash
git cherry-pick -m 1 <merge-hashid>
```

**how to explain**

```bash

For example, if your commit tree is like below:

- A - D - E - F -   master
   \     /
    B - C           branch one

then git cherry-pick E will produce the issue you faced.

git cherry-pick E -m 1 means using D-E, while git cherry-pick E -m 2 means using B-C-E.
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

if only want to revert some specific files within one commit, here is a workaround

```bash
git revert <SHA> --no-commit
git reset --hard <the_file_you_won't_want_modify>
# check
git status
git commit
```

<a id=config></a>
#### config

refer [setting tabwidth to 4 in git show / git diff](https://stackoverflow.com/questions/10581093/setting-tabwidth-to-4-in-git-show-git-diff)

```bash
git config --global core.pager 'less -x1,5'
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
