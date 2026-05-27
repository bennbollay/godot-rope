find . -not \( -path "./addons/*" \) -name \*.gd -exec gdscript-formatter {} \;
