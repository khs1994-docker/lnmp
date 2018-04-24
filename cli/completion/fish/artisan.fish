#
# @link https://github.com/adriaanzon/fish-artisan-completion
#

function __fish_artisan_commands_with_descriptions
  php artisan list --raw ^ /dev/null | grep -vE '^ ' | string replace -r '\s+' '\t'
end

function __fish_artisan_commands
  __fish_artisan_commands_with_descriptions | cut -f 1
end

complete -c artisan -f -n 'test -f artisan; and __fish_use_subcommand' -a '(__fish_artisan_commands_with_descriptions)'
complete -c artisan -f -n 'test -f artisan; and __fish_seen_subcommand_from help' -a '(__fish_artisan_commands)'
