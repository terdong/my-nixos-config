{ pkgs-unstable, ... }:

{
  programs.tmux = {
    enable = true;

    # Set zsh as the default shell in tmux
    extraConfig = ''
      set-option -g default-shell ${pkgs-unstable.zsh}/bin/zsh
      set-option -g default-command ${pkgs-unstable.zsh}/bin/zsh

      set -g terminal-overrides 'xterm*:smcup@:rmcup@'
      set -g mouse on

      setw -g mode-keys vi

      set -g default-terminal xterm-256color

      # Use Alt-arrow keys without prefix key to switch panes
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Shift arrow to switch windows
      bind -n S-Left  previous-window
      bind -n S-Right next-window

      # change window order
      bind-key -n C-S-Left swap-window -t -1
      bind-key -n C-S-Right swap-window -t +1

      # disable window name auto change
      set-option -g allow-rename off

      # bar color
      set -g status-bg black
      set -g status-fg white

      #toggle pane title visibility
      bind T run 'zsh -c "arr=( off top ) && tmux setw pane-border-status ''${arr[''$(( ''${arr[(I)#{pane-border-status}]} % 2 + 1 ))]}"'
      # rename pane
      bind t command-prompt -p "(rename-pane)" -I "#T" "select-pane -T '%%'"
    '';

    # Additional tmux configuration options
    keyMode = "vi"; # Optional: enable vi mode for tmux key bindings
    historyLimit = 5000; # Optional: increase the scrollback history

    package = pkgs-unstable.tmux;
  };
}
