{ config, lib, pkgs, ... }:

let
  pluginOverlay = import ./tmux-plugins;
  pkgsWithPlugins = pkgs.extend pluginOverlay;

in {
  programs.tmux = {
    enable = true;

    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";
    mouse = true;
    prefix = "C-Space";
    sensibleOnTop = false; # disable sensible plugin - outdated and not updated for 3+ years, have extracted the little I need
    terminal = "tmux-256color";

    # Plugin configuration
    plugins = with pkgsWithPlugins.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          # Configure Catppuccin
          set -g @catppuccin_flavor "macchiato"
          set -g @catppuccin_status_background "none"
          set -g @catppuccin_window_status_style "none"
          set -g @catppuccin_pane_status_enabled "off"
          set -g @catppuccin_pane_border_status "off"

          # Configure Online
          set -g @online_icon "ok"
          set -g @offline_icon "nok"

          # status left look and feel
          set -g status-left-length 100
          set -g status-left ""
          set -ga status-left "#{?client_prefix,#{#[bg=#{@thm_red},fg=#{@thm_bg},bold]  #S },#{#[bg=#{@thm_bg},fg=#{@thm_green}]  #S }}"
          set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]│"
          set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_maroon}]  #{pane_current_command} "
          set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]│"
          set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_blue}]  #{=/-32/...:#{s|$USER|~|:#{b:pane_current_path}}} "
          set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]#{?window_zoomed_flag,│,}"
          set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_yellow}]#{?window_zoomed_flag,  zoom ,}"

          # status right look and feel
          set -g status-right-length 100
          set -g status-right ""
          set -ga status-right "#{?#{e|>=:10,#{battery_percentage}},#{#[bg=#{@thm_red},fg=#{@thm_bg}]},#{#[bg=#{@thm_bg},fg=#{@thm_pink}]}} #{battery_icon} #{battery_percentage} "
          set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}, none]│"
          set -ga status-right "#[bg=#{@thm_bg}]#{?#{==:#{online_status},ok},#[fg=#{@thm_mauve}] 󰖩 on ,#[fg=#{@thm_red},bold]#[reverse] 󰖪 off }"
          set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}, none]│"
          set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_blue}] 󰭦 %Y-%m-%d 󰅐 %H:%M "
        '';
      }
      {
        plugin = online-status;
        extraConfig = ''
          set -g @online_icon "ok"
          set -g @offline_icon "nok"
        '';
      }
      battery
      prefix-highlight
      resurrect
      yank
      {
        plugin = vim-tmux-navigator;
        extraConfig = ''
          set -g @vim_navigator_mapping_left "C-h"
          set -g @vim_navigator_mapping_right "C-l"
          set -g @vim_navigator_mapping_up "C-k"
          set -g @vim_navigator_mapping_down "C-j"
          set -g @vim_navigator_mapping_prev ""
          set -g @vim_navigator_prefix_mapping_clear_screen ""
        '';
      }
      fzf-tmux-url
      # joshmedeski/tmux-nerd-font-window-name
      {
        plugin = tmux-thumbs;
        extraConfig = ''
          set -g @thumbs-key F
        '';
      }
    ];

    extraConfig = ''
      # Key bindings
      bind Space send-prefix
      bind-key Space copy-mode
      bind-key C-Space last-window

      # SSH agent fix
      # TODO: see https://stackoverflow.com/a/23187030
      setenv -g SSH_AUTH_SOCK $HOME/.ssh/ssh_auth_sock

      # Split windows
      bind C-j split-window -v -c "#{pane_current_path}"
      bind C-l split-window -h -c "#{pane_current_path}"

      # Don't use default 'copy-pipe-and-cancel'
      set -g @yank_action 'copy-pipe'
      set -g @shell_mode 'vi'

      # Terminal settings
      set -sa terminal-features ",*-256color:RGB"
      set -as terminal-overrides ",*:U8=0"

      ##### extracted from tmux-sensible #####
      # Focus and activity settings
      set -g focus-events on

      # Key bindings
      bind-key C-p previous-window
      bind-key C-n next-window
      # reload tmux config
      bind-key R run-shell 'tmux source-file ~/.config/tmux/tmux.conf > /dev/null; tmux display-message "Sourced .tmux.conf!"'
      ##### end extracted from tmux-sensible #####

      # Allow color passthrough
      set -g allow-passthrough on

      ##### catppuccin theme post plugin config ######
      set -g status-position top
      set -g status-style "bg=#{@thm_bg}"
      set -g status-justify "absolute-centre"

      # pane border look and feel
      setw -g pane-border-status top
      setw -g pane-border-format ""
      setw -g pane-active-border-style "bg=#{@thm_bg},fg=#{@thm_overlay_0}"
      setw -g pane-border-style "bg=#{@thm_bg},fg=#{@thm_surface_0}"
      setw -g pane-border-lines single

      # window look and feel
      set -wg automatic-rename on
      set -g automatic-rename-format "Window"

      set -g window-status-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-style "bg=#{@thm_bg},fg=#{@thm_rosewater}"
      set -g window-status-last-style "bg=#{@thm_bg},fg=#{@thm_peach}"
      set -g window-status-activity-style "bg=#{@thm_red},fg=#{@thm_bg}"
      set -g window-status-bell-style "bg=#{@thm_red},fg=#{@thm_bg},bold"
      set -gF window-status-separator "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}]│"

      set -g window-status-current-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-current-style "bg=#{@thm_peach},fg=#{@thm_bg},bold"
      ##### end catppuccin theme post plugin config ######
    '';
  };
}
