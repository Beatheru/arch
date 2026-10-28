log() {
  local red="\033[0;31m" green="\033[0;32m" yellow="\033[0;33m" blue="\033[0;34m" nc="\033[0m"
  local level="$1"
  shift
  local message="$*"

  case "$level" in
    INFO)
      echo -e "${blue}[INFO]${nc} - ${message}"
      ;;
    SUCCESS)
      echo -e "${green}[SUCCESS]${nc} - ${message}"
      ;;
    WARN)
      echo -e "${yellow}[WARN]${nc} - ${message}"
      ;;
    ERROR)
      echo -e "${red}[ERROR]${nc} - ${message}"
      ;;
    *)
      echo -e "[LOG] - ${message}"
      ;;
  esac
}

export -f log
