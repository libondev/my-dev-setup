# Git setup

https://blog.gitbutler.com/how-git-core-devs-configure-git/

```sh
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"

# 设置默认的分支名为 main
git config --global init.defaultBranch main

# 在项目仓库首次设置 remote 的时候自动关联远程和本地分支
git config --global push.autoSetupRemote true
# 推送本地有但服务器没有的所有标签
git config --global push.followTags true

git config --global fetch.prune true
git config --global fetch.pruneTags true
git config --global fetch.all true

# 如果打错了命令则会猜测正确意思并试图执行
git config --global help.autocorrect prompt

# 取消忽略大小写
git config --global core.ignorecase false

# 让 git diff 忽略换行符差异（不改变存储行为）
git config --global core.whitespace cr-at-eol

# 切换比对的算法
git config --global diff.algorithm histogram

git config --global column.ui auto
git config --global branch.sort -committerdate
git config --global tag.sort version:refname

# 优化 rebase 体验
git config --global rebase.autoSquash true
git config --global rebase.autoStash true
git config --global rebase.updateRefs true


```
