### COLORSCRIPTS.FISH ###

function fish_greeting
    set possible_paths \
        "$HOME/personal/colorscripts" \
        "$HOME/.dotfiles/personal/colorscripts"
    
    set colorscripts_dir ""
    
    for path in $possible_paths
        if test -d "$path"
            set colorscripts_dir "$path"
            break
        end
    end
    
    if test -n "$colorscripts_dir"
        set art_files "$colorscripts_dir"/*.txt
        
        if test -f $art_files[1]
            set random_file $art_files[(random 1 (count $art_files))]
            
            echo
            if command -v lolcat >/dev/null 2>&1
                cat "$random_file" | lolcat
            else
                set_color cyan
                cat "$random_file"
                set_color normal
            end
            echo
        else
            echo "Welcome to fish! 🐟"
            echo "Add some ASCII art files (.txt) to $colorscripts_dir to see random art here!"
        end
    else
        echo "Welcome to fish! 🐟"
        echo "Colorscripts directory not found. Expected at ~/personal/colorscripts (symlink of ~/.dotfiles/personal/colorscripts)"
    end
end 