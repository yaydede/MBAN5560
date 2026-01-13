# Getting Started with Git and GitHub in RStudio

A step-by-step guide for beginners with zero prior experience.

---

## What is Git and GitHub?

Before we start, let's understand what these tools are:

- **Git** is a "version control system" - think of it as a "Track Changes" feature on steroids. It keeps a complete history of every change you make to your files, so you can always go back to previous versions.

- **GitHub** is a website that stores your Git repositories (project folders) in the cloud. It's like Google Drive or Dropbox, but specifically designed for code and projects that use Git.

**Why should you care?**
- 📁 **Backup**: Your work is safely stored in the cloud
- 🔄 **Version History**: You can undo mistakes and see what changed
- 👥 **Collaboration**: Work with classmates without emailing files back and forth
- 💼 **Professional Skill**: Used by every tech company and increasingly in data science

---

## Step 1: Create a GitHub Account

1. Open your web browser and go to **[github.com](https://github.com)**
2. Click the **"Sign up"** button in the top-right corner
3. Enter your email address and click **"Continue"**
4. Create a password and click **"Continue"**
5. Choose a username (pick something professional - future employers may see this!)
6. Complete the verification puzzle
7. Click **"Create account"**
8. GitHub will send a verification email - check your inbox and verify your email address

✅ **You now have a GitHub account!**

---

## Step 2: Install Git on Your Computer

Git is a separate program that must be installed on your computer. RStudio uses Git behind the scenes, but it's not included with RStudio.

### For Windows Users:

1. Go to **[git-scm.com/downloads](https://git-scm.com/downloads)**
2. Click **"Windows"** - the download should start automatically
3. Run the downloaded installer (it will be named something like `Git-2.x.x-64-bit.exe`)
4. **Click "Next" through all the screens** - the default options are fine for beginners
5. Click **"Install"**
6. When finished, click **"Finish"**

### For Mac Users:

1. Go to **[git-scm.com/downloads](https://git-scm.com/downloads)**
2. Click **"macOS"**
3. The easiest option is to install **Homebrew** first (if you don't have it):
   - Open **Terminal** (search for it in Spotlight with Cmd+Space)
   - Paste this command and press Enter:
     ```
     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
     ```
   - After Homebrew installs, type: `brew install git`
   
   **Alternative**: Download the installer from the website and follow the prompts.

### Verify Git is Installed:

1. Open **RStudio**
2. Go to the **Terminal** tab (next to the Console tab at the bottom)
3. Type this command and press Enter:
   ```
   git --version
   ```
4. If you see something like `git version 2.x.x`, Git is installed correctly! ✅

---

## Step 3: Tell Git Who You Are ⚠️ IMPORTANT

Git needs to know your name and email address to track who made each change. **This step is required** - without it, you'll get errors later!

### Configure Your Identity:

1. Open **RStudio**
2. Click on the **Terminal** tab (next to Console at the bottom of RStudio)
3. Type the following command (replace with YOUR name) and press Enter:
   ```bash
   git config --global user.name "Your Full Name"
   ```
   For example: `git config --global user.name "Jane Smith"`

4. Type the following command (replace with YOUR email) and press Enter:
   ```bash
   git config --global user.email "your.email@example.com"
   ```
   **Important:** Use the same email address you used to create your GitHub account!

### Verify Your Identity is Set:

Still in the Terminal, type:
```bash
git config --global user.name
git config --global user.email
```

You should see your name and email displayed back to you. ✅

---

## Step 4: Create a Personal Access Token (PAT)

A Personal Access Token is like a special password that allows RStudio to communicate with your GitHub account. GitHub no longer accepts regular passwords for this.

### Generate Your Token:

1. **Log in to GitHub** at [github.com](https://github.com)

2. **Click your profile picture** in the top-right corner

3. Click **"Settings"** from the dropdown menu

4. **Scroll down** on the left sidebar and click **"Developer settings"** (it's at the very bottom)

5. Click **"Personal access tokens"** in the left sidebar

6. Click **"Tokens (classic)"**

7. Click the **"Generate new token"** button, then **"Generate new token (classic)"**

8. You may need to enter your GitHub password again

9. **Fill in the token settings:**
   - **Note**: Give it a name like `RStudio-Access` or `My-Laptop-Git`
   - **Expiration**: Choose **90 days** (or "Custom" to match your course duration)
   - **Select scopes**: Check the boxes next to:
     - ✅ **`repo`** (this will auto-select all the sub-options)
     - ✅ **`user:email`** (scroll down to find this under "user")

10. Scroll down and click **"Generate token"**

### ⚠️ CRITICAL - Copy Your Token NOW!

GitHub will show you the token **ONLY ONCE**. It looks like a long string starting with `ghp_`.

1. **Click the copy button** (two overlapping squares) next to the token
2. **Paste it somewhere safe** immediately:
   - A password manager (best option)
   - A secure note on your phone
   - A text file that you'll delete later (not ideal, but okay temporarily)

**If you lose this token, you'll need to create a new one.** Don't panic - it's easy to generate another.

---

## Step 5: Configure RStudio for Git and GitHub

Now let's connect RStudio to Git and store your GitHub credentials.

### 5.1 Tell RStudio Where Git Is:

1. Open **RStudio**
2. Go to **Tools → Global Options** (on Mac: **RStudio → Preferences**)
3. Click **"Git/SVN"** in the left sidebar
4. Make sure **"Enable version control interface for RStudio projects"** is checked ✅
5. Check that the **"Git executable"** field shows a path to Git:
   - **Windows**: Usually `C:/Program Files/Git/bin/git.exe`
   - **Mac**: Usually `/usr/bin/git` or `/usr/local/bin/git`
   
   If it's empty, click **"Browse"** and find the git file on your computer.

6. Click **"OK"**

### 5.2 Store Your PAT (GitHub Credentials):

This stores your token securely so you don't have to enter it every time.

1. In the RStudio **Console** (bottom-left panel), install the required packages:
   ```r
   install.packages("usethis")
   install.packages("gitcreds")
   ```
   Press Enter and wait for them to install.

2. Now store your PAT by running:
   ```r
   gitcreds::gitcreds_set()
   ```

3. When prompted, **paste your Personal Access Token** (the one you copied in Step 4) and press Enter.

4. You should see a confirmation message that your credentials have been stored. ✅

### 5.3 Verify Everything Works:

Run this in the Console to check your setup:
```r
library(usethis)
usethis::git_sitrep()
```

This gives you a "situation report". Look for:
- ✅ **Name** and **Email** show your information (from Step 3)
- ✅ **GitHub user** shows your GitHub username
- ✅ **Personal access token** shows `<discovered>`

**Example of a successful setup:**
```
── Git global (user)
• Name: 'Jane Smith'
• Email: 'jane.smith@email.com'
── GitHub user
• GitHub user: 'janesmith'
• Personal access token for 'https://github.com': <discovered>
```

If you see errors, check the Troubleshooting section at the end.

---

## Step 6: Clone a Repository

"Cloning" means downloading a copy of a repository from GitHub to your computer. This is the most common task you'll do as a student.

### Find the Repository URL:

1. Go to the GitHub repository page (your instructor will give you the link)
2. Click the green **"Code"** button
3. Make sure **"HTTPS"** is selected (not SSH)
4. Click the **copy button** (📋) to copy the URL

   The URL looks like: `https://github.com/username/repository-name.git`

### Clone in RStudio:

1. In RStudio, go to **File → New Project**

2. Click **"Version Control"**

3. Click **"Git"**

4. Fill in the fields:
   - **Repository URL**: Paste the URL you copied from GitHub
   - **Project directory name**: This will auto-fill (you can change it if you want)
   - **Create project as subdirectory of**: Click **"Browse"** and choose where to save the project (e.g., your Documents folder)

5. Click **"Create Project"**

6. **RStudio will:**
   - Download all the files from GitHub
   - Create a new RStudio project
   - Open the project automatically

7. **Look for the "Git" tab** in the top-right panel of RStudio (next to Environment, History, etc.)
   - If you see it, you're connected to Git! ✅

---

## Step 7: The Daily Workflow

Once you have a repository cloned, here's how you work with it:

### The Basic Cycle: Pull → Edit → Stage → Commit → Push

Think of it like this:
1. **Pull** = Download the latest changes from GitHub (important if working with others)
2. **Edit** = Do your work (edit files, write code, etc.)
3. **Stage** = Select which changes you want to save
4. **Commit** = Save a snapshot of your changes with a description
5. **Push** = Upload your commits to GitHub

### How to Do Each Step in RStudio:

#### 1. PULL (Get Latest Changes)

- Click the **"Git" tab** in the top-right panel
- Click the **blue down arrow (↓)** labeled "Pull"
- This downloads any changes from GitHub that you don't have yet

**When to pull:** Always pull before you start working, especially if collaborating.

#### 2. EDIT (Do Your Work)

- Edit your R scripts, Quarto documents, etc. normally
- Save your files

#### 3. STAGE (Select Changes)

After editing and saving:
- Go to the **"Git" tab**
- You'll see your changed files listed
- **Check the box** next to each file you want to include in your commit
- A checkmark (✓) appears in the "Staged" column

**Tip:** The "Status" column shows:
- `M` = Modified (you changed an existing file)
- `A` = Added (a new file)
- `D` = Deleted (you removed a file)
- `?` = Untracked (Git doesn't know about this file yet)

#### 4. COMMIT (Save a Snapshot)

- Click the **"Commit"** button in the Git tab
- A new window opens showing your changes
- **Type a commit message** in the text box (e.g., "Completed Exercise 1" or "Fixed bug in data cleaning")
- Click **"Commit"**
- A message will confirm the commit was successful
- Close the commit window

**Good commit messages:**
- ✅ "Added analysis for Question 3"
- ✅ "Fixed typo in introduction"
- ❌ "stuff" (too vague)
- ❌ "asdfasdf" (meaningless)

#### 5. PUSH (Upload to GitHub)

- Back in the Git tab, click the **green up arrow (↑)** labeled "Push"
- Your commits are now uploaded to GitHub!
- Go to GitHub.com and refresh your repository page - you'll see your changes!

---

## Quick Reference Card

| Action | What It Does | How to Do It in RStudio |
|--------|--------------|-------------------------|
| **Clone** | Download a repo from GitHub | File → New Project → Version Control → Git |
| **Pull** | Get latest changes from GitHub | Git tab → Blue down arrow (↓) |
| **Stage** | Select files to include in commit | Git tab → Check the boxes |
| **Commit** | Save a snapshot with a message | Git tab → Commit button → Type message → Commit |
| **Push** | Upload commits to GitHub | Git tab → Green up arrow (↑) |

---

## Troubleshooting

### "Git executable not found"

**Solution:** Git may not be installed, or RStudio can't find it.
1. Reinstall Git from [git-scm.com](https://git-scm.com)
2. Restart RStudio
3. In RStudio: Tools → Global Options → Git/SVN → Browse to find git.exe (Windows) or git (Mac)

### "Authentication failed" or "Invalid credentials"

**Solution:** Your PAT may be missing, expired, or incorrect.
1. Generate a new PAT on GitHub (Step 4)
2. Run `gitcreds::gitcreds_set()` in the Console and paste the new token
3. Try your operation again

### "Repository not found" when cloning

**Solution:** 
- Check that the URL is correct (copy it again from GitHub)
- Make sure you have access to the repository (it might be private)
- Verify you're logged into the correct GitHub account

### "Updates were rejected because the remote contains work that you do not have locally"

**Solution:** Someone else pushed changes, or you made changes on another computer.
1. Click **Pull** first to get the latest changes
2. Then try **Push** again

### Can't see the Git tab in RStudio

**Solution:**
- Make sure you opened an RStudio **Project** (not just a file)
- The project must be linked to a Git repository
- Check: File → New Project → Version Control → Git (to clone a repo)

### git_sitrep() shows warnings about "Token lacks recommended scopes"

**Solution:** Your PAT is missing some scopes but will likely still work for basic operations. If you need full functionality:
1. Go to GitHub → Settings → Developer settings → Personal access tokens
2. Generate a new token with `repo` AND `user:email` scopes checked
3. Run `gitcreds::gitcreds_set()` and paste the new token

---

## Getting Help

- **GitHub Documentation**: [docs.github.com](https://docs.github.com)
- **Happy Git with R** (excellent resource): [happygitwithr.com](https://happygitwithr.com)
- **Ask your instructor or TA!**

---

*Last updated: January 2026*
