# ubuntu-linux-bootstrap

Script for getting a ubuntu box into dev mode from new install to useful in ~10 minutes...

## Simple Bootstrap

A recent build of Ubuntu 16.04.3 LTS (now 18) gave rise to the need for a few tools etc.

By no means exhastive and has a .NET flavour to it, run as root, have a coffee:

    sudo ./bootstrap.sh

## Main Packages

* Chrome
* Docker
* Visual Studio Code
* .NET Core
* Go
* Node/npm/yarn

Reminders about git setup etc

---

## Notes

### Docker

For docker, you will most likely need to log out. Sometimes I have had the "new terminal" be sufficient but typically it is easiest to log out and back in.

### VS Code

If you are running this in a VM of sorts you may need to disable the GPU when running VS Code for it to work happily:

    code --disable-gpu

> https://code.visualstudio.com/docs/supporting/FAQ#_vs-code-is-blank

### Go

If using VS Code (assuming you installed the suggested extensions such as `ms-vscode.go`) run the helper command "install all tools" to get the rest of the Golang goodies.
