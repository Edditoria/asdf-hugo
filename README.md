<div align="center">

# asdf-hugo

[Hugo](https://gohugo.io/documentation/) plugin for the [asdf version manager](https://asdf-vm.com).

[![Build](https://github.com/Edditoria/asdf-hugo/actions/workflows/build.yml/badge.svg)](https://github.com/Edditoria/asdf-hugo/actions/workflows/build.yml) [![Lint](https://github.com/Edditoria/asdf-hugo/actions/workflows/lint.yml/badge.svg)](https://github.com/Edditoria/asdf-hugo/actions/workflows/lint.yml)

</div>

## Contents

- [Why](#why)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

## Why

I created this project to help maintaining some super-old Hugo sites. Sometimes I cannot change the development environment on behalf of other people/parties. Sometimes I want to quickly install the latest extended-Hugo that just works.

The project supports:

- Separated "normal" and **Sass/SCSS extended** versions for your projects/clients.
- Work from latest to legacy versions.

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

## Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/Edditoria/asdf-hugo/graphs/contributors)!

## License

See [LICENSE](LICENSE) © [Edditoria](https://github.com/Edditoria/)
