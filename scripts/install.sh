# Runs `flutter pub get` over each folder of the current path.
for d in */ ; do
    if [ -f "$d/pubspec.yaml" ]
    then
        cd $d && flutter pub get
        cd ..
    fi
done