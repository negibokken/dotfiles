function mkdev() {
  if [[ $# != 1 || -z $1 ]]; then
    print -u2 'Usage: mkdev dir-name'
    return 2
  fi
  local root_dir destination
  root_dir=$(ghq root) || return
  destination=$root_dir/github.com/${B_PROFILE:-negibokken}/$1
  if [[ -e $destination || -L $destination ]]; then
    print -u2 -r -- "Directory already exists: $destination"
    return 1
  fi
  command mkdir -p -- "$destination" && builtin cd -- "$destination" || return
  print -r -- "# $1" >README.md
  git init && git add -- README.md && git commit -m 'Initial commit'
}

function mktmp() {
  local name='' description='' destination
  while (($#)); do
    case $1 in
    -h | --help)
      print 'Usage: mktmp [dir-name] [-d|--description description]'
      return
      ;;
    --version)
      print 'mktmp (dotfiles)'
      return
      ;;
    -d | --description)
      if (($# < 2)); then
        print -u2 'mktmp: description is required'
        return 2
      fi
      description=$2
      shift 2
      ;;
    --)
      shift
      if [[ $# != 1 || -n $name ]]; then
        print -u2 'mktmp: expected one directory name after --'
        return 2
      fi
      name=$1
      shift
      ;;
    -*)
      print -u2 -r -- "mktmp: unknown option: $1"
      return 2
      ;;
    *)
      if [[ -n $name ]]; then
        print -u2 'mktmp: expected at most one directory name'
        return 2
      fi
      name=$1
      shift
      ;;
    esac
  done
  if [[ -z $name ]]; then
    zmodload zsh/datetime
    strftime -s name '%Y-%m-%d-%H-%M-%S'
  fi
  destination=$HOME/temp/$name
  command mkdir -p -- "${destination:h}" && command mkdir -- "$destination" || return
  {
    print -r -- "# $name"
    if [[ -n $description ]]; then
      printf '\n## Description\n\n%s\n' "$description"
    fi
  } >"$destination/README.md" || return
  builtin cd -- "$destination"
}

function mkcd() {
  if [[ $# != 1 || -z $1 ]]; then
    print -u2 'Usage: mkcd dir-name'
    return 2
  fi
  if [[ -e $1 || -L $1 ]]; then
    print -u2 -r -- "Directory already exists: $1"
    return 1
  fi
  command mkdir -p -- "$1" && builtin cd -- "$1"
}

function gr() {
  local root_dir
  root_dir=$(git rev-parse --show-toplevel) && builtin cd -- "$root_dir"
}

function gstat() {
  git log --since=midnight --shortstat --oneline |
    command grep changed | awk '{ s += $4+$6 } END { print s }'
}

function gat() {
  git add . && git cm -m "Add ${PWD:h:t} ${PWD:t}" &&
    git push origin "$(git branch --show-current)"
}

function gdraft() {
  local -a args=(push --include-untracked)
  [[ -n $1 ]] && args+=(-m "$1")
  git stash "${args[@]}" && git stash apply 'stash@{0}'
}

function peco-select-history() {
  local selected
  selected=$(builtin history -n -r 1 2>/dev/null | peco --query "$LBUFFER") || return 0
  [[ -n $selected ]] || return 0
  BUFFER=$selected
  CURSOR=${#BUFFER}
  zle clear-screen
}

function temp() {
  local -a directories=("$HOME"/temp/*(N/om))
  (($#directories)) || return 0
  local selected index directory summary
  selected=$(
    for ((index = 1; index <= $#directories; index++)); do
      directory=$directories[index]
      summary=''
      if [[ -r $directory/README.md ]]; then
        summary=$(head -n 5 -- "$directory/README.md" | tr '\n\t' '  ')
      fi
      printf '%d\t%s\t%s\n' "$index" "${directory:t}" "$summary"
    done | peco
  ) || return 0
  [[ -n $selected ]] || return 0
  index=${selected%%$'\t'*}
  [[ $index == <-> ]] && ((index >= 1 && index <= $#directories)) || return 1
  builtin cd -- "$directories[index]"
}

function pro() {
  local -a directories=("$HOME"/Project/*(N/))
  (($#directories)) || return 0
  local destination
  destination=$(printf '%s\n' "${directories[@]}" | peco) || return 0
  [[ -n $destination ]] || return 0
  builtin cd -- "$destination"
}

function ghq-peco() {
  local destination
  destination=$(ghq list -p | peco) || return 0
  [[ -n $destination ]] || return 0
  builtin cd -- "$destination"
}

function wt() {
  local selected destination
  selected=$(git wt --json | jq -r '.[] | "\(.path)\t\(.branch // "(detached)")"' | peco) || return 0
  [[ -n $selected ]] || return 0
  destination=${selected%%$'\t'*}
  git wt "$destination"
}

function peco-pkill() {
  local selected pid
  selected=$(ps aux | peco | awk '{ print $2 }') || return 0
  for pid in ${(f)selected}; do
    [[ $pid == <-> ]] || continue
    kill -- "$pid" && print -r -- "Killed $pid"
  done
}

function peco-dpkill() {
  local selected container
  selected=$(docker ps --format '{{.ID}}\t{{.Names}}' | peco) || return 0
  for container in ${(f)selected}; do
    docker kill "${container%%$'\t'*}"
  done
}

function peco-dpexec() {
  local selected container
  selected=$(docker ps --format '{{.ID}}\t{{.Names}}' | peco) || return 0
  for container in ${(f)selected}; do
    docker exec -it "${container%%$'\t'*}" /bin/bash
  done
}

function peco-node-scripts() {
  local selected script
  [[ -r package.json ]] || {
    print -u2 'package.json not found'
    return 1
  }
  selected=$(jq -r '.scripts // {} | to_entries[] | [.key, .value] | @tsv' package.json | peco) || return 0
  [[ -n $selected ]] || return 0
  script=${selected%%$'\t'*}
  (($+commands[pbcopy])) && print -r -- "pnpm run ${(q)script}" | pbcopy
  pnpm run "$script" "$@"
}

function delete-merged-branches() {
  local branch
  while IFS= read -r branch; do
    case $branch in
    main | master | develop) continue ;;
    esac
    git branch -d -- "$branch"
  done < <(git for-each-ref --merged HEAD --format='%(if)%(HEAD)%(then)%(else)%(refname:short)%(end)' refs/heads | command grep -v '^$')
}

function difit-remote() {
  local branch
  branch=$(git symbolic-ref --short HEAD) && difit . "origin/$branch"
}

function pwdc() {
  if (($+commands[pbcopy])); then
    print -rn -- "$PWD" | pbcopy
  elif (($+commands[xclip])); then
    print -rn -- "$PWD" | xclip -selection clipboard
  else
    print -u2 'pwdc: pbcopy or xclip is required'
    return 1
  fi
}
