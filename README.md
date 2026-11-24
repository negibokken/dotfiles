# README

Execute below command to install files.

```sh
./install.sh
```

## 個人リポジトリの管理

`gh-personal` は、macOS Keychain に保存した Fine-grained personal access token で `github.com/negibokken` 配下のリポジトリを操作します。書き込みには同じトークンを使う `gh-personal-write` も利用できます。

```sh
gh-personal --auth-status
gh-personal repo list --no-archived
gh-personal repo view negibokken/dotfiles
gh-personal api repos/negibokken/dotfiles --jq .full_name
```

リポジトリ名を省略すると、カレントディレクトリの Git リポジトリの `origin` を使います。PR の操作とリポジトリ名の変更では、`-R negibokken/<repo>` をサブコマンドの前に指定できます。対応する操作は `gh-personal --help` で確認できます。

`api` は対象リポジトリの REST API の GET に対応します。バッチ処理では、対象ごとに `gh-personal api` を呼び出します。

初回登録や PAT の更新時は、GitHub で Resource owner が `negibokken` の [Fine-grained PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token) を用意し、対象リポジトリと必要な権限を選びます。PAT を個人用の 1Password アカウントに保存し、Secret Reference を `~/.config/gh-personal/token-ref` に記載して、`gh-personal --refresh-keychain` を実行してください。登録時は GitHub のログイン名を確認します。普段の操作では Keychain から PAT を読み込みます。

Neovim の構成・キー設定・検証方法は [nvim/README.md](nvim/README.md) を参照してください。
