# ubuntu-linux-bootstrap

Script for getting a ubuntu box into dev mode from new install to useful in ~10 minutes...

> Do note that it is best-effort and by no means definitive, these things are hard to test! I just update things when I am doing a new build etc and some issues I spot fix, others are missed...

## Simple Bootstrap

A recent build of Ubuntu (at first 16, then 18, and now 20) gave rise to the need for a few tools etc.

By no means exhaustive, run as root, have a coffee:

    sudo ./bootstrap.sh

## Main Packages

* Chrome
* Docker, Docker Compose
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

If using VS Code (assuming you installed the suggested extensions such as `golang.go`) run the helper command "GO: Install/Update tools" to get the rest of the Golang goodies.
