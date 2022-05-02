# Executes flutter formatter over each folder of the current path.
for d in */ ; do
    if [[ -f "$d/pubspec.yaml" ]]
    then
        cd $d && flutter format --set-exit-if-changed .
        cd ..
    fi
done