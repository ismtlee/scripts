ROOT=/usr/deploy/jmeter/new/
rm -rf ${ROOT}log.xml

#java -jar ${ROOT}jakarta-jmeter-2.5.1/bin/ApacheJMeter.jar -n -t ${ROOT}orange.jmx -l ${ROOT}/log.xml
java -jar ${ROOT}apache-jmeter-2.6/bin/ApacheJMeter.jar -n -t ${ROOT}monster.jmx -l ${ROOT}/log.xml

