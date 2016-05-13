### Get your book pdf-file ready for print!  
  
#### REQUIREMENTS  

        pdftk
        pdfcrop

In Ubuntu they can be installed with:  

        apt-get install pdftk textlive-extra-utils

  
#### EXECUTION  
1) Optionally: split your pdf file into blocks (you can use pdftk).  
  
2) Put the files you want to crop to the input directory in script root, or, alternatively, put the files into any directory and path it's root as argument.  
     
3) Set preffered margins (boundaries) for pages in pdfbook.sh  
  
4) Modify the rights for script execution:

        chmod u+x /path/to/pdfbook.sh
          
5) Pass your input or use embedded with script input directory:  

        /path/to/pdfbook.sh [root of input directory with pdf-files]
