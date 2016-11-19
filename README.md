# Nee-co Cuenta
### 共有事項
|         概要        |    ユーザ管理APIサーバー  |
|:-------------------:|:-------------------------:|
|          OS         |         CentOS (7.2)      |
|       使用言語      |         Elixir (1.3)      |
|  使用フレームワーク |       Phoenix (1.2.0)     |
|    バージョン管理   |             Git           |
|    Gitホスティング  |          Bitbucket        |

---

### 必要知識/キーワード
- Git
- Vagrant
- Docker
- MVC
- Elixir
- Phoenix
- REST
- JSON
- MariaDB(MySQL)

---

### 事前準備
- 以下をインストール(基本的に最新versionで問題ないが、心配なら他の開発者に相談すること)
    * [Git](http://git-scm.com/)
    * [Vagrant](https://www.vagrantup.com/downloads.html) >= 1.8.4
    * [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

- Bitbucket/SSHキーの設定
    * やらなくても良いが, やったほうが楽(わからなかったら相談すること)

- Gitの設定

```
$ git config --global user.name "自分の名前"
$ git config --global user.email "Bitbucketに設定したメールアドレス"
```
---

### 開発構築手順
- 共有リポジトリから自分のリポジトリを[Fork](https://bitbucket.org/nhac/cuenta/fork)する
- クローンしたリポジトリのアクセス権に `nee-co (nhac:nee-co)` グループをReadで追加する(レビューしやすくするため)

```
$ git clone git@bitbucket.org:<ユーザ名>/cuenta.git
$ cd cuenta
$ git remote add upstream git@bitbucket.org:nhac/cuenta.git
$ git remote update
$ vagrant up
$ vagrant ssh
```
```
vagrant> cd /vagrant
vagrant> mix deps.get
vagrant> mix deps.compile
vagrant> mix ecto.setup
vagrant> mix phoenix.server
```

### ブランチ管理
- `master` : 安定状態を維持する。直接コミットはしない。
- `develop` : 開発中。リリースのタイミングでmasterに反映する。直接コミットはしない。
- `feature` : 実際にコミットをし、developに反映する。ブランチ名は基本的に `NEECO-チケット番号`
- `hotfix` : masterで急遽編集が必要な時にコミットする。masterとdevelopに反映する。

### 開発フロー

- チケット作成/担当を自分に振る(振られる)

- ブランチを切る
    * Bitbucket上, ローカル どちらで切っても良い
    * `NEECO-<チケット番号>`

- コミット
    * コミットの粒度に気をつける(コミットメッセージが上手く書けない時はコミット粒度が悪い)
    * Revertした時に違和感がない粒度にすること
    * 基本的に日本語で記述する( `fix typo` とかはOK)
    * 後で履歴を検索しやすいコミットメッセージにすること

```
1行目 : コミットでの変更内容の要約
2行目 : 空行
3行目以降 : 変更した理由
```

- プッシュ
    * origin(フォークした自分のリポジトリ)にpushする

- プルリクエスト
    * Bitbucket上でupstreamリポジトリにPR(プルリクエスト)を出す
    * PRを出す前に最新のdevelopからをrebaseしておくとコンフリクトに対応しやすい
    * PRを出すまではrebaseやammendはやっても良いが、PR後は避けるべき
    * 宛先branchはdevelopにする
    * `Title` `説明`はわかりやすくする(チケット番号をつけるとチケットを追いやすいためGood)
    * レビューアがマージする(プルリクエストを出した本人は基本的にマージしない)
    * 作業途中のPRはPRタイトルに `[WIP]` をつける

### Docker Task

* イメージ作成
    + `make image`

* ネットワーク作成
    + `make networks`

* ボリューム作成
    + `make volumes`
