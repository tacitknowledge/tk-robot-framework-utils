export DISPLAY=:99
unset http_proxy
unset https_proxy
unset ftp_proxy

echo "Starting second shell"
ATTEMPTS=0
SLEEP=60
URL="http://smoke-hybdev.europe.odcorp.net/"

while [ "$ATTEMPTS" -lt 3 ]; do
    ATTEMPTS=$((ATTEMPTS+1))
    STATUS="$(curl -sL -w "%{http_code}\n" "$URL" -o /dev/null)"
    if [ "$STATUS" -eq 200 ]; then
        echo "Starting Robot..."
		export DISPLAY=:99
        export PATH=/opt/chef/embedded/bin:$PATH
        pybot --variable FIREFOX_PROFILE:/app/jenkins/.mozilla/firefox/526alpyd.fe_auto_tests/ --include "CI" --variablefile resources/platforms/platform_local.py --variablefile resources/locales/at_en_variables.py --variablefile resources/environments/smoke-hybdev.py test-suites/Smoke/
		mkdir -p ../robot/report
        cp *.png ../robot/report/
        break
    else
        echo "Site is not available, will retry in $SLEEP seconds..."
        sleep $SLEEP
    fi
done

if (("$ATTEMPTS" >= 3)); then
    echo "Site is not available, will skip the test!"
fi

exit 0
