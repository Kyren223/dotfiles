
## Installation

To install GNU Stow, use your preferred package manager

### OpenSUSE Tumbleweed

```zsh
$ sudo zypper up
$ sudo zypper in stow
```

### Load (symlink) dotfiles

- <dotfiles> - refers to the name of the directory where the dotfiles git repo lives
Make sure that <dotfiles> is a subdirectory of `$HOME`

```zsh
$ cd ~/<dotfiles> && stow .
```

You may need to add the `--adopt` flag to stow to override existing configurations in `$HOME`
```zsh
$ cd ~/<dotfiles> && stow --adopt .
```

## Usage

- <dotfiles> - refers to the name of the directory where the dotfiles git repo lives
- <path> - The directory path where the file/s live
- <file> - The file's name, this is the file you want to add/update/delete

### Add

Add a new file to the dotfiles repo

```zsh
$ mv ~/<path>/<file> ~/<dotfiles>/<path>/<file>
$ cd ~/<dotfiles> && stow .
```

### Update

As GNU Stow uses symlinks, you can simply edit it (in either ~/<path>/<file> or ~/<dotfiles>/<path>/<file>) and the changes will be present in both locations

### Delete

Remove a file from GNU Stow and the filesystem

```zsh
$ rm ~/<dotfiles>/<path>/<file>
$ rm ~/<path>/<file>
```

Remove a file only from GNU Stow, but keep it in the filesystem

```zsh
$ rm ~/<path>/<file>
$ mv ~/<dotfiles>/<path>/<file> ~/<path>/<file>
$ cd ~/<dotfiles> && stow .
```

### Commit changes to the GitHub repository (optional)

```zsh
$ cd ~/<dotfiles>
$ git add .
$ git commit -m "Your message here"
$ git push origin master
```

### Pull Changes from the GitHub repository

```zsh
$ cd ~/<dotfiles>
$ git pull origin master
$ stow -- adopt .
```




