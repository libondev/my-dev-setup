alias p="git push & git push --tag"
alias l="git pull"
alias d="node --run dev"
alias s="node --run sit"
alias u="node --run uat"
alias b="node --run build"
alias i="ni"
alias r="nr"
alias cls="clear"
alias rnm='find . -name "node_modules" -type d -prune | xargs rm -rf'
alias undo="git reset --soft HEAD^"
alias redo="git reset --hard HEAD^"
alias py="python "

alias ..="cd .."
alias .='codeAlias'

function codeAlias() {
  if [ $# -eq 0 ]; then
    # 如果没有参数，则执行 code ./
    command code -r ./
  elif [ $# -eq 1 ]; then
    # 如果只有一个参数，则执行 code $1
    command code -r "$1"
  else
    # 如果有多个参数，则输出错误信息
    echo "Usage: code [path]"
  fi
}

alias kill="killPort"

function killPort() {
    local pid=$(netstat -ano | grep ":${1} " | grep LISTENING | awk '{print $5}')
    if [ -n "$pid" ]; then
        taskkill //PID $pid //F
    else
        echo "No process found on port $1"
    fi
}
