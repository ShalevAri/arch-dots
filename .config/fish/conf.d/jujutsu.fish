### JUJUTSU.FISH ###

function jpm
    jj bookmark set main -r @
    if test $status -eq 0
        jj git push
    else
        echo "ERR: The command 'jj bookmark set main -r @' failed. not pushing."
    end
end

function js
    jj
    if test $status -eq 0
        jj st
    else
        echo "ERR: The 'jj' command failed to run."
    end
end
