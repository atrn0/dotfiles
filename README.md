# dotfiles

```sh
ls -a | grep .gitconfig |less | xargs -I {} ln -sf $PWD/{} ~/
```