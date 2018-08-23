## Github

* [Syncing a fork](#sync)
* [Make repo empty](#empty)
* [Delete remote branch](#delete)
* [Untrace certain files](#untrace)

### git patch | apply
ToDo
---

<a id = 'empty'></a>
### Make repo empty
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

<a id = 'delete'></a>
###  Delete remote branch

```git
git push origin :[branch_name]

# Exp: delete branch 'feature'
git push origin :feature
```

<a id = 'untrace'></a>
### Untrace certain files
> refer <https://gist.github.com/nasirkhan/5919173>

```git
git update-index --assume-unchanged FILE_NAME
git update-index --no-assume-unchanged FILE_NAME
```
---

<a id = 'sync'></a>
### Syncing a fork

follow steps:

1. [Configuring a remote for a fork](https://help.github.com/articles/configuring-a-remote-for-a-fork/)<br>
2. [Syncing a fork](https://help.github.com/articles/syncing-a-fork/)