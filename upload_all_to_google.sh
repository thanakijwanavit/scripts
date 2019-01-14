POSITIONAL=()
DIRECTORYID="0B-C4DxL6rY3OMUJ1TzdwN3l6c1E"
while [[ $# -gt 0 ]]
do
key="$1"


case $key in
    -i|--dir-id)
    DIRECTORYID="$2"
    shift # past argument
    shift # past value
    ;;
    -s|--searchpath)
    SEARCHPATH="$2"
    shift # past argument
    shift # past value
    ;;
    -l|--lib)
    LIBPATH="$2"
    shift # past argument
    shift # past value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters



for f in *; do
  echo "file $f is uploading to $DIRECTORYID"
  gdrive upload -r -p $DIRECTORYID $f
done
