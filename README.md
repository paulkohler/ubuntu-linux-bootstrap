# ubuntu-linux-bootstrap

Script for getting a ubuntu box into dev mode from new install to useful in ~10 minutes...

## Simple Bootstrap

A recent build of Ubuntu 16.04.3 LTS (now 18) gave rise to the need for a few tools etc.

By no means exhastive and has a .NET flavour to it, run as root, have a coffee:

    sudo ./bootstrap.sh

## Main Packages

* Chrome
* Docker
* .NET Core
* Visual Studio Code
* Node/npm/yarn

Reminders about git setup etc

---

## Notes

For docker, you will most likely need to log out. Sometimes I have had the "new terminal" be sufficient but typically it is easiest to log out and back in.

If you are running this in a VM of sorts you may need to disable the GPU when running VS Code for it to work happily:

    code --disable-gpu

> https://code.visualstudio.com/docs/supporting/FAQ#_vs-code-is-blank
