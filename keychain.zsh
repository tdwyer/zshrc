GPG_TTY=$(tty)
export GPG_TTY
eval `keychain --eval --quiet --timeout 1440 --agents ssh,gpg id_rsa C18D3651`

