<div align="center">

# asdf-hugo

[Hugo](https://gohugo.io/documentation/) plugin for the [asdf version manager](https://asdf-vm.com).

[![Build](https://github.com/Edditoria/asdf-hugo/actions/workflows/build.yml/badge.svg)](https://github.com/Edditoria/asdf-hugo/actions/workflows/build.yml) [![Lint](https://github.com/Edditoria/asdf-hugo/actions/workflows/lint.yml/badge.svg)](https://github.com/Edditoria/asdf-hugo/actions/workflows/lint.yml)

</div>

## Contents

- [Why](#why)
- [Install](#install)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)

## Why

I created this project for maintenance of some old Hugo sites. Sometimes I cannot change the development environment on behalf of other people/parties. Sometimes I want to quickly install the latest extended-Hugo that just works.

The project supports:

- Separated "normal" and **Sass/SCSS extended** versions for different projects/clients.
- Work from latest to legacy versions. It just works.
- Work with others. Install extended version without `extended-` in `.tool-versions` file.

## Install

Check availability of these generic POSIX utilities:

```shell
which bash curl tar asdf
```

Add plugin:

```shell
asdf plugin add hugo https://github.com/Edditoria/asdf-hugo.git
```

Install Hugo:

```shell
# Show all installable versions
asdf list-all hugo

# Install specific version
asdf install 104.0.1
# or specific extended version with Sass/SCSS
asdf install extended-104.0.1

# Install latest version
asdf install hugo latest
# or latest extended version with Sass/SCSS
asdf install hugo latest:extended

# Set a version globally (on your ~/.tool-versions file)
asdf global hugo latest
# or extended version with Sass/SCSS
asdf global hugo latest:extended

# Now hugo commands are available
hugo version
```

Uninstall:

```shell
# Change the version that you want to uninstall
asdf uninstall hugo 104.0.1
asdf uninstall hugo extended-104.0.1
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to install & manage versions.

## Configuration

Your teammates may use other asdf-hugo plugins that don't aware of `extended-*`. You can force to install extended version in your machine. Put this line in your shell config file, for example, `.bashrc`:

```shell
export ASDF_HUGO_INSTALL_EXTENDED=true
```

From now on, all new installations will support Sass/SCSS. Please be noted that _the path of the binaries will not contain "extended-"_.

## Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md). [Thanks goes to these contributors](https://github.com/Edditoria/asdf-hugo/graphs/contributors)!

The CSV file (hugo_release.csv), that is used to resolve the URL of release file in Hugo repository, is created in another repo "[Edditoria/hugo-release-watcher](https://github.com/Edditoria/hugo-release-watcher)". You may want to take a look when you want to develop or fix a bug.

## Copyright and License

Copyright (c) Edditoria. All rights reserved. Code released under the [MIT License](LICENSE). Docs released under [Creative Commons](https://creativecommons.org/licenses/by/4.0/).

You can use it, share it, modify the code and distribute your work for private and commercial uses. If you like, please share your work with me. :pizza:
