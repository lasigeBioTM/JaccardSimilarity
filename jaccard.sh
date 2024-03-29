#!/bin/bash
IFS='\n'

# USAGE
# ./jaccard.sh "[21034, 2694, 56829, 10564, 36313, 11795]" "[21034, 2694, 29315, 331, 10564, 3234, 53368, 19625]" decs.obo 
# ./jaccard.sh "[21034, 2694, 56829, 10564, 36313, 11795]" "[21034, 2694, 29315, 331, 10564, 3234, 53368, 19625]" decs.obo 10
# ./jaccard.sh "2841,1324" "1324,1323" doid.obo 
# ./jaccard.sh "2841,1324" "1324,1323" doid.obo 2

S1=$1 # input set of terms 
S2=$2 # input set of terms

OBOFILE=$3 # input OBO filename

if [ -z "$4" ]
then
    MAXANCESTRYLEVEL=-1
else
    MAXANCESTRYLEVEL=$4
fi

    

# convert OBO file in one term per line
OBOLINE=$(tr '\n' ' ' < $OBOFILE | sed -E 's/\[Term\]/\n\[Term\]/g' | sed -E 's/[A-Z]+:([0-9]+)/\1/g')

parents () {
    S=$1 # input set of terms 
    SID=$(sed 's/^/id: /' <<< $S)
    P=$(grep -w -F -f <(echo $SID) <<< $OBOLINE | \
	    grep -o -E 'is_a: [0-9]+' | \
	    sed 's/is_a: //' | sort -u)
    echo $P
}

ancestors () {
    S=$1 # input set of terms 
    A=$S # includes the terms themselves 
    AOLD=''
    COUNTER=$MAXANCESTRYLEVEL
    while [[ $(echo -e $AOLD | wc -l) -eq $(echo -e $A | wc -l) ]] || [[ $COUNTER -ne 0 ]]; do
	P=$(parents $S)
	AOLD=$A
	A=$(cat <(echo $AOLD) <(echo $P) | sort -u)
        S=$P
	let COUNTER-=1
    done
    echo $A
}

union () {
    A1=$1
    A2=$2
    A=$(cat <(echo $A1) <(echo $A2) | sort -u)
    echo -e $A
}

intersection () {
    A1=$1
    A2=$2
    A=$(grep -w -F -f <(echo $A1) <(echo $A2) | sort -u)
    echo -e $A
}


S1L=$(tr ',' '\n' <<< $S1 | tr -d '[] ')
S2L=$(tr ',' '\n' <<< $S2 | tr -d '[] ')

A1=$(ancestors $S1L)
A2=$(ancestors $S2L)


#diff <(echo $A1) <(echo $A2)

U=$(union $A1 $A2)
I=$(intersection $A1 $A2)


# count the members
IN=$(cat <(echo $I) | wc -l)
UN=$(cat <(echo $U) | wc -l)

echo "$IN / $UN" | bc -l 


