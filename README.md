<div align="center">

# asdf-hugo [![Build](https://github.com/Edditoria/asdf-hugo/actions/workflows/build.yml/badge.svg)](https://github.com/Edditoria/asdf-hugo/actions/workflows/build.yml) [![Lint](https://github.com/Edditoria/asdf-hugo/actions/workflows/lint.yml/badge.svg)](https://github.com/Edditoria/asdf-hugo/actions/workflows/lint.yml)


[hugo](https://gohugo.io/documentation/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add hugo
# or
asdf plugin add hugo https://github.com/Edditoria/asdf-hugo.git
```

hugo:

```shell
# Show all installable versions
asdf list-all hugo

# Install specific version
asdf install hugo latest

# Set a version globally (on your ~/.tool-versions file)
asdf global hugo latest

# Now hugo commands are available
hugo version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/Edditoria/asdf-hugo/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Edditoria](https://github.com/Edditoria/)
