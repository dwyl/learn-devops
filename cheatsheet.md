# Cheat Sheet

This [cheat sheet](https://en.wikipedia.org/wiki/Cheat_sheet)
helps us manage our `DevOps` _fast_.

## Update & Reboot Ubuntu Server

```sh
sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt clean -y && sudo apt autoclean -y && sudo reboot
```

The `alias` for this command on our servers is `upr` ("update and reboot").

> **Note**: We have most of these
> quick commands in a shared (`private`) **Google Doc**.
> If you would like to help extending this `public` file, please dive in!