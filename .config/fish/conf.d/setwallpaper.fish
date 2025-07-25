### SETWALLPAPER.FISH  ###

function setwallpaper
    set wallpaper_name "sakura-girl.jpg"
    set target_wall "$HOME/.dotfiles/walls/$wallpaper_name"
    if test -f "$target_wall"
        hyprctl hyprpaper reload ,"$target_wall"
    else
        echo "Warning: $wallpaper_name not found, using first available wallpaper"
        set fallback_wall (find "$HOME/.dotfiles/walls" -name "*.jpg" -o -name "*.png" | head -1)
        if test -n "$fallback_wall"
            hyprctl hyprpaper reload ,"$fallback_wall"
        else
            echo "Error: No wallpapers found in $HOME/.dotfiles/walls"
        end
    end
end
