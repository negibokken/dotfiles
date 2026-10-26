# zsh

`_zshrc` は PATH、履歴、補完、キー操作とツールの初期化を管理する。
エイリアスは `aliases.zsh`、補助関数は `functions.zsh` に置く。
読み込み先は `_zshrc` 自身の実体位置から解決するため、worktree を参照するシンボリックリンクでも利用できる。

## 起動処理

-   `~/.local/bin` のラッパーを最優先にし、その次に mise の shim を検索する。
-   pnpm のグローバルコマンド用に `$PNPM_HOME` を残す。旧 pnpm のある `$PNPM_HOME/bin` は追加しない。
-   tmux は対話シェルかつ標準入力・出力に TTY があり、tmux 内・cron・VS Code・Orca 以外の場合に自動起動する。
-   `compinit` は標準のキャッシュと権限確認を維持して 1 回実行する。
-   Starship と git-wt は、インストールされている場合に共有設定で初期化する。
-   シンタックスハイライトはキー操作とウィジェットの定義後に読み込む。

端末固有の値、認証情報、業務用の関数・エイリアスは `${ZDOTDIR:-$HOME}/.zshrc.local` に置く。
このファイルは任意で、共有の関数・エイリアスを読み込んだ後、補完とツールの初期化前に読み込まれる。
Starship・git-wt の初期化や共通の PATH 設定をローカル側で重複させない。
Go の `GOROOT` は固定せず、mise に管理を任せる。

## コマンドの移行

| 以前の設定                                 | 現在の操作                                                             |
| ------------------------------------------ | ---------------------------------------------------------------------- |
| `rm='rm -rf'`                              | 標準の `rm`。再帰削除は `rm -r` を明示する                             |
| README 付きディレクトリを作る独自 `mktemp` | `mktmp [名前] [-d 説明]`。`mktemp` は標準コマンド                      |
| `gb`・`cb`                                 | `wt` で既存 worktree を選ぶ。作成・移動は `git wt <branch>`            |
| `hpr`・`hprc`                              | 閲覧は `gh pr list`・`gh pr view`。作成は `gh-write pr create --draft` |
| `codegrep`・`nfind`                        | `rg`・`fd`                                                             |
| `dcku`・`dckd`                             | 同じ名前で `docker compose up/down` を実行                             |
| `ns`                                       | package.json のスクリプトを選び、`pnpm run` で実行                     |
| 独自 `vex`                                 | Ctrl-X Ctrl-E または Alt-E で標準の `edit-command-line` を起動         |

競プロ・ファイル種類ごとの専用補助（`vip`・`vic`・`mkcode`・`ere`・`atcoder`・`leetcode`）、色表示用の `printColors`・`cecho`、未初期化の `cdr` を使う Ctrl-X 操作は削除した。
Ctrl-R の peco 履歴検索、`mkdev`・`mkcd`・`gp`・`temp` は維持する。
`temp` と `wt` は表示行を解析するときも空白を含むディレクトリ名を保持し、選択を取り消した場合は移動しない。

## 検証

Python 3.9 以降、zsh、jq を使って、一時 HOME 内で起動・キー操作・補助関数を検証する。
tmux と対話的な選択はスタブを使う。git-wt があれば、一時リポジトリで実際の worktree 移動も検証する。
macOS 標準版と Homebrew 版の zsh が存在する場合は、両方を対象にする。

```sh
/usr/bin/python3 zshconf/tests/startup.py
shfmt -ln zsh -i 2 -w _zshrc zshconf/aliases.zsh zshconf/functions.zsh
shfmt -ln zsh -i 2 -d _zshrc zshconf/aliases.zsh zshconf/functions.zsh
```

shfmt は zsh 対応の 3.13.1 以降を使う。
ハイフンを含む連想配列キーを一部の版が算術式として整形するため、git-wt の存在確認には zsh 組み込みの `whence -p` を使う。

端末固有の `~/.zshenv` では、必要なときだけプロファイラを有効にする。

```zsh
[[ $ZSH_PROFILE == 1 ]] && zmodload zsh/zprof
[[ -r $HOME/.cargo/env ]] && source "$HOME/.cargo/env"
```

```sh
IS_CRON=true ZSH_PROFILE=1 zsh -ilc 'unset HISTFILE; zprof'
```

設定を切り替えた後は、新しいシェルを開くか `x` で再起動する。
