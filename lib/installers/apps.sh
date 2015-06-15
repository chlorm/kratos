# Application specific configuration

echo "Configurating applications"
for APP in `find $DOTFILES_DIR/lib/installers/app_specific/ -type f` ; do
  APP="$(basename $APP | sed -e 's/\.sh//')"
  if eval app_${APP}_configure ; then
    echo "  ☑ $APP"
  else
    case "$?" in
      '2')
        echo "  ☐ $APP"
        ;;
      '1')
        echo "  ☒ $APP"
        ;;
      *)
        echo "ERROR: asdf"
        exit 1
        ;;
    esac
    eval app_${APP}_cleanup
    continue
  fi
done

unset APP
