function generatePassword(){
    length=${1:-40}
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


function createSSMsecret(){
    ssmPath=${1}
    hasSpecial=${3:-true}
    passLength=${4:-40}

    params=$( aws ssm describe-parameters --filters "Key=Name, Values=['${ssmPath}']" --query 'Parameters | length([*])' )

    if [[ "${params}" == "0" ]]; then
        password=$( generatePassword ${passLength} )
    fi

    aws ssm put-parameter \
        --name "${ssmPath}" \
        --type String \
        --value ${password:0:${passLength}} 

}
