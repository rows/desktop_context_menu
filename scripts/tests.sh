# Runs tests over each folder of the current path.
for d in */ ; do
    if [ -d "$d/test" ] && [ -f "$d/pubspec.yaml" ]
    then
        cd $d && flutter test .
        cd ..
    fi
done