GPG_TTY=$(tty)
export GPG_TTY
# timeout in minutes. Funtoo's keychain http://www.funtoo.org/Keychain
eval `keychain --eval --quiet --timeout 20 --agents ssh,gpg id_rsa C18D3651`

