
# deb-ohmyzsh (deb-ohmyzsh)

Installs ohmyzsh on systems that use apt as package manager

## Example Usage

```json
"features": {
    "ghcr.io/Xm798/devcontainers-features/deb-ohmyzsh:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| plugins | OhMyZsh plugins to enable | string | git alias-tips autoupdate zsh-autosuggestions zsh-syntax-highlighting |
| theme | The theme to be activated | string | robbyrussell |
| setLocale | Install required locales package and set locale | boolean | true |
| desiredLocale | The locale that should be set when 'setLocale' is true | string | en_US.UTF-8 UTF-8 |

## Acknowledgments

- [nils-geistmann/devcontainers-features](https://github.com/nils-geistmann/devcontainers-features/tree/main)
- [cirolosapio/devcontainers-features](https://github.com/cirolosapio/devcontainers-features)


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/Xm798/devcontainers-features/blob/main/src/deb-ohmyzsh/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
