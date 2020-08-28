is_submodule ()
{
    (git rev-parse --is-inside-work-tree > /dev/null 2>&1 && 
        cd "$(git rev-parse --show-toplevel)/..") | grep -q true
}

git_prompt_useremail() {
    if git config --get --local user.email > /dev/null 2>&1; then
        # echo $(git config --get --local user.email)
    else
        GLOBAL_EMAIL=$(git config --get user.email)
        read "response?Local email not found, use $GLOBAL_EMAIL instead? [Y/n] "
        case  "$response" in
            [nN][oO]|[nN])
                return 1
                ;;
            *)
                git config --local user.email $GLOBAL_EMAIL 
            ;;
        esac
    fi
}

main() {
    if is_submodule; then
        return 1
    fi
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        git_prompt_useremail
    fi
}

precmd() { main }
