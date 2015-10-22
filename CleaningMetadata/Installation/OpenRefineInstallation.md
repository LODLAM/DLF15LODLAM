# LODLAM Workshop: Metadata Cleaning Portion Installation Instructions
## Installing OpenRefine or LODRefine
Don't have OpenRefine or LODRefine installed? No worries! We'll get you set up. 

### Java Requirements
OpenRefine is built in Java. You will need Java JRE. Mac and Linux machines will need to have Java 6 or 7 installed (if you have Java 8, and don't want to mess with Java 6 or 7, try grabbing LODRefine from GitHub and running via the Command Line Interface/client of your choice first, this sometimes is a work-around).

**Java JRE isn't hard to install, but takes forever to download, especially on conference wifi. You are forewarned.**

### Pick Your OpenRefine, LODRefine or RefinePro Poison
There are 3 options for getting what you need onto your computer. Just choose 1. All methods get you an installation of OpenRefine or LODRefine ready for the workshop.

If you prefer to keep the installation and start-up as simple as possible, use one of the OpenRefine installers detailed in Option 1, below. 

If you're prefer to work with a version of LODRefine that runs via command line interface and feel comfortable with Git and handling installation of dependencies, clone a LODRefine repository as detailed in Option 2, below.

If you don't want to install anything right now and are willing to take your chances with a cloud-hosted version, set up RefinePro as detailed in Option 3, below.

#### Option 1: Install OpenRefine via Installer + Add DERI RDF Extension Manually
This versions works more slowly, but comes with a packaged installer/icon.

1. Go to the [OpenRefine 2.6 beta Download Page](https://github.com/OpenRefine/OpenRefine/releases/tag/2.6-beta.1). Scroll down to the bottom of the page.
2. Download the OpenRefine file for your operating system and follow the instructions:
    2. For Windows: Download, unzip, and double-click on openrefine.exe. If you’re having issues, try double-clicking on refine.bat instead.
    3. For Mac: Download, open, drag icon into the Applications folder and double click on it. If you get the error: 'this file is damaged should be moved to trash' (or something similar), do the following:
        4. Open System Preferences
        5. Open Security & Privacy
        6. Go to the General Tab
        7. Change the "Allow applications downloaded from:" setting to "Anywhere" 
        8. You should be able to able to open OpenRefine now.
    3. For Linux: Download, extract, then type ./refine to start. 
4. Once you've got OpenRefine installed and running on your machine, you need to now install the DERI RDF Extension. 
5. Next step: [Install the DERI RDF Extension](AddDERIExtension.md)

#### Option 2: Install LODRefine from GitHub/Source
Alternatively, you can install LODRefine (a version of OpenRefine 2.5 with the DERI RDF extension among others already installed) by downloading or git cloning LODRefine locally. 

1. Clone or download LODRefine:
    2. From GitHub, clone the master branch of this repository: https://github.com/sparkica/LODRefine
    3. From Sourceforge, download the most recent version of LODRefine: http://sourceforge.net/projects/lodrefine/postdownload?source=dlp
3. Move LODRefine to wherever on your computer you'd like to run it from. I usually keep these sorts of applications in a directory call 'Tools'.
4. Change into that LODRefine directory in some kind of command line interface or client (e.g. Terminal on Mac, Command Prompt in Windows,...), and start LODRefine by typing:
    6. On Mac/Linux:
    ```
    $ ./refine
    ```
    7. On Windows:
    ```
    refine
    ```
6. Leave the Command Line Interface running while working with LODRefine. Go to your preferred web browser (**not Internet Explorer**), and navigate to http://127.0.0.1:3333/. 
7. When you're done, go back to the Command Line Interface client where LODRefine is running, and type 'cntl+C'. This will stop LODRefine. 
8. You're done (DERI RDF Extension is already present in LODRefine). 
9. Next step: Go to the ['Test your install section'](OpenRefineInstallationTest.md) and make sure you're ready for the workshop.

### Option 3: Don't Want to Install OpenRefine/LODRefine right now?
I'm working with RefinePro, a company that runs cloud-hosted instances of OpenRefine, to get OpenRefine with the DERI RDF extensions working for a back up possibility.

At present, RefinePro does have instances of OpenRefine with the DERI RDF extensions installed, but the RDF reconciliation services sometimes don't work.

If you want to try a cloud-based version and see if it works for you instead of going through installation instructions above, you can get a free month trial to RefinePro. Follow these steps then make sure it works before calling it quits:

**Note, I'm working very closely with the RefinePro developer to get this option working for the workshop, but it is still a bit buggy as of 10/21. If you register and run into errors, get in touch with [me](mailto:cmharlow@gmail.com).**

1. Go to [the RefinePro site](https://app.refinepro.com/register/) and register. 
2. On that registration page, for the 'Community' portion, choose 'LODLAM'. This will get you an instance of OpenRefine with the DERI RDF Extension installed.
3. When done, enter. You'll get a free month trial.
3. Respond to the email confirmation. This should take you back to the RefinePro login. 
4. Logging in takes you to your dashboard. Choose to start an instance - this will create an OpenRefine instance. 
5. Once an instance available on your dashboard, click on 'Start'. Once it is starting, click on 'Access this RefinePro instance', a link that appears once your OpenRefine instance is running.
6. This should take you to OpenRefine.
7. You're done (DERI RDF Extension is already present in the DST4L-EU instances). 
8. Next step: Go to the ['Test your install section'](OpenRefineInstallationTest.md) and make sure you're ready for the workshop.

---

Questions? Get in touch with [Christina](mailto:cmharlow@gmail.com).

[Back to the Metadata Cleaning Agenda](../)

[Back to the LODLAM Workshop Agenda](https://github.com/cmh2166/DLF15LODLAM/)
