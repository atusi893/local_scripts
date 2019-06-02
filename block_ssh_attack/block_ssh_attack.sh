#!/bin/sh

#####################################################################
# 参考URL:http://search.luky.org/linux-users.a/msg04927.html
# SWATCHから起動させる
# /usr/bin/swatch -c /root/.swatchrc_block_ssh_attack -t /var/log/secure
# 
#####################################################################


# arg1 : login user name
# arg2 : ip addr ( can be given by tcpd )
# arg3 : suspend time in minutes

export NUMLOGBACK=30
export ACCEPT_ATTACK=5
export LOGFILE=/var/log/secure
export SSHPORT=22
export WHITELIST="hosta.example.org hostb.example.org"
export MAILCMD=mail

# 引数
export IPADDR=`echo "$2" | sed -e 's/^.*Invalid user ident from \(.*\)$/\1/g'`
export SUSPENDMIN=$3

## DEBUG START
DEBUG_STR01="["`date`"]"
DEBUG_STR02="IPADDR="$IPADDR
## DEBUG END

# ホワイトリストを定義
whitelist()
{
    echo "checking white list ${IPADDR?}"
    for i in $WHITELIST;do
    #host $i | awk '{ print $4 }'
        host $i | awk '{ print "x" $4 "x" }' | grep "x${IPADDR?}x" > /dev/null && return 0;
    done
    #echo "not in white list"
    return 1;
}

# 何回目のアクセスかカウント、制限値を超えるとTRUE
CNT=`tail -${NUMLOGBACK?} ${LOGFILE?} | egrep -ic "sshd\[.*\]: invalid user .* from ${IPADDR?}"` > /dev/null
if [ $CNT -ge ${ACCEPT_ATTACK?} ]; then
    export MATCH=TRUE
fi
DEBUG_STR03="COUNT=""$CNT""/""${ACCEPT_ATTACK?}"

# ホワイトリストに無ければTRUE
[ x$MATCH = xTRUE ] && whitelist && export MATCH=TRUE

# TRUEならば以下を実行、アタック元IPアドレスがhosts.denyになければ追記
if [ x$MATCH = xTRUE ]; then
    DEBUG_STR04="STATUS=BLOCKED"  # DEBUG
    cat /etc/hosts.deny | grep "${IPADDR?}" > /dev/null
    if [ $? != 0 ]; then
        DEBUG_STR05="NOT IN THE WHITELIST." # DEBUG

        echo "sshd:   ${IPADDR?}" >> /etc/hosts.deny

        logger -p authpriv.info -t SSHBLOCK "BLOCKING IP ${IPADDR?} !!!"
        echo "blocking ssh from ip `host ${IPADDR?}`($IPADDR)" | $MAILCMD -s sshd-block-${IPADDR?} root
        DEBUG_STR06="INSERT HOSTS.DENY ${IPADDR?} !!"
    fi
else
    DEBUG_STR04="STATUS=ACCEPT" # DEBUG
fi

## DEBUG OUTPUT
echo \
$DEBUG_STR01"	" \
$DEBUG_STR02"	" \
$DEBUG_STR03"	" \
$DEBUG_STR04"	" \
$DEBUG_STR05"	" \
$DEBUG_STR06"	" \
 | tee -a /usr/local/bin/block_ssh_attack.log
## DEBUG OUTPUT
