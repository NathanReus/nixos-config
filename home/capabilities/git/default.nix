{ pkgs, ... }:

{
  programs = {
    # Github CLI Tool
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        editor = "hx";
      };
      extensions = with pkgs; [
        #gh-dash # Displays a dashboard of pull requests and issues
      ];
    };

    # Git
    git = {
      enable = true;
      userName = "Nathan Reus";
      userEmail = "nathan.reus@gmail.com";

      # GPG signing of commits #TODO
      #signing = {
        #key = "";
        #signByDefault = true;
      #};
      
      extraConfig = {
        init.defaultBranch = "main";
      };
      
    };
  };
}
