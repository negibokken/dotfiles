#!/bin/zsh

mktemp() {
    unset dirName;
    unset param;

    usage() {
      cat << EOS
Usage: $PROGNAME [OPTION] [arg1]
    Options:
      -h, --help        show help
      -d, --description Add description for a README.md
          --version     show version
EXAMPLE:
  $PROGNAME arg1 -d "something new file"
EOS
    }
    flag=0
    for OPT in "$@"
    do
        case $OPT in
            -h | --help)
                usage; return 1;;
            --version)
                echo $VERSION; return 1;;
            -d )
                description=$2
                shift 2
                ;;
            -- | -)
                shift 1
                param+=( "$@" )
                break
                ;;
            -*)
                echo "$PROGNAME: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
                return 1
                ;;
            *)
                if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
                    param+=( "$1" )
                    shift 1
                fi
                ;;
        esac
    done

	local dirName=$param
	if [ ! -n "$param" ] ; then
	  dirName=`date +"%Y-%m-%d-%H-%M-%S"`
	fi

    local rootDir="$HOME/temp"
    local devPath="${rootDir}/${dirName}"

    if [ -e $devPath ]; then
        echo "The directory alredy exists"
        return 1
    fi

    mkdir -p ${devPath}
    echo "Created ${devPath}"
    cd ${devPath}
    echo "# $dirName\n" >> README.md
    if [ "$description" != "" ]; then
        echo "## Description\n\n$description" >> README.md
    fi
}
