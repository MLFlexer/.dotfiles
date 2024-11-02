{ pkgs, ... }: {
  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        devices = [
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
        ];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
           caps
          )
          (defvar
           tap-time 150
           hold-time 200
          )
          (defalias
           caps (tap-hold 100 50 esc lctl)
          )

          (deflayer base
           @caps
          )
        '';
      };
    };
  };
}
