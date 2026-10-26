# Neovim

LazyVim を土台にした設定です。プラグインの版は `lazy-lock.json` で管理します。

## 構成

| 場所                      | 役割                                         |
| ------------------------- | -------------------------------------------- |
| `init.lua`                | LazyVim の初期化とコマンドの登録             |
| `lua/config/options.lua`  | 基本設定、補完・検索エンジンの選択           |
| `lua/config/keymaps.lua`  | エディタと独自機能のキー設定                 |
| `lua/config/autocmds.lua` | ファイル更新確認、Markdown の自動整形無効化  |
| `lua/config/commands.lua` | 独自コマンドの軽量な入口                     |
| `lua/config/paths.lua`    | ノートの保存先                               |
| `lua/config/lazy.lua`     | プラグイン管理の初期化                       |
| `lua/plugins/`            | プラグインごとの設定・キー・読み込み条件     |
| `lua/features/`           | ノート、ファイル操作、文字数表示、計測の実装 |
| `after/ftplugin/`         | ファイル種別ごとの追加設定                   |
| `tests/`                  | 回帰テストと実 UI の性能計測                 |

基本設定は `options.lua`、通常のキーは `keymaps.lua` に追加します。プラグインのキーは対応する spec の `keys` に置きます。`keys`・`cmd`・`event` で読み込み条件を指定し、spec のトップレベルからプラグインを `require` しないようにします。

## 主なキー

`<leader>` は Space です。

| キー／コマンド                    | 操作                                                           |
| --------------------------------- | -------------------------------------------------------------- |
| `Ctrl-j`                          | 挿入モード終了                                                 |
| `Ctrl-n` / `Ctrl-p`               | 補完候補の次／前                                               |
| `Ctrl-y` / `Ctrl-e`               | 補完候補の確定／中止                                           |
| Enter                             | 改行（補完の確定は `Ctrl-y`）                                  |
| Tab / Shift-Tab                   | スニペット内の移動、通常は元のキー動作                         |
| `<leader>ff` / `fg` / `fb` / `fh` | ファイル／引数付き grep／バッファ／ヘルプ検索                  |
| `<leader>tr`                      | 最近使ったファイル                                             |
| `<leader>mv`                      | 移動先ディレクトリを選んでファイル移動                         |
| `<leader>e`                       | 左ペインの Oil を開閉                                          |
| `<leader>tt` / `tn` / `tp` / `tc` | タブの作成／次／前／閉じる                                     |
| Alt-z / `:Zettelkasten`           | ノートを作成してリンク挿入。選択中なら選択文字列を見出しに使用 |
| Alt-c / Alt-q / Alt-w             | 今日のノート／四半期ノート／週番号の挿入                       |
| `<leader>rn` / `:RenameToH1`      | 最初の H1 を使ってファイルをリネーム                           |
| `<leader>gp`                      | GitHub パーマリンクをコピー（選択範囲にも対応）                |
| `<leader>lg`                      | LazyGit                                                        |
| `<leader>ac`                      | Claude Code                                                    |
| `<leader>xe`                      | Emmet の abbreviation で囲む（Emmet language server が必要）   |
| Alt-= / `:NoNeckPain`             | 中央寄せ表示                                                   |
| F1 / F3                           | 設定を開く／プロファイラ切り替え                               |

補完は nvim-cmp に統一しています。Coc、blink.cmp、Copilot は使用しません。行・ブロックコメントの `gcc`・`gbc`・`gc{motion}`・`gb{motion}` と、`gco`・`gcO`・`gcA` は Comment.nvim で維持しています。

## ノート

保存先は `$SECOND_BRAIN`、未設定の場合は `~/Documents/obsidian/notes` です。Obsidian はその配下の Markdown または `:Obsidian…` コマンド実行時に読み込みます。Vault 内ではリンク・タグ補完、`gf`、`<leader>ch`、Alt-Enter を使えます。

今日のノートがローカルにない場合は、`origin/main` から非同期で取得します。通信失敗時は警告して新規バッファを開きます。取得中の編集や画面移動、同時に届いたローカルファイルを保護します。Git の index は変更しません。

