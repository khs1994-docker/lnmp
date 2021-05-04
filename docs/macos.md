# macOS

## brew

```bash
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

$ cd "$(brew --repo)"
$ git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
# https://github.com/Homebrew/brew
# https://mirrors.ustc.edu.cn/brew.git

$ cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
$ git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
# https://github.com/Homebrew/homebrew-core
# https://mirrors.ustc.edu.cn/homebrew-core.git

for item in ".bash_profile .zshrc"
do
    echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles' >> ~/$item
    # https://mirrors.ustc.edu.cn/homebrew-bottles
    source ~/.bash_profile
done

if [ -f ~/.config/fish/config.fish ];then
    echo "set -gx HOMEBREW_BOTTLE_DOMAIN https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles" >> ~/.config/fish/config.fish
fi

$ brew update
```

## fish

```bash
$ git clone --depth=1 https://github.com/oh-my-fish/oh-my-fish.git ~/git/oh-my-fish
```

## ruby
```bash
$ gem sources -l | grep https://gems.ruby-china.com || gem sources -a https://gems.ruby-china.com ; gem sources -l
```

## composer
```bash
$ composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
```

## npm

```bash
# ~/.npmrc

registry=https://registry.npm.taobao.org
```

## pip

```bash
# ~/.pip/pip.conf
[global]
index-url = https://pypi.doubanio.com/simple
[list]
format=columns
```
