# Git setup

```sh
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"

# 设置默认的分支名为 main
git config --global init.defaultBranch main

# auto set upstream
git config --global push.autoSetupRemote true

# 取消忽略大小写
git config --global core.ignorecase false

# 将 core.autocrlf 设置为 input（在提交时仅转换为 LF，在检出时不转换，避免在不同设备上编辑的时候换行符不一致的问题）：
git config --global core.autocrlf input
# 或者禁用自动转换
git config --global core.autocrlf false
```
