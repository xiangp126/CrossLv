## Github
### git patch | apply
ToDo
---

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

###  Delete remote branch

```git
git push origin :[branch_name]

# Exp: delete branch 'feature'
git push origin :feature
```

### Untrace certain files
> refer <https://gist.github.com/nasirkhan/5919173>

```git
git update-index --assume-unchanged FILE_NAME
git update-index --no-assume-unchanged FILE_NAME
```

### Syncing a fork
> refer <https://help.github.com/articles/syncing-a-fork/>