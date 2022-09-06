WORKDIR=`pwd`
rm lambda.zip
virtualenv buildenv
source buildenv/bin/activate
pip install -r requirements.txt
pip install -e .
cd buildenv/lib/python3.8/site-packages
zip -r ../../../../lambda.zip .
cd $WORKDIR
zip -r lambda.zip ahp_gaussiano -x "ahp_gaussiano/__pycache__/*"
rm -r buildenv