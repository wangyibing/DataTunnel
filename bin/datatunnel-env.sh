#!/bin/sh

# Make sure prerequisite environment variables are set
if [ -z "$JAVA_HOME" -a -z "$JRE_HOME" ]; then
  JAVA_PATH=`which java 2>/dev/null`
  if [ "x$JAVA_PATH" != "x" ]; then
    JAVA_PATH=`dirname $JAVA_PATH 2>/dev/null`
    JRE_HOME=`dirname $JAVA_PATH 2>/dev/null`
  fi
  if [ "x$JRE_HOME" = "x" ]; then
    if [ -x /usr/bin/java ]; then
      JRE_HOME=/usr
    fi
  fi
  if [ -z "$JAVA_HOME" -a -z "$JRE_HOME" ]; then
    echo "Neither the JAVA_HOME nor the JRE_HOME environment variable is defined"
    echo "At least one of these environment variable is needed to run this program"
    exit 1
  fi
fi

if [ -z "$JRE_HOME" ]; then
  JRE_HOME="$JAVA_HOME"
fi

if [ -z "$BASEDIR" ]; then
  echo "The BASEDIR environment variable is not defined"
  echo "This environment variable is needed to run this program"
  exit 1
fi

# Set standard CLASSPATH
if [ "$1" = "debug" -o "$1" = "javac" ] ; then
  if [ -f "$JAVA_HOME"/lib/tools.jar ]; then
    CLASSPATH="$JAVA_HOME"/lib/tools.jar
  fi
fi

echo "===================="$BASEDIR

for lib in "$BASEDIR"/lib/*.jar
do
  CLASSPATH=$CLASSPATH:$lib
done
CLASSPATH=$CLASSPATH:"$BASEDIR"/conf

# Set standard commands for invoking Java.
RUNJAVA="$JRE_HOME"/bin/java
