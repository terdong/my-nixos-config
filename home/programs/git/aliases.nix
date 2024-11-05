{ ... }:
{
  programs.git.aliases = {
    # Status and information
    st = "status -sb"; # Shorter status with branch info
    br = "branch"; # List branches
    bra = "branch -a"; # List all branches (including remote)
    last = "log -1 HEAD"; # Show last commit
    lg = "log --graph --oneline"; # Pretty log with graph
    hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"; # Detailed pretty log

    # Common actions
    co = "checkout"; # Checkout
    cob = "checkout -b"; # Checkout new branch
    cm = "commit -m"; # Commit with message
    cam = "commit -am"; # Add all and commit with message
    aa = "add -A"; # Add all files
    unstage = "reset HEAD --"; # Remove files from index
    undo = "reset --soft HEAD^"; # Undo last commit but keep changes

    # Stash operations
    sl = "stash list"; # List stashes
    sp = "stash pop"; # Pop latest stash
    ss = "stash save"; # Save stash with message
    sshow = "stash show -p"; # Show stash changes

    # Remote operations
    pl = "pull"; # Pull
    ps = "push"; # Push
    pf = "push --force-with-lease"; # Force push safely
    ra = "remote add"; # Add remote
    rv = "remote -v"; # List remotes

    # Branch management
    bd = "branch -d"; # Delete branch
    bdd = "branch -D"; # Force delete branch
    merged = "branch --merged"; # List merged branches
    unmerged = "branch --no-merged"; # List unmerged branches

    # Diff operations
    df = "diff"; # Show changes
    dfc = "diff --cached"; # Show staged changes
    dfl = "diff HEAD^"; # Show changes from last commit

    # Clean up operations
    cleanup = "!git branch --merged | grep -v \"\\*\" | xargs -n 1 git branch -d"; # Remove merged branches
    prune = "fetch --prune"; # Remove deleted remote branches

    # Advanced aliases
    alias = "!git config --list | grep 'alias\\.' | sed 's/alias\\.\\([^=]*\\)=\\(.*\\)/\\1\\\t => \\2/' | sort"; # List all aliases
    amend = "commit --amend"; # Amend last commit
    contributors = "shortlog -sn"; # List contributors
    tags = "tag -l"; # List all tags
    whoami = "config user.email"; # Show configured user

    # Search commits
    find = "!git log --pretty=\"format:%Cgreen%H %Cblue%s\" --name-status --grep"; # Search commit messages
    search = "!git rev-list --all | xargs git grep -F"; # Search all commits for a string

    # File operations
    untrack = "rm --cached"; # Untrack files
    ignored = "!git ls-files -v | grep \"^[[:lower:]]\""; # List ignored files
  };
}