ファイル移動・リネームでは移動先の既存ファイルを上書きせず、編集中の内容を維持します。

## 軽量化の方針

-   Telescope、独自機能、補完、Gitlinker、NoNeckPain、Emmet、プロファイラは必要な操作まで読み込みを遅らせます。
-   Oil と Snacks の基盤は起動時に初期化します。検索は Telescope に揃え、スクロールアニメーションを無効にしています。
-   スペルチェックは Markdown など文章用ファイルに限定します。Markdown のインデント幅 4 と自動整形無効化を維持しています。
-   ステータスラインの文字数はバッファの変更番号でキャッシュします。bigfile・特殊バッファの文字数は表示しません。
-   ファイルの更新確認はフォーカス復帰時に加え、バッファ移動・アイドル時は現在のファイルに限定して最大毎秒 1 回実行します。
-   blame はコードを開いた後に読み込み、カーソル停止時に更新します。
-   プラグイン更新の確認は `:Lazy check`、固定版への復元は `:Lazy restore` で行います。

## 検証・性能計測

リポジトリのルートから実行します。

```sh
nvim --headless --clean -l nvim/tests/create-zettelkasten.lua
nvim --headless --clean -l nvim/tests/features.lua
python3 nvim/tests/benchmark.py --check nvim/tests/integration.lua --output /tmp/nvim-integration.json
python3 nvim/tests/benchmark.py --runs 10 --output /tmp/nvim-benchmark.json
```

Python の計測は macOS/Linux の PTY で実際の Neovim UI を起動します。一時的な設定ディレクトリとサンプルファイルを使用し、インストール済みプラグインを共有します。計測中のプラグイン追加・更新と設定監視は無効です。初期描画の `--startuptime` と `VeryLazy` 処理完了、初回／2 回目の Telescope・Oil、バッファ切替を記録します。起動は各条件 10 回、操作は 3 回の中央値です。

変更前の設定を比較する場合は `--compare-config /path/to/baseline/nvim` を指定します。設定を交互に起動し、毎回順番を反転してマシン負荷とキャッシュの偏りを抑えます。

詳細を調べる場合は `:Lazy profile` または `NVIM_PROFILE=start nvim` を使います。F3 で記録を止めて保存先を指定できます。

```sh
# Lua の整形と確認（stylua が PATH にない場合は Mason の bin を指定）
stylua --config-path nvim/.stylua.toml nvim/init.lua nvim/lua nvim/tests
stylua --check --config-path nvim/.stylua.toml nvim/init.lua nvim/lua nvim/tests
uvx ruff format nvim/tests/benchmark.py
uvx ruff format --check nvim/tests/benchmark.py
prettier --write --print-width 200 --tab-width 2 nvim/lazy-lock.json
prettier --check --print-width 200 --tab-width 2 nvim/lazy-lock.json
```

## 計測結果（2026-10-26）

Neovim 0.11.5、実 UI 120×40、同一マシンで `71fae89` の設定と変更後を交互に各 10 回起動した中央値です。プラグインの追加・更新と profiling は無効化し、既存のインストール版を共有しました。絶対時間には測定時のマシン負荷を含みます。

| 条件                | 初期描画：変更前 |   変更後 | VeryLazy 完了：変更前 |   変更後 |
| ------------------- | ---------------: | -------: | --------------------: | -------: |
| 空起動              |         335.4 ms | 137.8 ms |              478.3 ms | 237.0 ms |
| Lua ファイル        |         506.0 ms | 379.4 ms |              654.9 ms | 530.9 ms |
| Vault 外の Markdown |         664.1 ms | 443.7 ms |              797.8 ms | 558.8 ms |
| Vault 内の Markdown |         535.5 ms | 426.5 ms |              680.5 ms | 536.4 ms |

空起動時の読み込みプラグインは 31 個から 18 個に削減しました。操作を 3 回計測した中央値では、初回検索は 99.3→100.5 ms とほぼ同等、2 回目の検索は 52.8→34.1 ms、初回 Oil は 134.4→110.7 ms、バッファ切替は 4.44→3.09 ms でした。
