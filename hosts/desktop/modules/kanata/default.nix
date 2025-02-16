{ pkgs, ... }: {
  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        devices = [
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
        ];
        extraDefCfg = "process-unmapped-keys yes";
        configFile = ./kanata.kbd;
        # config = ''
        #   (defsrc
        #    caps
        #    lctl lmeta lalt
        #   )
        #   (defvar
        #    tap-time 150
        #    hold-time 200
        #   )
        # 
        #   (defalias
        #    caps (tap-hold 100 50 esc lctl)
        #   )
        # 
        #   (deflayer base
        #    @caps
        #    lctl lmeta lalt space
        #   )
        #   (defsrc ;; Swedish ISO105
        #     §    1    2    3    4    5    6    7    8    9    0    +    ´    bspc
        #     tab  q    w    e    r    t    y    u    i    o    p    å    ¨
        #     caps a    s    d    f    g    h    j    k    l    ö    ä    '    ret
        #     lsft <    z    x    c    v    b    n    m    ,    .    -         rsft
        #     lctl lmet lalt                spc                 ralt rmet menu rctl
        #   )
        # '';
      };
    };
  };
}
