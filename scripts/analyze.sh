# Executes flutter analyzer over each folder of the current path.
for d in */ ; do
    if [[ -f "$d/pubspec.yaml" ]]
    then
        cd $d && flutter analyze .
        cd ..
    fi
done