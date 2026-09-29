# Git 全局配置(Windows)

> 适用于 Windows 多设备协作开发,核心目标是避免 CRLF 行尾污染导致的
> 「同一文件在多人之间反复全量 diff / 冲突」问题。
>
> 环境基准:Git 2.56.0.windows.1,安装于 `D:\Git\`
> 配置文件:`C:\Users\<用户名>\.gitconfig`
>
> 完整复制执行:
>
> ```sh
> git config --global user.name "Your Name"
> git config --global user.email "your_email@example.com"
> ```
>
> 校验:`git config --global --list`

## 一、行尾(多人协作冲突的根因,优先级最高)

```sh
# 入库时把 CRLF 转成 LF,检出时保持原样不做转换。
# 这是避免文件反复冲突的第一条配置。Git for Windows 安装程序会在系统级
# 配置里写 autocrlf=true,本条会将其覆盖为 input。
git config --global core.autocrlf input

# 安全网:检出时若发现会不可逆地覆盖已有内容,直接报错而非静默改写
git config --global core.safecrlf true

# 兜底值:仅对 .gitattributes 中未显式声明 eol 的文本文件生效
git config --global core.eol native

# 让 git 忽略行尾 CR 造成的「尾随空白」告警,减少无意义提示
git config --global core.whitespace cr-at-eol
```

## 二、Windows 平台特有(路径长度、大小写、符号链接)

```sh
# 突破 Windows 260 字符路径上限。pnpm monorepo 的 node_modules/.pnpm
# 深层路径极易超限,不开此项会随机报 Filename too long
git config --global core.longpaths true

# NTFS 不区分大小写,必须为 true。
# 若设为 false,Git 会认为本机区分大小写,导致
# `import Button from './Button.vue'` 在本地可用、推到 Linux CI 却 Module not found
# 注意:macOS / Linux 端才应显式设为 true(APFS 默认同样不区分大小写)
git config --global core.ignorecase true

# 忽略文件权限位差异,避免在 WSL / 容器中对脚本 chmod +x
# 造成整个目录出现虚假 mode 变更
git config --global core.filemode false

# Windows 默认无创建符号链接权限,关闭以免检出时报错
git config --global core.symlinks false

# 让 git status / diff 显示可读中文路径,
# 而不是 \346\226\207 这类八进制转义码
git config --global core.quotepath true

# Windows 端保持 false;仅 Mac 端需要设为 true,
# 以统一 HFS+ 文件名 NFD 与 Git 索引 NFC 的编码差异
git config --global core.precomposeunicode false
```

## 三、冲突处理(让冲突可解、少重复劳动)

```sh
# 冲突标记中额外显示冲突发生前的原始内容,大幅降低误删整段代码的风险。
# 对比默认的 merge 样式,zdiff3 多出一段以 | 分隔的原始内容
git config --global merge.conflictstyle zdiff3

# 记住冲突解法并自动复用:同一个冲突第二次出现时直接套用上次的解决结果,
# 多人反复 rebase 同一分支时收益明显
git config --global rerere.enabled true

# pull 时使用 rebase 而非产生多余的 merge commit,保持提交历史线性
git config --global pull.rebase true

# 更精确的 diff 算法,减少无意义的整行变更
git config --global diff.algorithm histogram
```

## 四、仓库初始化与推送

```sh
# 新建仓库的默认分支名。会覆盖安装程序写入的 master
git config --global init.defaultBranch main

# 首次 push 时自动关联远程分支,免去每次手动加 -u
git config --global push.autoSetupRemote true

# 推送本地有、但远程还没有的所有标签
git config --global push.followTags true
```

## 五、远程同步

```sh
# fetch 后自动清理远程已删除的分支引用,无需手动 git remote prune
git config --global fetch.prune true

# 同上,清理已删除的标签引用
git config --global fetch.pruneTags true

# fetch 覆盖所有 remote,适用于多 remote 场景
git config --global fetch.all true
```

## 六、Rebase 体验

```sh
# 自动把 fixup! / squash! 开头的提交折叠整理
git config --global rebase.autoSquash true

# rebase 前自动 stash 未提交的改动,结束后恢复
git config --global rebase.autoStash true

# rebase 时同步更新其他指向同一提交的分支指针
git config --global rebase.updateRefs true
```

## 七、界面与排序

```sh
# 命令打错时询问是否纠正,而不是直接报错
git config --global help.autocorrect prompt

# 表格化输出分支列表、日志等
git config --global column.ui auto

# 分支列表按最近提交时间倒序
git config --global branch.sort -committerdate

# 标签按版本号语义排序,而非字典序
git config --global tag.sort version:refname
```

## 八、仓库级保障(必须提交进版本库)

以上配置都是**每台机器各自的本地设置**,新成员装完 Git 若没执行,
CRLF 仍会混入仓库。因此需要在仓库根目录的 `.gitattributes` 中锁定规则,
这是跨机器、跨平台不可绕过的硬保障:

```gitattributes
# 所有文本文件一律以 LF 入库和检出,不依赖本机 autocrlf 设置
* text=auto eol=lf

# 以下规则需放在通配规则之后以覆盖其 eol 设置

# Shell 脚本:显式声明 text(而非 auto),跳过类型嗅探
*.sh text eol=lf

# 以下文件在 Windows 上确实需要 CRLF 才能正常执行
*.bat text eol=crlf
*.ps1 text eol=crlf

# 常见盲区:SVG 本质是 XML 文本,若被误判为 binary 会在合并时反复冲突
*.svg text eol=lf

# 二进制文件,禁止任何行尾转换
*.png binary
*.jpg binary
*.jpeg binary
*.gif binary
*.webp binary
*.ico binary
*.pdf binary
*.zip binary
```

配套的 `.gitignore` 注意事项:

```gitignore
# ❌ 不要忽略锁文件。多人协作下锁文件不入库,
# 会导致各人及 CI 装出不同的依赖树,构建产物不一致。
# 若确实要忽略子包锁文件,应写成 packages/*/pnpm-lock.yaml
# **/pnpm-lock.yaml
```

## 九、验证与排错

```sh
# 查看全部全局配置
git config --global --list

# 查看某项配置的生效值及其来源文件(排查多级覆盖的关键命令)
git config --get --show-origin core.autocrlf

# 查看 git 对某文件实际应用的行尾规则
git check-attr text eol -- src/index.ts
git check-attr text eol -- setup.bat

# 检查索引中是否已混入 CRLF(输出为空表示干净)
git grep -Il -e '\r$' HEAD

# 一键规范化整个仓库索引(修改 .gitattributes 后执行一次)
git add --renormalize .
```

## 十、macOS / Linux 端差异

| 配置项 | Windows | macOS | Linux |
| --- | --- | --- | --- |
| `core.autocrlf` | `input` | `input` | `input`(可省略) |
| `core.ignorecase` | `true` | `true` | `false` |
| `core.filemode` | `false` | `false` | `true` |
| `core.symlinks` | `false` | 取决于 `git config --global core.symlinks true` | `true` |
| `core.precomposeunicode` | `false` | `true` | 不适用 |
| `core.longpaths` | `true` | 不适用 | 不适用 |
