function __fish_eza_install --on-event fish-eza_install
    function _set
        if not set --query --universal --export $argv[1]
            set --universal --export $argv[1] $argv[2..-1]
        end
    end

    # Prefer eza as exa is unmaintained
    set -Ux __FISH_EZA_BINARY eza

    set -Ux __FISH_EZA_BASE_ALIASES l ll lg le lt lc lo
    set -Ux __FISH_EZA_EXPANDED a d i id aa ad ai aid aad aai aaid
    set -Ux __FISH_EZA_EXPANDED_OPT_NAME LA LD LAA LAD LAAD
    set -Ux __FISH_EZA_OPT_NAMES
    set -Ux __FISH_EZA_ALIASES
    set -Ux __FISH_EZA_SORT_OPTIONS name .name size ext mod old acc cr inode

    _set EZA_STANDARD_OPTIONS --group --header --group-directories-first "--color=always" "--icons=always"

    # Base aliases
    _set EZA_L_OPTIONS
    _set EZA_LL_OPTIONS --long
    _set EZA_LG_OPTIONS --git --git-ignore --long
    _set EZA_LE_OPTIONS --extended --long
    _set EZA_LT_OPTIONS --tree --level
    _set EZA_LC_OPTIONS --across
    _set EZA_LO_OPTIONS --oneline

    # Extended aliases
    _set EZA_LD_OPTIONS --only-dirs
    _set EZA_LA_OPTIONS --all --binary
    _set EZA_LAD_OPTIONS --all --binary --only-dirs
    _set EZA_LAA_OPTIONS --all --all --binary
    _set EZA_LAAD_OPTIONS --all --all --binary --only-dirs

    for a in $__FISH_EZA_BASE_ALIASES
        set -l opt_name (string join '_' "EZA" (string upper $a) "OPTIONS")
        if test $a = ll
            alias --save "$a" eza_git
        else
            alias --save "$a" "$__FISH_EZA_BINARY \$EZA_STANDARD_OPTIONS \$$opt_name"
        end
        set -a __FISH_EZA_OPT_NAMES "$opt_name"
        set -a __FISH_EZA_ALIASES "$a"

        for i in (seq (count $__FISH_EZA_EXPANDED))
            set -l name "$a$__FISH_EZA_EXPANDED[$i]"
            # --tree is useless given --all --all
            if test $name = ltaa; or test $name = ltaac
                continue
            end
            set -l exp_opt_name (string join '_' "EZA" $__FISH_EZA_EXPANDED_OPT_NAME[$i] "OPTIONS")
            if string match --quiet 'll*' "$name"
                alias --save "$name" "eza_git \$$exp_opt_name"
            else
                alias --save "$name" "$__FISH_EZA_BINARY \$EZA_STANDARD_OPTIONS \$$exp_opt_name \$$opt_name"
            end
            set -a __FISH_EZA_ALIASES "$name"

            if not contains $exp_opt_name $__FISH_EZA_OPT_NAMES
                set -a __FISH_EZA_OPT_NAMES $exp_opt_name
            end
        end
    end
end

function __fish_eza_update --on-event fish-eza_update
    __fish_eza_uninstall
    __fish_eza_install
end

function __fish_eza_uninstall --on-event fish-eza_uninstall
    for a in $__FISH_EZA_ALIASES
        functions --erase $a
        funcsave $a
    end

    set --erase __FISH_EZA_BASE_ALIASES
    set --erase __FISH_EZA_ALIASES
    set --erase __FISH_EZA_EXPANDED
    set --erase __FISH_EZA_EXPANDED_OPT_NAME
    set --erase __FISH_EZA_OPT_NAMES
    set --erase __FISH_EZA_SORT_OPTIONS
    set --erase __FISH_EZA_BINARY
end
