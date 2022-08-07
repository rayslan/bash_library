function generatePassword(){
    length=${1}
    pass=$( choose() { echo ${1:RANDOM%${#1}:1} $RANDOM; }
            {
                choose '!@#$%^\&'
                choose '0123456789'
                choose 'abcdefghijklmnopqrstuvwxyz'
                choose 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
                    for i in $( seq 1 $(( ((${length}-4)) )) )
                        do
                            choose '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ'
                        done
            } | sort -r | awk '{printf "%s",$1}' )
    
    echo $pass
}

var=$(generatePassword)

echo $var