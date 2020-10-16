# eiflibinstaller
Eiffel C Binding Library Installer

## Prerequisites
The installer allows you to reach out and download Git.exe, if you do not already have it.

The installer will also allow you to clone into MS vcpkg and bootstrap-vcpkg update it if needed (you will need to on first clone).

## Running the Installer
Running the installer is as simple as double-clicking on the eiflibinstaller.exe file to open it.

### Pre-seeded Values
Some values in the installer.conf file will be pre-seeded for you. You will be able to change these either directly in the interface or in the File->Preferences window.

Nevertheless, there are things the installer cannot know. That is what the next section is for.

### Info You Provide

You will need to know the following:

- Where your WrapC cloned directory is located.
- Where your vcpkg cloned directory is located.

The installer will attempt to figure out where your git.exe is located (and ensures it is installed, otherwise click the Download button and install it).

The installer will also presume you are using the latest version of EiffelStudio.

NOTE: In a future version (if needed), we may allow you to select which version of EiffelStudio you want to use. For now, the latest version is located and selected for you.

