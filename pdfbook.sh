#! /bin/zsh

# Preffered boundaries (margins) for left page
left=85
top=40
right=20
down=50

PRJ_HOME=${0:a:h}

croppdf() {
    lim=$(pdfinfo $FILE | grep Pages | awk '{print $2}')
    imax=$(($lim/2))
    i=0
    while (( i++ < imax )); do
        ieven[i]=$((2*i))
        iodd[i]=$((2*i-1))
    done
    oddfile=${FILE%.pdf}-odd.pdf
    evenfile=${FILE%.pdf}-even.pdf

    # Split pages into odd and even
    pdftk $FILE cat $iodd output $oddfile
    pdftk $FILE cat $ieven output $evenfile

    # Modify pages margins
    pdfcrop $oddfile --margins "$left $top $right $down" $oddfile
    pdfcrop $evenfile --margins "$right $top $left $down" $evenfile

    # Group odd and even pages
    i=1
    while (( i < lim )); do
        order[i++]="A$(($i/2+1))"
        order[i++]="B$(($i/2))"
    done
    outputfile=$PRJ_HOME/output/${FILE#$PRJ_HOME*/*/}
    outputdir=${outputfile%/*}
	if ! [[ -d $outputdir ]]; then mkdir -p $outputdir; fi
    pdftk A=$oddfile B=$evenfile cat $order output $outputfile
    rm $oddfile $evenfile
}

# Set input directory
if [[ -d $1 ]]; then CURR_DIR=$1; else CURR_DIR=$PRJ_HOME; fi

# Create or clean ouput directory
if ! [[ -d ${CURR_DIR}/output ]]; then
	mkdir ${CURR_DIR}/output
else
	while ! (( $match )); do
		printf "%s " "Delete all data in $CURR_DIR/output? (y/n):"
		read DELETE;
		if [[ $DELETE =~ "^[yYnN]$" ]]; then match=1; fi
	done
	if [[ $DELETE =~ "^[yY]$" ]]; then
		rm -r $CURR_DIR/output/** 2> /dev/null
	fi
fi

for FILE in $CURR_DIR/input/**/*.pdf; do croppdf $FILE; done
