{ pkgs, config, ... }: {
  xdg.configFile."task/dark".source =
    config.lib.file.mkOutOfStoreSymlink "${pkgs.taskwarrior}/share/doc/task/rc/dark-16.theme";

  xdg.configFile."task/light".source =
    config.lib.file.mkOutOfStoreSymlink "${pkgs.taskwarrior}/share/doc/task/rc/light-16.theme";

  xdg.configFile."task/taskrc".text = ''
    data.location=~/.local/share/task
    hooks.location=~/.config/task/hooks

    include ${pkgs.taskwarrior}/share/doc/task/rc/no-color.theme
    include ~/.config/task/$__sys_theme

    journal.time=on

    # Shortcuts
    alias.dailystatus=status:completed end.after:today all
    alias.punt=modify wait:1d
    alias.meh=modify due:tomorrow
    alias.someday=mod +someday wait:someday

    search.case.sensitive=no
    alias.burndown=burndown.daily

    # task ready report default with custom columns
    default.command=ready
    report.ready.columns=id,start.active,depends.indicator,project,due.relative,description.desc
    report.ready.labels=,,,Project,Due,Description
    uda.reviewed.type=date
    uda.reviewed.label=Reviewed
    report._reviewed.description=Tasksh review report.  Adjust the filter to your needs.
    report._reviewed.columns=uuid
    report._reviewed.sort=reviewed+,modified+
    report._reviewed.filter=( reviewed.none: or reviewed.before:now-6days ) and ( +PENDING or +WAITING )
  '';
}
